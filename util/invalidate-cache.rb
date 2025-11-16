#!/usr/bin/env ruby
# joshbeard.me CloudFront cache invalidation
#
# Intelligently invalidates CloudFront cache based on changes in src/.
# Maps Jekyll source paths to output paths and handles special directories
# that affect the whole site.
#
# Requirements:
#   - AWS auth
#   - CF_DISTRIBUTION environment variable
#   - AWS_REGION environment variable (optional, default: us-east-1)
#   - Ruby
#   - 'aws' command

require 'open3'
require 'set'
require 'json'
require 'yaml'

COLOR_RESET = "\033[0m"
COLOR_CYAN = "\033[36m"
COLOR_YELLOW = "\033[33m"
COLOR_GREEN = "\033[32m"
COLOR_RED = "\033[31m"

AWS_REGION = ENV.fetch('AWS_REGION', 'us-east-1')

# Files/patterns that affect the whole site (invalidate everything)
GLOBAL_CHANGES = [
  'Gemfile',
  'Gemfile.lock',
  '_config.yml',
  'util/photos.rb',
  'src/_data/',
  'src/_includes/',
  'src/_layouts/',
  'src/_plugins/',
  'src/assets/'
].freeze

def check_aws_auth
  stdout, stderr, status = Open3.capture3('aws', 'sts', 'get-caller-identity', '--output', 'json')
  unless status.success?
    $stderr.puts "#{COLOR_RED}Error: AWS authentication failed#{COLOR_RESET}"
    $stderr.puts stderr unless stderr.empty?
    exit 1
  end
end

def check_requirements
  if ENV['CF_DISTRIBUTION'].to_s.empty?
    $stderr.puts "#{COLOR_RED}Error: CF_DISTRIBUTION environment variable required#{COLOR_RESET}"
    exit 1
  end
  check_aws_auth
end

def run_command(*cmd)
  stdout, stderr, status = Open3.capture3(*cmd)
  [stdout, stderr, status]
end

def git_commit_exists?(commit)
  _, _, status = run_command('git', 'rev-parse', '--verify', commit)
  status.success?
end

def get_base_commit
  return ENV['GITHUB_EVENT_BEFORE'] if ENV['GITHUB_EVENT_BEFORE'] &&
    ENV['GITHUB_EVENT_BEFORE'] != '0000000000000000000000000000000000000000' &&
    git_commit_exists?(ENV['GITHUB_EVENT_BEFORE'])
  return 'origin/master' if git_commit_exists?('origin/master')
  return 'HEAD~1' if git_commit_exists?('HEAD~1')
  $stderr.puts "#{COLOR_RED}Error: Cannot determine base commit#{COLOR_RESET}"
  exit 1
end

def get_current_commit
  return ENV['GITHUB_SHA'] if ENV['GITHUB_SHA'] && git_commit_exists?(ENV['GITHUB_SHA'])
  'HEAD'
end

def get_changed_files(base_commit, current_commit)
  # Get all changed files (not just src/)
  stdout, _, status = run_command(
    'git', 'diff', '--name-only', '--diff-filter=ACDMRT',
    base_commit, current_commit
  )
  return [] unless status.success?
  stdout.lines.map(&:chomp).reject(&:empty?)
end

# Extract permalink from Jekyll frontmatter
def get_permalink(file_path)
  return nil unless File.exist?(file_path)

  content = File.read(file_path)
  # Match YAML frontmatter between --- markers
  match = content.match(/^---\s*\n(.*?)\n---\s*\n/m)
  return nil unless match

  begin
    frontmatter = YAML.safe_load(match[1])
    permalink = frontmatter['permalink']
    return permalink if permalink
  rescue
    # If YAML parsing fails, try simple regex
    permalink_match = match[1].match(/^permalink:\s*(.+)$/m)
    return permalink_match[1].strip if permalink_match
  end

  nil
rescue
  nil
end

def directory_exists_in_commit?(commit, path)
  _, _, status = run_command('git', 'ls-tree', '-r', '--name-only', commit, '--', "#{path}/")
  status.success?
end

# Convert src/ path to output path
def src_to_output_path(src_path, base_commit: nil)
  # Check for permalink in frontmatter first (only for .md/.html files)
  if (src_path.end_with?('.md') || src_path.end_with?('.html'))
    # Try to get permalink from current file
    permalink = get_permalink(src_path)
    if permalink
      # Normalize permalink (remove trailing slash, ensure leading slash)
      permalink = permalink.chomp('/')
      return permalink.start_with?('/') ? permalink : "/#{permalink}"
    end
  end

  # For all other files (static assets, .txt, .xml, etc.), map directly
  # Remove src/ prefix
  path = src_path.sub(%r{^src/}, '')

  # Handle index files - map to directory (only for .md/.html)
  if File.basename(path) =~ /^(index|404)\.(md|html)$/
    dir = File.dirname(path)
    path = dir == '.' ? '' : dir
  end

  # Remove .md extension (Jekyll converts .md to .html, but we want the directory)
  # Keep all other extensions (.txt, .xml, .ico, .png, etc.)
  path = path.sub(/\.md$/, '')

  # Ensure leading slash (empty path becomes /)
  path.empty? ? '/' : "/#{path}".gsub(%r{//+}, '/')
end

# Determine invalidation paths from changed files
def determine_invalidation_paths(changed_files, base_commit)
  paths = Set.new
  global_change = false

  changed_files.each do |file|
    # Check if this is a global change (build deps or structural directories)
    if GLOBAL_CHANGES.any? { |pattern| file.start_with?(pattern) }
      global_change = true
      next
    end

    # Skip if not under src/
    next unless file.start_with?('src/')

    # Map src path to output path (check for permalink)
    output_path = src_to_output_path(file, base_commit: base_commit)

    # For root index, invalidate everything
    if output_path == '/'
      global_change = true
      next
    end

    # Check if this is a new directory (parent didn't exist)
    dir_path = File.dirname(file)
    if dir_path != 'src' && dir_path != '.' && !directory_exists_in_commit?(base_commit, dir_path)
      # New directory - invalidate the parent
      parent_output = src_to_output_path(dir_path, base_commit: base_commit)
      paths << "#{parent_output}*" if parent_output != '/'
    else
      # For .md/.html files (pages), invalidate the directory with wildcard
      # For static files (.txt, .xml, .ico, etc.), invalidate the exact path
      if file.end_with?('.md') || file.end_with?('.html')
        paths << "#{output_path}*"
      else
        # Static assets - invalidate exact path
        paths << output_path
      end
    end
  end

  # If global change, invalidate everything
  return Set.new(['/*']) if global_change

  paths
end

def invalidate_paths(paths)
  return if paths.empty?

  puts "#{COLOR_CYAN}Invalidating CloudFront cache:#{COLOR_RESET}"
  paths.sort.each { |path| puts "  #{path}" }
  puts

  cmd = [
    'aws', 'cloudfront', 'create-invalidation',
    '--distribution-id', ENV['CF_DISTRIBUTION'],
    '--paths', *paths.sort,
    '--region', AWS_REGION,
    '--output', 'json'
  ]

  stdout, stderr, status = run_command(*cmd)

  unless status.success?
    $stderr.puts "#{COLOR_RED}Error: Failed to create invalidation#{COLOR_RESET}"
    $stderr.puts stderr unless stderr.empty?
    exit 1
  end

  begin
    response = JSON.parse(stdout)
    invalidation_id = response.dig('Invalidation', 'Id')
    puts "#{COLOR_GREEN}Invalidation created: #{invalidation_id}#{COLOR_RESET}" if invalidation_id
  rescue JSON::ParserError
    puts "#{COLOR_GREEN}Invalidation created successfully#{COLOR_RESET}"
  end
end

def main
  check_requirements

  # If paths provided as arguments, use them directly
  if ARGV.any?
    paths = ARGV.map do |p|
      # Ensure leading slash
      p = p.start_with?('/') ? p : "/#{p}"
      # If path ends with /, convert to wildcard (e.g., /now/ → /now*)
      p = p.chomp('/') + '*' if p.end_with?('/')
      p
    end
    invalidate_paths(paths)
    return
  end

  # Otherwise, detect changes from git
  unless run_command('git', 'rev-parse', '--git-dir')[2].success?
    $stderr.puts "#{COLOR_RED}Error: Not in a git repository and no paths provided#{COLOR_RESET}"
    exit 1
  end

  base_commit = get_base_commit
  current_commit = get_current_commit

  puts "#{COLOR_CYAN}Comparing #{base_commit}..#{current_commit}#{COLOR_RESET}"
  puts

  changed_files = get_changed_files(base_commit, current_commit)

  if changed_files.empty?
    puts "#{COLOR_YELLOW}No changes detected#{COLOR_RESET}"
    return
  end

  # Filter to only src/ and build dependencies
  relevant_files = changed_files.select do |file|
    file.start_with?('src/') ||
    GLOBAL_CHANGES.any? { |pattern| !pattern.start_with?('src/') && file.start_with?(pattern) }
  end

  if relevant_files.empty?
    puts "#{COLOR_YELLOW}No relevant changes detected (src/ or build dependencies)#{COLOR_RESET}"
    return
  end

  invalidation_paths = determine_invalidation_paths(relevant_files, base_commit)

  if invalidation_paths.empty?
    puts "#{COLOR_YELLOW}No paths to invalidate#{COLOR_RESET}"
    return
  end

  invalidate_paths(invalidation_paths)
end

main if __FILE__ == $0


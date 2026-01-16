# Development Notes

## Building

```shell
make build
```

Runs `jekyll build` in Docker and produces a `./_site/` directory to publish.

## Running

To serve the site with `jekyll serve` in a container:

```shell
make serve
```

This will start a local server available at <http://localhost:4000/>

```shell
make nginx
```

This serves the built site from `_site` with Nginx on <http://localhost:8080>

## Photo Albums

My [photos](https://joshbeard.com/photos) are hosted on S3 and the HTML pages
are generated using a bundled [custom plugin](src/_plugins/gallery_generator.rb),
adapted from the original plugin at <https://github.com/kylemarsh/jekyll-gallery-generator>.

My plugin uses the `images` key in the `album.yml` file as the source of truth
for which images are in each album. This allows the Jekyll build to run without
the image files present locally - they are not in Git. The `album.yml` file is
generated and maintained by the `photos.rb` script, but can be manually edited
to add descriptions or adjust metadata.

### Creating and Updating Photo Albums

1. Create a directory under [`photos/`](photos/) for new albums.
2. Place images (preferably JPEG images with a `.jpg` extension) in the appropriate album directory.
3. Create an initial `album.yml` file within the album directory with basic metadata:
   ```yaml
   meta_title: Album Title
   description: Album description
   images: {}
   ```
   The `images` hash will be automatically populated by the script.
4. Process the photo album(s) using the script:
   ```shell
   ./util/photos.rb photos/2022
   ```
   This processes a specific album. To process all albums:
   ```shell
   ./util/photos.rb
   ```

   The script supports several options:
   - `--dry-run`: Preview what would be done without making changes
   - `--sync`: Upload to S3 and set cache headers (default: local processing only)

   Examples:
   ```shell
   ./util/photos.rb photos/2022                    # Local processing only
   ./util/photos.rb --sync photos/2022             # Include S3 upload
   ./util/photos.rb --dry-run --sync photos/2022   # Preview S3 operations
   ```

   Refer to the [`photos.rb`](util/photos.rb) script for details about what it does and its
   requirements. In summary, this will:
     * Update `album.yml` with the `images` key, preserving existing entries and
       adding new local images. This serves as the source of truth for the Jekyll plugin.
     * Remove EXIF data from images (using exiv2)
     * Create image thumbnails (using mogrify)
     * Generate Gemini pages (`index.gmi`)
     * Optionally (with `--sync`): Upload to S3 and set cache-control headers

   **Important**: The script preserves all existing entries in the `images` hash,
   even if those images aren't present locally. This means you can add new photos
   to an album without losing references to photos that were previously uploaded.

5. Edit `album.yml` to add descriptions for images (optional):
   ```yaml
   images:
     IMG_0001.jpg: "A beautiful sunset"
     IMG_0002.jpg: "Mountain landscape"
   ```

6. Run `jekyll build` or `jekyll serve` to preview the results.
7. Git commit and push the changes. Only the `album.yml` file is committed to Git
   for photo albums (images are stored on S3).

### Components of Photo Album Generation

* __[`src/_plugins/gallery_generator.rb`](src/_plugins/gallery_generator.rb)__

  Custom Jekyll plugin for generating the HTML pages for albums and photos.

* __[`src/layouts/album_index.html`](src/layouts/album_index.html)__

  HTML template for a photo album index, which lists each photo in an album.

* __[`src/layouts/image_page.html`](src/layouts/image_page.html)__

  HTML template for an individual photo page.

* __[`src/layouts/photos.html`](src/layouts/photos.html)__

  HTML template for the main /photos/ page, which lists each album with a
  thumbnail.

* __`src/photos/*/album.yml`__

  Configuration and metadata file for a photo album. This file is generated and
  maintained by `photos.rb`, but can be manually edited to add image descriptions
  or adjust metadata. The `images` key in this file serves as the source of truth
  for which images are in the album - the Jekyll plugin uses this to generate pages
  without requiring image files to be present locally.

  The `images` key is a hash where:
  - Keys are image filenames
  - Values are optional descriptions for each image

  Refer to the
  [`src/_plugins/gallery_generator.rb`](src/_plugins/gallery_generator.rb) file for
  complete documentation of all available keys.

* __[`util/photos.rb`](util/photos.rb)__

  Helper script for preparing and deploying my images.

### CloudFront Cache Invalidation

After deploying changes, you may need to invalidate the CloudFront cache to ensure
visitors see the updated content. The [`util/invalidate-cache.rb`](util/invalidate-cache.rb)
script intelligently determines which paths need invalidation based on changes in `src/`:

- **Global changes** (`_data`, `_includes`, `_layouts`, `_plugins`, `assets`): Invalidates `/*` (everything)
- **Page changes**: Invalidates only the affected paths (e.g., `/photos/2021*`, `/about*`)
- **New directories**: Invalidates the parent directory

The script can be used in two ways:

**Automatic (detects changes from git):**
```shell
# In CI: automatically detects changes and invalidates accordingly
ruby util/invalidate-cache.rb
```

**Manual (specify paths directly):**
```shell
# Invalidate specific paths
ruby util/invalidate-cache.rb /photos/2021 /about
```

**Requirements:**
- AWS auth
- `CF_DISTRIBUTION` environment variable (CloudFront distribution ID)
- `AWS_REGION` environment variable (optional, default: us-east-1)

The script is automatically run in CI after deployment if changes are detected in `src/`.

## Screenshots

Screenshots aren't committed to the repository. Instead, they are uploaded
directly to S3 and referenced in the Markdown files.

Use the [`util/upload-shots.sh`](util/upload-shots.sh) script to upload
screenshots from [`src/screenshots/`](src/screenshots/) to S3.

```shell
./util/upload-shots.sh
```

## `security.txt`

To update the [`src/security.txt`](src/security.txt) file, run the following:

```shell
./util/security-txt-gen.sh
```

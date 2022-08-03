# joshbeard.me photo album deployer
#
# This hacky script handles the 'build' and deployment of my photo albums.
#
# It does the following:
#   - Creates a file list (file_list.txt) for each album for Jekyll to use to
#     generate the pages.
#   - Removes exif data from images (usinv exiv2)
#   - Creates image thumbnails (using mogrify)
#   - Syncs albums to S3
#   - Sets the cache-control headers on the S3 objects
#   - Generates Gemini pages and uploads them to S3
#
# Requirements:
#   - AWS credentials should be set in the environment prior to running:
#     AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION
#   - Python 3
#   - 'mogrify' from ImageMagick for thumbnail generation
#   - 'exiv2' command for removing exif data
#   - 'aws' command for S3 sync
#
# Usage:
#   foo.py [<album_folder>] ...
#
# Specify a path or multiple space-delimited paths to directories containing
# photos.
#
# NOTE: An 'album_info.yml' file should exist in the directory prior to running
# this.
#
import os
import sys
import yaml
import subprocess
from signal import signal, SIGINT

# ======================================================================
# Configuration
#
# Path to the photos root directory where album sub-directories exist
PHOTO_DIR="photos"
# Filename for the album info file created by the Jekyll plugin
ALBUM_INFO_FILENAME="album_info.yml"
# Filename for the image file list for albums. Created by this script.
ALBUM_LIST_FILENAME="file_list.txt"
# Pixel width of thumbnails to generate
THUMB_WIDTH=230
# Path for thumbs directory relative to the album directory.
THUMB_DIR="thumbs"
S3_BUCKET="joshbeard.me-photos"
# ======================================================================


def handler(signal_received, frame):
    """Handle interruption"""
    print('SIGINT or CTRL-C received. Exiting.')
    exit(0)


def create_album_thumbnails(path):
    """Create thumbnails for images in an album directory

    Uses the 'mogrify' tool to generate thumbnails for images in an album
    directory and places them in the 'THUMBS_DIR' within the album directory.

    Parameters
    ----------
    path : str, required
        The local path to a specific photo
    """
    thumb_dir = os.path.join(path, THUMB_DIR)
    image_list = list_album_images(path)
    print("  ▸ [thumbnails] Generating thumbnails for %s" % path)
    for image in image_list:
        photo = os.path.join(path, image)

        if not os.path.isfile(os.path.join(thumb_dir, image)):
            try:
                args = ['/usr/bin/env', 'mogrify', '-path', thumb_dir, '-resize', str(THUMB_WIDTH), photo]
                subprocess.check_output(args, shell=False)
            except Exception:
                print("    ▹ [thumbnails] Error generating thumbnail for %s" % photo)


def check_image_exif(photo):
    """Check for EXIF data in an image

    Uses the 'exiv2' to check if an image has EXIF data.

    Parameters
    ----------
    photo : str, required
        The local path to a specific photo

    Returns
    -------
    bool
        Boolean specifying whether an image has EXIF data or not
    """
    try:
        args = ['/usr/bin/env', 'exiv2', 'pr', photo]
        subprocess.check_output(args, shell=False)
        return True
    except subprocess.CalledProcessError:
        return False


def remove_image_exif(path):
    """Remove EXIF data from images in an album

    Uses the 'exiv2' tool to remove all EXIF data from all images found in an
    album directory.
    It uses the 'check_image_exif()' function to check if an image has EXIF data
    and will skip it it if it doesn't.

    Parameters
    ----------
    path : str, required
        The local path to an album directory
    """
    print("  ▸ [exif] Removing exif from images in %s" % path)
    image_list = list_album_images(path)
    for image in image_list:
        photo = os.path.join(path, image)
        try:
            if check_image_exif(photo):
                args = ['/usr/bin/env', 'exiv2', 'rm', photo]
                subprocess.check_output(args, shell=False)
            else:
                print("    ▹ [exif] Skipping %s - no exif data found" % photo)
        except Exception as e:
            print("Error removing exif data for %s" % photo)
            print(e)


def create_gemini_photo_pages(album, album_info):
    """Create a Gemini index page for each album

    This writes an 'index.gmi' file within an album directory for use on my
    Gemini capsule. This file isn't exposed over HTTP but is available on my
    Gemini server via the s3fuse mount.

    Parameters
    ----------
    album : str, required
        The local path to an album directory
    album_info : dict, required
        A dict of the album info from an 'album_info.yml' file from the
        'get_album_info()' function.

    Returns
    -------
    str
        The Gemini page as a string
    """
    image_list = list_album_images(album)
    album_index = []
    album_index += ["## " + album]
    album_index += ['']
    album_index += ['=> / Return Home']
    album_index += ['=> /photos/ Return to Photos']
    album_index += ['']
    if 'description' in album_info:
        album_index += [album_info['description']]
        album_index += ['']
    album_index += ['---']
    album_index += ['']

    for file in image_list:
        if file in album_info['photo_descriptions']:
            album_index += [album_info['photo_descriptions'][file]]
        album_index += ["=> /" + os.path.join(album, file) + " " + file]
        album_index += ['']

    gemini_path = os.path.join(album, 'index.gmi')
    gemini_file = open(gemini_path, "w")
    gemini_file.write("\n".join(album_index))
    print("  ▸ [gemini] Wrote Gemini index to %s" % gemini_path)
    gemini_file.close()

    return "\n".join(album_index)


def create_file_list(path):
    """Write a list of images in an album directory to a file

    This writes a 'file_list.txt' (by default) file within an
    album directory with a list of the image filenames in that
    album. This file is used by the Jekyll plugin to generate
    the album pages without requiring the actual files to be
    present.

    Parameters
    ----------
    path : str, required
        The local path to an album directory
    """
    filename = os.path.join(path, ALBUM_LIST_FILENAME)
    images = list_album_images(path)

    file = open(filename, "w")
    file.write("\n".join(images))
    print("  ▸ [file_list] Wrote file list to %s" % filename)
    file.close()


def list_album_images(path):
    """Return list of photos in an album directory

    Parameters
    ----------
    path : str, required
        The local path to an album directory

    Returns
    -------
    list
        a list of base filenames for images in an album directory
    """
    image_list = []
    for file in os.listdir(path):
        if file.lower().endswith(('.jpg', '.jpeg', '.png')):
            image_list.append(file)
    image_list.sort()
    return image_list


def get_album_info(path):
    """Return album info

    Load album info from an 'album_info.yml' file

    Parameters
    ----------
    path : str, required
        The local path to an album directory

    Returns
    -------
    dict
        Returns YAML dict object of album info
    """
    info_file = os.path.join(path, ALBUM_INFO_FILENAME)
    if os.path.isfile(info_file):
        with open(info_file) as stream:
            try:
                return yaml.safe_load(stream)
            except yaml.YAMLError as e:
                print(e)


def exists_in_s3(path):
    """Function to check whether an image exists in S3

    Parameters
    ----------
    path : str, required
        The local path to an album directory

    Returns
    -------
    bool
        A boolean specifying whether a file exists in the S3 bucket.
    """
    args = [
        '/usr/bin/env',
        'aws', 's3', 'ls',
        's3://' + S3_BUCKET + '/' + path
    ]
    ls = subprocess.check_output(args)
    if ls.returncode == 0:
        return True
    return False


def copy_to_s3(path):
    """Synchronize a local album directory to S3

    Parameters
    ----------
    path : str, required
        The local path to an album directory
    """
    print(" ▸ [s3-sync] Syncing %s to S3" % path)
    args = [
        '/usr/bin/env',
        'aws', 's3', 'sync', path,
        's3://' + S3_BUCKET + '/' + path,
        '--delete',
        '--exclude', '*.html',
        '--exclude', '*.yml',
        '--exclude', '*.txt'
    ]
    sync = subprocess.check_output(args, shell=False)
    print(sync)


def set_s3_object_cache(path, maxage=15552000):
    """Set the 'cache-control' on image objects in S3

    Parameters
    ----------
    path : str, required
        The local path to an album directory
    maxage : int, optional
        The duration in seconds for the cache max age
    """
    image_list = list_album_images(path)
    for image in image_list:
        image_file = str(os.path.join(path, image))
        print("  ▸ [s3-cache] Setting S3 object cache control for %s" % image_file)
        args = [
            '/usr/bin/env',
            'aws', 's3', 'cp',
            's3://' + S3_BUCKET + '/' + image_file,
            's3://' + S3_BUCKET + '/' + image_file,
            '--recursive',
            '--acl', 'public-read',
            '--cache-control', 'max-age=' + str(maxage),
        ]
        sync = subprocess.check_output(args, shell=False)
        print(sync)


def parse_album(path):
    """Parse each album

    Parameters
    ----------
    path : str, required
        The local path to an album directory
    """
    if os.path.isdir(path):
        print("≫ Album: %s" % album)

        # Load the 'album_info.yml' file for the album
        album_info = get_album_info(path)

        # Parse images
        create_file_list(path)
        remove_image_exif(path)
        create_album_thumbnails(path)
        create_gemini_photo_pages(path, album_info)

        copy_to_s3(path)
        set_s3_object_cache(path)

        print()
        print("--------------------------------------------------------------------------------")
        print()


if __name__ == '__main__':
    # Prepare and deploy photo album directories
    #
    # Iterate over each album directory specified as an argument. If non are
    # specified, parse the directories in the PHOTO_DIR.
    signal(SIGINT, handler)
    print("╔══════════════════════════════════════════════════════════════════════════════╗")
    print("                                 joshbeard.me")
    print("                            Photo Album Deployment")
    print("╚══════════════════════════════════════════════════════════════════════════════╝")
    print("Arguments: %s" % str(sys.argv))
    print()

    if len(sys.argv) > 1:
        print("here")
        for album in sys.argv[1:]:
            print("Parsing album %s" % album)
            parse_album(album)
    else:
        photo_dir = os.listdir(PHOTO_DIR)
        for album in photo_dir:
            print("Parsing %s" % album)
            parse_album(os.path.join(PHOTO_DIR, album))

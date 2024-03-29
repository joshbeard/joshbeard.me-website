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

My [photos](https://joshbeard.me/photos) are hosted on S3 and the HTML pages
are generated using a bundled [custom plugin](src/_plugins/gallery_generator.rb),
adapted from the original plugin at <https://github.com/kylemarsh/jekyll-gallery-generator>.

My plugin will optionally (by default, in my case) use a "file_list.txt" file
for the list of images instead of the actual files on disk. This is so I can
leave my photos _out of_ Git and still enable the Jekyll site to build the HTML
pages for the photo albums and individual photos.

### Creating and Updating Photo Albums

1. Create a directory under [`photos/`](photos/) for new albums.
2. Place images (preferably JPEG images with a `.jpg` extension) in the appropriate album directory.
3. Create or update the `album_info.yml` file within the album directory.
4. Run `python util/photos.py`. Refer to the
   [`photos.py`](util/photos.py) script for details about what it does and its
   requirements. In summary, this will:
     * Create a file list (file_list.txt) for each album for Jekyll to use to
       generate the pages.
     * Remove exif data from images (usinv exiv2)
     * Create image thumbnails (using mogrify)
     * Sync albums to S3
     * Set the cache-control headers on the S3 objects
     * Generate Gemini pages and uploads them to S3
5. Run `jekyll build` or `jekyll serve` to preview the results.
6. Git commit and push the changes (album_info and file_list files are the only
   things in Git for photo albums).

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

* __`src/photos/*/album_info.yml`__

  File that is manually created with configuration and information for a photo
  album. Refer to the
  [`src/_plugins/gallery_generator.rb`](src/_plugins/gallery_generator.rb) file for
  documentation.

* __`src/photos/*/file_list.txt`__

  File that is generated by `photos.py` that lists each file in an album
  directory for the Jekyll plugin to build with.

* __[`util/photos.py`](util/photos.py)__

  Helper script for preparing and deploying my images.

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

# joshbeard.me

A [Jekyll](https://jekyllrb.com/) site for my personal landing page,
[joshbeard.me](https://joshbeard.me).

## Running

```shell
docker-compose up
```

This will start a local server available at <http://localhost:4000/>

## Photo Albums

My [photos](https://joshbeard.me/photos) are hosted on S3 and the HTML pages
are generated using a bundled [custom plugin](_plugins/gallery_generator.rb),
adapted from the original plugin at <https://github.com/kylemarsh/jekyll-gallery-generator>.

My plugin will optionally (by default, in my case) use a "file_list.txt" file
for the list of images instead of the actual files on disk. This is so I can
leave my photos _out of_ Git and still enable the Jekyll site to build the HTML
pages for the photo albums and individual photos.

### Creating and Updating Photo Albums

1. Create a directory under [`photos/`](photos/) for new albums.
2. Place images (preferably JPEG images with a `.jpg` extension) in the appropriate album directory.
3. Create or update the `album_info.yml` file within the album directory.
4. Run `python _scripts/photos.py`. Refer to the
   [`photos.py`](_scripts/photos.py) script for details about what it does and its
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

* __[`_plugins/gallery_generator.rb`](_plugins/gallery_generator.rb)__

  Custom Jekyll plugin for generating the HTML pages for albums and photos.

* __[`_layouts/album_index.html`](_layouts/album_index.html)__

  HTML template for a photo album index, which lists each photo in an album.

* __[`_layouts/image_page.html`](_layouts/image_page.html)__

  HTML template for an individual photo page.

* __[`_layouts/photos.html`](_layouts/photos.html)__

  HTML template for the main /photos/ page, which lists each album with a
  thumbnail.

* __`photos/*/album_info.yml`__

  File that is manually created with configuration and information for a photo
  album. Refer to the
  [`_plugins/gallery_generator.rb`](_plugins/gallery_generator.rb) file for
  documentation.

* __`photos/*/file_list.txt`__

  File that is generated by `photos.py` that lists each file in an album
  directory for the Jekyll plugin to build with.

* __[`_scripts/photos.py`](_scripts/photos.py)__

  Helper script for preparing and deploying my images.

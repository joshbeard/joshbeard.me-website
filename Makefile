jekyll-build:
	docker run -v ${PWD}:/site -w /site jekyll/jekyll \
	  jekyll build --config /site/._config.yml 

img-process:
	rm -f assets/img/*.jpg
	docker run -v ${PWD}/assets/img:/imgs --entrypoint=/bin/bash \
	  dpokidov/imagemagick -c 'for i in /imgs/orig/*; do convert $$i -resize 300x /imgs/r-$$(basename $$i); done'

	docker run -v ${PWD}/assets/img:/imgs --entrypoint=/bin/bash \
	  dpokidov/imagemagick -c 'for i in /imgs/r-*; do convert $$i -sampling-factor 4:2:0 -strip -quality 85 \
	  -interlace Plane -gaussian-blur 0.05 -colorspace RGB imgs/o$$(basename $$i); done'

	cp assets/img/orig/* assets/img/

	rm -f assets/img/r-*.jpg

minify:
	docker run --rm -it \
      -v ${PWD}/_site:/site \
      thekevjames/minify:2.5.2 \
      minify --recursive --output /site /site

s3-deploy:
	docker run --env-file=../../aws.env -v ${PWD}:/site -w /site mikesir87/aws-cli \
	  aws s3 sync _site s3://s3-website-joshbeard-me/ --exclude "resume/*" --delete

	docker run --env-file=../../aws.env -v ${PWD}:/site -w /site mikesir87/aws-cli \
	  aws s3 cp s3://s3-website-joshbeard-me/assets s3://s3-website-joshbeard-me/assets \
	  --recursive \
	  --acl public-read \
	  --cache-control max-age=604800

	docker run --env-file=../../aws.env -v ${PWD}:/site -w /site mikesir87/aws-cli \
	  aws s3 cp s3://s3-website-joshbeard-me/ s3://s3-website-joshbeard-me/ \
	  --exclude "*" --include "favicon-*" --include "*.png" --include "site.webmanifest" \
	  --recursive \
	  --acl public-read \
	  --cache-control max-age=604800

build: jekyll-build minify

deploy: build s3-deploy

clear-cache:
	docker run --env-file=../../aws.env -v ${PWD}:/site -w /site mikesir87/aws-cli \
	  aws cloudfront create-invalidation --distribution-id E1PDI7MPL7E2E4 --path "${path}"

clean:
	rm -rf _site .jekyll-cache

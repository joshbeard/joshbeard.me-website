build:
	docker run --rm -it -v $(PWD):/site -w /site -it jekyll/jekyll:4 jekyll build

serve:
	docker run --rm -it -v $(PWD):/site -w /site -p 4000:4000 -it jekyll/jekyll:4 jekyll serve --livereload

nginx:
	docker run --rm -it -v $(PWD)/_site:/usr/share/nginx/html:ro -p 8080:80 nginx

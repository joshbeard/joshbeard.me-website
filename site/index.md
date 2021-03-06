---
title: About This Site
meta_title: About This Site
description: Information about this website and the tools used to build and host it
layout: page
permalink: /site/
class: ascii-art
keywords: ['jekyll sites', 'personal sites', 'indie web', 'personal site aws', 'landing page', 's3 site', 'cloudfront site']
---
## About This Site

{% include submenu.html %}

### Other Protocols

* __Gemini__: <a href="gemini://jbeard.co">gemini://jbeard.co</a>
* __Gopher__: <a href="gopher://jbeard.co">gopher://jbeard.co</a>

See my [Small Internet Stack](/site/small.html) page for information about this and
more.

### Status

I have an [UptimeRobot Status Page](https://stats.uptimerobot.com/V7ZMWilg5P).

### Framework

This is a [Jekyll](https://jekyllrb.com/) site with a custom theme and layout.

The site should be mobile friendly.

The site does not require JavaScript or Cookies.

#### Fonts

I use [FontAwesome](https://fontawesome.com/) for the icons on the landing page
and a couple of fonts from Google Web Fonts. All assets are hosted locally.

```ascii-art
      _ _
    _{ ' }_
   { `.!.` }
   ',_/Y\_,'
     {_,_}
       |
     (\|  /)
      \| //
       |//
jgs \\ |/  //
^^^^^^^^^^^^^^^
```

### ASCII Art

The ASCII art is credited with the artists's "tag" or initials. Most is taken from
<https://asciiart.website/> and <https://ascii.co.uk/art>.

### Hosting

I've hosted my website(s) all sorts of ways over the years - a server at home,
on VPS instances, on static web hosts, and currently to AWS S3 with AWS
CloudFront. It's resonably inexpensive for what I've got and keeps it consistent
with other projects I have.

### Build and Deployment

I maintain the website itself from the [joshbeard/joshbeard.me-website](https://github.com/joshbeard/joshbeard.me-website)
repository on GitHub.

I'm now using GitHub Actions for building and deploying the website, which consists of:

* Jekyll build
* Minify static assets
* Create artifact
* Deploy to S3
* Set cache on objects in S3
* Invalidate CloudFront distribution cache

To deploy the AWS resources, I use Terraform and maintain that in the
[joshbeard/joshbeard.me-tf-aws](https://github.com/joshbeard/joshbeard.me-tf-aws)
repository to separate it from the content. This uses my common [tf-aws-site](https://github.com/joshbeard/tf-aws-site)
Terraform module to deploy, which manages a common AWS stack for my static websites.

```ascii-art
          &&& &&  & &&
      && &\/&\|& ()|/ @, &&
      &\/(/&/&||/& /_/)_&/_&
   &() &\/&|()|/&\/ '%" & ()
  &_\_&&_\ |& |&&/&__%_/_& &&
&&   && & &| &| /& & % ()& /&&
 ()&_---()&\&\|&&-&&--%---()~
     &&     \|||
             |||
             |||
             |||
       , -=-~  .-^- _
ejm97         `
```

### Photos

I deploy my [photos](/photos) to their own S3 bucket from my workstation. I use
a customized Jekyll plugin to generate the HTML pages for these photo albums.

### Performance

* __100%__ on [GTmetrix](https://gtmetrix.com/reports/joshbeard.me/lC97jd4Z/)
* __100%__ on [Pingdom](https://tools.pingdom.com/#601dfb4687400000)

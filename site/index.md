---
title: About This Site
layout: page
permalink: /site/
class: ascii-art
---
I also deploy a [Small Internet](small.html) stack (Gopher, Gemini).

### Framework

This is a [Jekyll](https://jekyllrb.com/) site with a completely custom theme
and layout. The site was originally a single landing page, but I've expanded it.
Being Jekyll, it's completely static. It doesn't use JavaScript, cookies,
analytics, or anything like that. It's a simple static website. See my [Smol
Stack](/posts/2022/03/28/smol-stack.html)
post for information about alternatives to HTTP/WWW for this site.

I use [FontAwesome](https://fontawesome.com/) for the icons on the landing page
and a couple of fonts from Google Web Fonts. All assets are hosted locally.

The site should be mobile friendly.

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

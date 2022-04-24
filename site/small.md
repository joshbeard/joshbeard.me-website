---
title: "Small Internet Stack"
meta_title: "Small Internet Stack"
description: My Small Internet Stack
layout: page
permalink: /site/small.html
keywords: ['smol web', 'smol internet', 'small internet', 'small web', 'gopher', 'gemini', 'gopher hole', 'gemini capsule', 'gopher site', 'gemini site', 'finger', 'alternative web', 'indie web', 'finger protocol', 'finger user']
---
## Small Internet Stack

{% include submenu.html %}

I've recently taken an interest in what's been dubbed the [Smol Internet](https://thedorkweb.substack.com/p/gopher-gemini-and-the-smol-internet?s=r),
"small Internet", or "the Dork web". In this context, it refers to simpler
protocols, sometimes old ones, in contemporary use. This also has cross over with the "indie web" communities.
I've deployed my own stack and content for some of these services for fun.

### Apps

* [Lagrange](https://gmi.skyjake.fi/lagrange/) is a nice cross-platform browser that supports each of these protocols (desktop).
* [Elaho](https://apps.apple.com/us/app/elaho/id1514950389) is an iOS app for browsing Gemini.
* [deedum](https://github.com/snoe/deedum) is a Gemini browser for [iOS](https://apps.apple.com/to/app/deedum/id1546810946) and [Android](https://play.google.com/store/apps/details?id=ca.snoe.deedum)
* [Gopher Client for iOS](https://apps.apple.com/us/app/gopher-client/id1235310088).
* [Ariane](https://play.google.com/store/apps/details?id=oppen.gemini.ariane) is an Android app for browsing Gemini.
* [DiggieDog](https://play.google.com/store/apps/details?id=com.afewroosloose.gopher) is a Gopher client for Android.

See the [awesome-gemini](https://github.com/kr1sp1n/awesome-gemini) repo on
GitHub for a list of things related to Gemini.

### Deployment

I'm using Ansible to deploy these services to a [Rocky Linux](https://rockylinux.org/)
virtual machine on my Homelab.

See <https://github.com/joshbeard/homelab-service-smolstack> for my Ansible
playbook for the whole stack.

### Gopher

The [Gopher](https://en.wikipedia.org/wiki/Gopher_(protocol)) protocol predates the web but still has an active
community of enthusiasts.

I'm using [Gophernicus](https://gophernicus.org/) to serve my Gopher hole.

__Gopher__: <a href="gopher://jbeard.co">gopher://jbeard.co</a>

Gopher response using [Netcat](https://www.varonis.com/blog/netcat-commands):

```shell
echo | ncat jbeard.co 70
```

### Gemini

A newer protocol that was introduced only a few years ago is
[Gemini](https://gemini.circumlunar.space/). This is somewhere between
Gopher and the Web/HTTP - probably closer to the Gopher side.

I am using [JetForce](https://github.com/michael-lazar/jetforce) for my
Gemini service and have also used [Agate](https://github.com/mbrubeck/agate).

__Gemini__: <a href="gemini://jbeard.co">gemini://jbeard.co</a>

Gemini response using [Netcat](https://www.varonis.com/blog/netcat-commands):

```shell
echo "gemini://jbeard.co/" | ncat -C --ssl jbeard.co 1965
```

### Finger

Another service is [Finger](https://en.wikipedia.org/wiki/Finger_%28protocol%29).

I am using [Finger2020](https://github.com/michael-lazar/finger2020) for my
Finger service.

To "finger" me, you can use a simple command, which is common across Linux, macOS, and Windows:

With the `finger` command:

```shell
finger josh@jbeard.co
```

Finger response using [Netcat](https://www.varonis.com/blog/netcat-commands):

```shell
echo "josh" | nc jbeard.co 79
```

### Resources

* [Poor Man's Web - The Small Web](https://zserge.com/posts/small-web/)

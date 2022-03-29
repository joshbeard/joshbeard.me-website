---
layout: post
title: "Smol Stack"
---
I've recently taken an interest in what's been dubbed the [Smol Internet](https://thedorkweb.substack.com/p/gopher-gemini-and-the-smol-internet?s=r),
"small Internet", or "the Dork web". In this context, it refers to simpler
protocols, sometimes old ones, in contemporary use. This also has cross over with the [Yesterweb](https://yesterweb.org/).
I've deployed my own stack and content of some of these services for fun.

### Apps

* [Lagrange](https://gmi.skyjake.fi/lagrange/) is a nice cross-platform browser that supports each of these protocols (desktop).
* [Elaho](https://apps.apple.com/us/app/elaho/id1514950389) is an iOS app for browsing Gemini.
* [deedum](https://github.com/snoe/deedum) is a Gemini browser for [iOS](https://apps.apple.com/to/app/deedum/id1546810946) and [Android](https://play.google.com/store/apps/details?id=ca.snoe.deedum)
* [Gopher Client for iOS](https://apps.apple.com/us/app/gopher-client/id1235310088).
* [Ariane](https://play.google.com/store/apps/details?id=oppen.gemini.ariane) is an Android app for browsing Gemini.
* [DiggieDog](https://play.google.com/store/apps/details?id=com.afewroosloose.gopher) is a Gopher client for Android.

See the [awesome-gemini](https://github.com/kr1sp1n/awesome-gemini) repo on
GitHub for a list of things related to Gemini.

<!-- more -->

### Gopher

The [Gopher](https://en.wikipedia.org/wiki/Gopher_(protocol)) protocol predates the web but still has an active
community of enthusiasts.

* __Gopher__: <a href="gopher://jbeard.co">gopher://jbeard.co</a>

Gopher response using netcat:

```shell
echo | ncat jbeard.co 70
```

### Gemini

A newer protocol that was introduced only a few years ago is
[Gemini](https://gemini.circumlunar.space/). This is somewhere between
Gopher and the Web/HTTP - probably closer to the Gopher side.

* __Gemini__: <a href="gemini://jbeard.co">gemini://jbeard.co</a>

```shell
echo "gemini://jbeard.co/" | ncat -C --ssl jbeard.co 1965
```

### Finger

Another service is [Finger](https://en.wikipedia.org/wiki/Finger_%28protocol%29).

To "finger" me, you can use a simple command, which is common across Linux, macOS, and Windows:

With the `finger` command:

```shell
finger josh@jbeard.co
```

With [Netcat](https://www.varonis.com/blog/netcat-commands):

```shell
echo "josh" | nc jbeard.co 79
```

### Resources

* [Poor Man's Web - The Small Web](https://zserge.com/posts/small-web/)

_This post will be [updated](https://github.com/joshbeard/joshbeard.me-website/commits/master/_posts/2022-03-28-smol-stack.md) occassionally._
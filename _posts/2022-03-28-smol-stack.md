---
layout: post
title: "Smol Stack"
---
I've recently taken an interest in what's been dubbed the [Smol Internet](https://thedorkweb.substack.com/p/gopher-gemini-and-the-smol-internet?s=r),
"small Internet", or "the Dork web". In this context, it refers to simpler
protocols, sometimes old ones, in contemporary use. This also has cross over with the [Yesterweb](https://yesterweb.org/).
I've deployed my own stack and content of some of these services for fun.

[Lagrange](https://gmi.skyjake.fi/lagrange/) is a nice browser that supports each of these protocols.

<!-- more -->

### Gopher

The [Gopher](https://en.wikipedia.org/wiki/Gopher_(protocol)) protocol predates the web but still has an active
community of enthusiasts.

* __Gopher__: <a href="gopher://jbeard.co">gopher://jbeard.co</a>

### Gemini

Another protocol that was introduced only a few years ago is
[Gemini](https://gemini.circumlunar.space/).

* __Gemini__: <a href="gemini://jbeard.co">gemini://jbeard.co</a>

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

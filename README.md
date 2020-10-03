<h2>The 5 GUIs Application
  <img src="5GUIs/Assets.xcassets/AppIcon.appiconset/5GUIs-256.png"
           align="right" width="128" height="128" />
</h2>

... the app for the [tweet](https://twitter.com/jckarter/status/1310412969289773056):

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">With its eclectic mix of AppKit, Catalyst, iOS, SwiftUI, and web apps, macOS should consider rebranding to “Five GUIs”</p>&mdash; Joe Groff (@jckarter) <a href="https://twitter.com/jckarter/status/1310412969289773056?ref_src=twsrc%5Etfw">September 28, 2020</a></blockquote>

GUI is an abbreviation for [Graphical User Interface](https://en.wikipedia.org/wiki/Graphical_user_interface).

<a href="https://apps.apple.com/us/app/id1534164621">
  <img src="https://zeezide.com/img/apple/Download_on_the_App_Store_Badge_US-UK_135x40 Canvas.png"> 
</a>  

<img src="https://zeezide.com/img/5guis/screenshots/appwindow/5guis-drop-it.png"
     width="24%" />
<img src="https://zeezide.com/img/5guis/screenshots/appwindow/5guis-marzipan.png"
     width="24%" />
<img src="https://zeezide.com/img/5guis/screenshots/appwindow/5guis-companion.png"
     width="24%" />
<img src="https://zeezide.com/img/5guis/screenshots/appwindow/5guis-automator.png"
     width="24%" />


### How it works

[5 GUIs](https://zeezide.com/en/products/5guis/index.html) 
first grabs some information from the app bundle. 
It then uses [LLVM](https://llvm.org)'s 
[`objdump`](https://en.wikipedia.org/wiki/Objdump) 
to check what libraries the app links,
e.g. [Electron](https://www.electronjs.org) or 
[UIKit](https://developer.apple.com/documentation/uikit), to figure out what technology is being used.

[5 GUIs](https://zeezide.com/en/products/5guis/index.html) 
itself is a [SwiftUI](https://developer.apple.com/xcode/swiftui/) 1
macOS application (i.e. it runs on Catalina and macOS BS).


### Idea and Implementation

The idea for this kind of app exists for quite some time, but when 
[@jckarter](https://twitter.com/jckarter)
tweeted the proper name for this: “5 GUIs”, it finally had to be done.

This is a quick hack, put together in about 2 days. 
The source is not “nice” at all, don't use it as a proper example 🙈
PRs with cleanups are warmly welcome.


### Help wanted!

All improvements are very welcome, but most of all this app could use better
design. 
SwiftUI gives you something OKayish looking out of the box, but if someone
has the time to add some fancy animations, 
better colors, iconography and styling, 
that would be *very* welcome!

Also checkout the Issues page of this repository. It'll have some.


### 3rd Party Software Used

- LLVM objdump: [license](LLVM/LLVM-LICENSE.TXT)


### Building the Project in Xcode

Before the app can be build, an `llvm-objdump` binary needs to be put into
the `LLVM` folder (the binary was a little big for inclusion in the repository).

For testing purposes the one included in Xcode should be fine,
it should be living over here:
`/Applications/Xcode.app//Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/llvm-objdump`.

For deployment it is probably better to build an own one. 
To do so:
- grab the LLVM source code from the 
  [downloads page](https://releases.llvm.org/download.html#10.0.1)
- Unpack it somewhere, e.g.: `cd /tmp; && tar zxf llvm-10.0.1.src.tar.xz`
- Create a build dir: `mkdir /tmp/build-dir && cd /tmp/build-dir`
- Create the makefiles: `cmake ../llvm-10.0.1.src/`
- Build it: `cd tools/llvm-objdump && cmake --build .`


### Who

**5 GUIs** is brought to you by
[ZeeZide](http://zeezide.de).
We like feedback, GitHub stars, cool contract work,
presumably any form of praise you can think of.

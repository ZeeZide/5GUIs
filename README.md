<h2>5 GUIs
  <img src="5GUIs/Assets.xcassets/AppIcon.appiconset/5GUIs- 128.png"
           align="right" width="128" height="128" />
</h2>

... the app for the [tweet](https://twitter.com/jckarter/status/1310412969289773056):

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">With its eclectic mix of AppKit, Catalyst, iOS, SwiftUI, and web apps, macOS should consider rebranding to “Five GUIs”</p>&mdash; Joe Groff (@jckarter) <a href="https://twitter.com/jckarter/status/1310412969289773056?ref_src=twsrc%5Etfw">September 28, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

GUI is an abbreviation for [Graphical User Interface](https://en.wikipedia.org/wiki/Graphical_user_interface).


### How it works:

5 GUIs grabs some information from the app bundle. 
It then uses LLVM's objdump to check what libraries the app links,
e.g. Electron or UIKit, to figure out what technology is being used.

5 GUIs itself is a SwiftUI application.


### Idea and Implementation

I had the idea for this kind of app for quite some time, but when @jckarter 
tweeted the proper name for this ★ "5 GUIs" ★, it finally had to be done.

This is a quick hack, scrambled together in about 2 days. 
The source is not "nice" at all, don't use it as a proper example 🙈
PRs with cleanups are warmly welcome.


### Help wanted!

All improvements are very welcome, but most of all this app could use better
design. 
SwiftUI gives you something OKayish looking out of the box, but if someone
has the time to add some fancy animations, 
better colors, iconography and styling, 
that would be *very* welcome!


### 3rd Party Software Used

- LLVM objdump: [license](LLVM/LLVM-LICENSE.TXT)


### Who

**5 GUIs** is brought to you by
[ZeeZide](http://zeezide.de).
We like feedback, GitHub stars, cool contract work,
presumably any form of praise you can think of.

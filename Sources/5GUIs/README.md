<h2>5 GUIs Sources
  <img src="5GUIs/Assets.xcassets/AppIcon.appiconset/5GUIs-128.png"
           align="right" width="128" height="128" />
</h2>

Reminder: This is a quick 2-day hack, not a beautiful and cleaned up thing ...
Cleanup PRs are welcome!

The app is a macOS SwiftUI v1 app, built on macOS 10.15. 
Means: It uses an AppDelegate and creates the windows using AppKit.
The default storyboard is used for menus.

The state of a main window is represented in that `WindowState`
ObservableObject. It is the main driver.
This hooks into `FileDetectionState`, which is actually more like an `Operation`
object. TBF. Some states are dupe.

The `Model` directory contains a wild mixture of actual models, and what one might
call a ViewModel.

The `Views` directory contains all the SwiftUI Views. 
Some more generic, but mostly just hacked together to get the app out of the door.

`Utilities` contains, you can guess it.


### UI

- there is a spinner, but it is not really necessary, a detection runs very fast ...
- the badges which come up in a progress style manner are just fake, with their own
  fake progress model and observable driver object :-)


### Contact

Any questions? Just ask! :-)


### Who

**5 GUIs** is brought to you by
[ZeeZide](http://zeezide.de).
We like feedback, GitHub stars, cool contract work,
presumably any form of praise you can think of.

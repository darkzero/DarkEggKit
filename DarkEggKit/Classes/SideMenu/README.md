#  DarkEggKit/SideMenu

## Side menu in UIViewController

### Installation and Import

* **Installation**
```ruby
pod 'DarkEggKit/SideMenu'
```

* **Import**

```Swift
import DarkEggKit
```

### How to use

* **create your own sidemenu viewcontroller in storyboard, and create instance in viewDidLoad**

```Swift
self.sideMenu = (storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController);
```
* **Show the side menu**

```Swift
var config = DZSideMenuConfiguration()
// side menu position, .left and .right, default is left
config.position = .left
// animationType, .default and .cover
config.animationType = .default
self.dz_showSideMenu(self.sideMenu, configuration: config)
```

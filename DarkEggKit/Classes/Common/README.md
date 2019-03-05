#  DarkEggKit/Common

## Common Class for DarkEggKit

### Installation and Import

* **Installation**
```ruby
pod 'DarkEggKit'
```

* **Import**

```Swift
import DarkEggKit
```

### How to use

#### Extension of UIColor

* **RGB(_ r:Int, _ g:Int, _ b:Int)**
```Swift
RGB(0, 0, 0)
RGB(255, 255, 255)
```

* **RGBA(_ r:Int, _ g:Int, _ b:Int, _ a:CGFloat)**
```Swift
RGB(0, 0, 0, 1.0)
RGB(255, 255, 255, 0.6)
```

* **RGB_HEX(_ hex:String, _ a:CGFloat)**
```Swift
RGB_HEX("000000", 1.0)
RGB_HEX("ff0000", 0.5)
```

#### Extension of UIImage

* **Create a image with color, default size is 1x1s**

```Swift
UIImage.imageWithColor( _ color:UIColor, size: CGSize)
UIImage.imageWithColor( _ color:UIColor)
```

* **Create a gradient with colors, default size is 64x64, default direction is horizontal**

```Swift
UIImage.imageWithGradient(colors: CGColor..., size: CGSize, direction: GradientDirection)
UIImage.imageWithGradient(colors: CGColor..., size: CGSize)
UIImage.imageWithGradient(colors: CGColor..., direction: GradientDirection)
UIImage.imageWithGradient(colors: CGColor...)
```

#### Logger

    Will auto print out the file name, function name, line number and column number

* **Debug Log**


```Swift
Logger.debug("{message}")
```

* **Error Log**

```Swift
Logger.error("{message}")
```


#  DarkEggKit/Common

## Common Class for DarkEggKit

### How to use

* **Installation**
```ruby
pod 'DarkEggKit'
```

* **Import**

```Swift
import DarkEggKit
```

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

```Swift
imageWithColor( _ color:UIColor, size: CGSize)
imageWithColor( _ color:UIColor)
```

Create a image with color, default size is 1x1

```Swift
imageWithGradient(colors: CGColor..., size: CGSize = CGSize(width: 64, height: 64), direction: GradientDirection = .horizontal)
```
Create a gradient with colors, default size is 64x64, default direction is horizontal

#### Logger

##### Debug

Will auto print out the file name, function name, line number and column number

```Swift
Logger.debug("{message}")
```

#### Error

```Swift
Logger.error("{message}")
```


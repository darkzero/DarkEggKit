#  DarkEggKit/AnimatedImageView

## AnimatedImageView

### Installation and Import

* **Installation**
```ruby
pod 'DarkEggKit/AnimatedImageView'
```

* **Import**

```Swift
import DarkEggKit
```

### How to use

#### Add AnimatedImageView in storyboard
```SWift
@IBOutlet weak var aniImgView: AnimatedImageView!
```

#### Set AnimatedImage to AnimatedImageView ( support GIF and APNG )
```Swift
let aniImg = AnimationImage(url: {url of the image})

aniImgView.aImage = aniImg
aniImgView.repeatMode = .infinite
aniImgView.delegate = self
```

#### AnimatedImageViewDelegate
```Swift
/// Called after the 'AnimatedImageView' has finished each animation loop.
/// - Parameters
///   - imageView: The 'AnimatedImageView' that is being animated
///   - count: The looped count
func animatedImageView(_ imageView: AnimatedImageView, didPlayAnimationLoops count: UInt)

/// Called after the 'AnimatedImageView' has reached the max repeat count
/// - Parameter imageView: The 'AnimatedImageView' that is being animated
func animatedImageView(_ imageView: AnimatedImageView, didFinishAnimating: Void)
```

#### RepeatMode
```Swift
case once                   // Only once, 
                            // Call animatedImageView(_ imageView: AnimatedImageView, didFinishAnimating: Void) at end
                            // Call animatedImageView(_ imageView: AnimatedImageView, didPlayAnimationLoops count: UInt) at end 
case finite(_ count: UInt)  // finite, can set loop times
                            // Call animatedImageView(_ imageView: AnimatedImageView, didFinishAnimating: Void) at end
                            // Call animatedImageView(_ imageView: AnimatedImageView, didPlayAnimationLoops count: UInt) at every loop end
case infinite               // infinite,
                            // will call animatedImageView(_ imageView: AnimatedImageView, didPlayAnimationLoops count: UInt)
```

# DarkEggKit/PopupMessage

## simple message display queue

### How to use

* **Installation**
```ruby
pod 'DarkEggKit/PopupMessageView'
```

* **Import**

```Swift
import DarkEggKit
```

* **Show message**

```Swift
/// paramters
/// - message text: String
/// - theme: DZPopupMessage.Theme(enum)
///     can be nil, default is .light
/// - type: DZPopupMessage.MessageType(enum)
///     can be nil, default is .info
/// - display: DZPopupMessage.DisplayType(enum)
///     can be nil, default is .bubbleTop
DZPopupMessage.show({msg text}, theme: {theme}, type: {type}, display: {display}, callback: {
    // do some thing
})
```

* **Paramaters**
    * theme
        - DZPopupMessage.Theme.light
        - DZPopupMessage.Theme.dark
        
    * type
        - DZPopupMessage.MessageType.info
        - DZPopupMessage.MessageType.warning
        - DZPopupMessage.MessageType.error
        
    * display
        - DZPopupMessage.DisplayType.rise
        - DZPopupMessage.DisplayType.drop
        - DZPopupMessage.DisplayType.bubbleTop
        - DZPopupMessage.DisplayType.bubbleBottom

#### Can be used like these

```Swift
DZPopupMessage.show("Message body");
DZPopupMessage.show({msg text}, theme: {theme}, type: {type}, display: {display});
DZPopupMessage.show({msg text}, theme: {theme}, type: {type});
...
```

## Blog post(中文使用说明)
[DZPopupMessageView更新](https://darkzero.me/blog/2019/01/27/dzpopupmessageview%E6%9B%B4%E6%96%B0/)

## Requirements
Xcode

## Installation

DZPopupMessageView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DarkEggKit/PopupMessageView'
```

## Author

darkzero, darkzero_mk2@hotmail.com

## License

DZPopupMessageView is available under the MIT license. See the LICENSE file for more info.

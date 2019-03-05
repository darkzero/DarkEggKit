# DarkEggKit/PopupMessage

## simple message display queue

### Installation and Import

* **Installation**
```ruby
pod 'DarkEggKit/PopupMessageView'
```

* **Import**

```Swift
import DarkEggKit
```

### How to use

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
DZPopupMessage.show({msg text});
DZPopupMessage.show({msg text}, theme: {theme}, type: {type}, display: {display});
DZPopupMessage.show({msg text}, theme: {theme}, type: {type});
...
```

## Blog post(中文使用说明)
[DZPopupMessageView更新](https://darkzero.me/blog/2019/01/27/dzpopupmessageview%E6%9B%B4%E6%96%B0/)

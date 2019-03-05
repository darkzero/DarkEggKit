//
//  DZPopupMessageView.swift
//  Pods
//
//  Created by darkzero on 16/5/15.
//
//

import UIKit

public class DZPopupMessageView: UIView {
    private var parentView: UIView?
    private var messageLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 5, width: 220, height: 22))
    private var iconImageView: UIImageView = UIImageView(frame: CGRect(x: 4, y: 4, width: 24, height: 24))
    
    private var callback:(()->Void)?
    private var message: Message
    
    // MARK: - init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal init(message: Message, in view: UIView? = nil, callback: (()->Void)? = nil) {
        self.message = message
        self.callback = callback
        if ( view != nil ) {
            self.parentView = view
        }
        else {
            self.parentView = UIApplication.shared.keyWindow
        }
        
        // calc the frame
        let rect = (message.text as NSString).boundingRect(with: CGSize(width: 220, height: 0),
                                                           options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                           attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0)],
                                                           context: nil)
        let labelRect   = CGRect(x: 40, y: 8, width: min(rect.width, 220), height: rect.height)
        let viewRect    = CGRect(x: 0, y: 0, width: min(rect.width, 220) + 60, height: max(rect.height+16, 32.0))
        let radius: CGFloat = 16.0 //viewRect.height/2
        
        super.init(frame: viewRect)
        self.addSubview(self.messageLabel)
        self.addSubview(self.iconImageView)
        
        self.messageLabel.frame = labelRect
        self.messageLabel.textAlignment = NSTextAlignment.left
        self.messageLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.messageLabel.numberOfLines = 0
        self.messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.messageLabel.text = message.text
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        switch message.theme {
        case .dark:
            self.messageLabel.textColor = .white
            self.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.borderColor = UIColor.white.cgColor
            self.iconImageView.tintColor = .white
        case .light:
            self.messageLabel.textColor = .darkGray
            self.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.borderColor = UIColor.gray.cgColor
            self.iconImageView.tintColor = .gray
        }
        self.layer.borderWidth = 1
        
        var imageStr = ""
        switch message.type {
        case .info:
            imageStr = "dz_icon_info"
            break
        case .warning:
            self.layer.borderColor = UIColor.orange.cgColor
            if message.theme == .dark {
                self.backgroundColor = UIColor(white: 0.7, alpha: 0.9)
            }
            self.messageLabel.textColor = .orange
            imageStr = "dz_icon_warning"
            self.iconImageView.tintColor = .orange
            break
        case .error:
            self.layer.borderColor = UIColor.red.cgColor
            if message.theme == .dark {
                self.backgroundColor = UIColor(white: 0.7, alpha: 0.9)
            }
            self.messageLabel.textColor = .red
            //self.messageLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            imageStr = "dz_icon_error"
            self.iconImageView.tintColor = .red
            break
        }
        let image = UIImage(named: imageStr, in: Bundle(for: DZPopupMessageView.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        self.iconImageView.image = image
        self.iconImageView.contentMode = .scaleAspectFill
        self.addSubview(iconImageView)
        
        self.layer.masksToBounds = false
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.cornerRadius = radius
    }
}

extension DZPopupMessageView {
    // MARK: - Animations
    internal func showWithAnimation(_ animation: Bool, in: UIView? = nil, callback: (()->Void)? = nil) {
        //
        self.parentView?.addSubview(self)
        let inset = DZPopupMessageView.safeAreaInsetsOf(self.parentView!)
        //print(inset)
        switch self.message.display {
        case .rise, .bubbleBottom:
            self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height)
        case .drop, .bubbleTop:
            self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: -self.bounds.height)
        }
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
            switch self.message.display {
            case .rise:
                self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                break
            case .drop:
                self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                break
            case .bubbleTop:
                self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: self.bounds.height/2+inset.top+16)
                break
            case .bubbleBottom:
                self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height-inset.bottom-self.bounds.height/2-16)
                break
            }
        }) { (finished) in
            self.hideWithAnimation(animation)
        }
    }
    
    internal func hideWithAnimation(_ animation: Bool) {
        UIView.animate(withDuration: 0.5, delay: self.message.disappearDelay, options: .curveLinear, animations: {
            self.alpha = 0.5
            //self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/4)
        }) { (finished) in
            DZPopupMessageQueue.shared.messageList.removeLast()
            DZPopupMessageQueueManager.shared.next()
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                self.alpha = 0.0
                switch self.message.display {
                case .rise:
                    self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 0)
                    break
                case .drop:
                    self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height)
                    break
                case .bubbleTop:
                    self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: -self.bounds.height)
                    break
                case .bubbleBottom:
                    self.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height)
                    break
                }
            }, completion: { (finished) in
                self.removeFromSuperview()
                self.callback?()
            })
        }
    }
}

extension DZPopupMessageView {
    class func safeAreaInsetsOf(_ view: UIView) -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            // Fallback on earlier versions
            return UIEdgeInsets.zero;
        }
    }
}

//
//  DZButtonMenuItem.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2019/03/10.
//

import UIKit

class DZButtonMenuItem: NSObject {
    internal var index: Int = -1
    
    private var button: UIButton = UIButton(type: .custom)
    private var label: UILabel?
    private var image: UIImage?
    private var title: String = ""
    private var action: (()->Void)?

    private let buttonAniDuration = 0.33
    private let labelAniDuration = 0.33
    
    internal var attributes: DZButtonMenuAttributes = DZButtonMenuAttributes.default() {
        didSet {
            self.adjustSubviews()
        }
    }
    internal var configuration: DZButtonMenuConfiguration = DZButtonMenuConfiguration.default()
    internal var initialLocation: CGPoint = .zero
    private var targetLocation: CGPoint = .zero
    
    
    lazy var buttonPreparePos: CGPoint = {
        return self.calcButtonPosition(of: self.index-1)
    }()
    
    lazy var buttonTargetPos: CGPoint = {
        return self.calcButtonPosition(of: self.index)
    }()
    
    lazy var labelTargetPos: CGPoint = {
        return self.calcLabelPosition(of: self.index)
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String = "", image: UIImage? = nil, action: (()->Void)? = nil) {
        super.init()
        self.image = image
        self.title = title
        self.action = action
        self.makeButton()
    }
    
    private func calcButtonPosition(of index: Int) -> CGPoint {
        var position = CGPoint.zero
        var idx = CGFloat(index)
        switch self.configuration.style {
        case .sector:
            // In this version .sector is deprecated, return CGRect.zero
            //return .zero
            switch self.configuration.location {
            case .rightBottom:
                position.x = self.attributes.initialFrame.origin.x - cos(CGFloat.pi/4*idx) * 60
                position.y = self.attributes.initialFrame.origin.y - sin(CGFloat.pi/4*idx) * 60
            case .leftBottom:
                position.x = self.attributes.initialFrame.origin.x + cos(CGFloat.pi/4*idx) * 60
                position.y = self.attributes.initialFrame.origin.y - sin(CGFloat.pi/4*idx) * 60
            case .rightTop:
                position.x = self.attributes.initialFrame.origin.x - cos(CGFloat.pi/4*idx) * 60
                position.y = self.attributes.initialFrame.origin.y + sin(CGFloat.pi/4*idx) * 60
            case .leftTop:
                position.x = self.attributes.initialFrame.origin.x + cos(CGFloat.pi/4*idx) * 60
                position.y = self.attributes.initialFrame.origin.y + sin(CGFloat.pi/4*idx) * 60
            case .free:
                position.x = self.attributes.initialFrame.origin.x - cos(CGFloat.pi/4*idx) * 60
                position.y = self.attributes.initialFrame.origin.y - sin(CGFloat.pi/4*idx) * 60
            }
        case .line:
            idx += 1.0
            position = self.attributes.initialFrame.origin
            switch self.configuration.direction {
            case .up:
                position.y = self.attributes.initialFrame.origin.y - idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter)
            case .down:
                position.y = self.attributes.initialFrame.origin.y + idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter)
            case .left:
                position.x = self.attributes.initialFrame.origin.x - idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter)
            case .right:
                position.x = self.attributes.initialFrame.origin.x + idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter)
            }
        }
        return position
    }
    
    private func calcLabelPosition(of index: Int) -> CGPoint {
        guard let lbl = self.label else {
            return .zero
        }

        var position = lbl.frame.origin
        let labelSize = lbl.frame.size
        var idx = CGFloat(index)
        switch self.configuration.style {
        case .line:
            idx += 1.0
            switch self.configuration.direction {
            case .up:
                if self.configuration.location.isLeft {
                    position.x = self.attributes.initialFrame.maxX + 8
                }
                else {
                    position.x = self.attributes.initialFrame.origin.x - labelSize.width - 8
                }
                position.y = self.attributes.initialFrame.origin.y - idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter) + lbl.frame.height/2
            case .down:
                if self.configuration.location.isLeft {
                    position.x = self.attributes.initialFrame.maxX + 8
                }
                else {
                    position.x = self.attributes.initialFrame.origin.x - labelSize.width - 8
                }
                position.y = self.attributes.initialFrame.origin.y + idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter)
            default:
                // .left and .right does not display label return CGRect.zero
                position = .zero
            }
        default:
            position = .zero
        }
        return position
    }
}

extension DZButtonMenuItem {
    private func adjustSubviews() {
        let btn = self.button
        btn.frame = CGRect(x: 0, y: 0, width: attributes.buttonDiameter, height: attributes.buttonDiameter);
        
        if let lbl = self.label {
            let lblRect = self.title.boundingRect(with: CGSize(width: 200, height: attributes.labelHeight),
                                                  options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                  attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)],
                                                  context: nil)
            lbl.frame = CGRect(x: 0, y: 0, width: lblRect.size.width+20, height: attributes.labelHeight)
        }
    }
    
    private func makeButton() {
        let btn = self.button
        btn.frame = CGRect(x: 0, y: 0, width: attributes.buttonDiameter, height: attributes.buttonDiameter);
        if let _img = image {
            btn.setImage(_img, for: .normal)
            if #available(iOS 13, *) {
                btn.tintColor = .systemBackground
            }
            else {
                btn.tintColor = .white
            }
        }
        else {
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            btn.setTitle(self.title.prefix(1).uppercased(), for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)
            if #available(iOS 13, *) {
                btn.setTitleColor(.systemBackground, for: .normal)
            }
            else {
                btn.setTitleColor(.white, for: .normal)
            }
        }
        btn.backgroundColor     = attributes.closedColor;
        btn.layer.cornerRadius  = attributes.buttonDiameter/2
        btn.tag                 = attributes.mainButtonTag
        btn.alpha               = 0.0;
        
        btn.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControl.Event.touchUpInside);
    }
    
    private func makeLabel(){
        let lbl = UILabel()
        let lblRect = self.title.boundingRect(with: CGSize(width: 200, height: attributes.labelHeight),
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)],
                                            context: nil);
        lbl.font = UIFont.systemFont(ofSize: 12.0);
        lbl.numberOfLines = 1;
        lbl.frame = CGRect(x: 0, y: 0, width: lblRect.size.width+20, height: attributes.labelHeight);
        lbl.backgroundColor = attributes.closedColor;
        lbl.textAlignment = NSTextAlignment.center
        if #available(iOS 13, *) {
            lbl.textColor = .systemBackground
        }
        else {
            lbl.textColor = .white
        }
        lbl.layer.cornerRadius = attributes.labelHeight/2;
        lbl.clipsToBounds = true;
        lbl.text = self.title;
        lbl.alpha = 0.0
        self.label = lbl
    }
}

extension DZButtonMenuItem {
    @objc private func buttonClicked(_ sender: UIButton) {
        self.action?()
    }
}

extension DZButtonMenuItem {
    internal func show(at view: UIView, animated: Bool = true, callback: (()->Void)? = nil) {
        view.addSubview(self.button)
        self.button.frame.origin = self.attributes.initialFrame.origin
        switch self.configuration.style {
        case .sector:
            // In this version .sector is deprecated
            UIView.animate(withDuration: 0.3, delay: 0.066 * Double(self.index) , options: [], animations: {
                self.button.frame.origin = self.buttonTargetPos
                self.button.alpha = 1.0
            }) { (finished) in
                callback?()
            }
        case .line:
            switch self.configuration.direction {
            case .up, .down:
                // Only display label when direction is .up or .down
                self.makeLabel()
                view.addSubview(self.label!)
            default:
                break
            }
            
            let preparingAniDuration = Double(self.index)*self.buttonAniDuration
            let tempDuration = preparingAniDuration+self.buttonAniDuration
            UIView.animateKeyframes(withDuration: tempDuration, delay: 0.0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: preparingAniDuration/tempDuration, animations: {
                    self.button.frame.origin = self.buttonPreparePos
                    self.button.alpha = 0.0
                    if let lbl = self.label {
                        let lblStartPos = CGPoint(x: self.button.frame.minX,
                                                  y: self.button.frame.midY-lbl.frame.height/2)
                        lbl.frame.origin = lblStartPos
                        lbl.alpha = 0.0
                    }
                })
                UIView.addKeyframe(withRelativeStartTime: preparingAniDuration/tempDuration, relativeDuration: self.buttonAniDuration/tempDuration, animations: {
                    self.button.frame.origin = self.buttonTargetPos
                    self.button.alpha = 1.0
                    if let lbl = self.label {
                        lbl.frame.origin = self.labelTargetPos
                        lbl.alpha = 1.0;
                    }
                })
            }) { (finished) in
                callback?()
            }
        }
    }
    
    //internal func hide(index: Int, of count: Int) {
    internal func hide(of count: Int, callback: (()->Void)? = nil) {
        switch self.configuration.style {
        case .sector:
            // In this version .sector is deprecated
            UIView.animate(withDuration: 0.3, delay: 0.2 * Double(self.index) , options: [], animations: {
                self.button.frame.origin = self.attributes.initialFrame.origin
                self.button.alpha = 0.0;
            }) { (finished) in
                self.button.removeFromSuperview()
                self.label?.removeFromSuperview()
                callback?()
            }
        case .line:
            let kDelay = count - self.index - 1
            let fullDuration = self.buttonAniDuration*Double(self.index+1)
            let delayDuration = self.buttonAniDuration*Double(kDelay)
            let endingDuration = fullDuration - self.buttonAniDuration
            UIView.animateKeyframes(withDuration: fullDuration, delay: delayDuration, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.buttonAniDuration/fullDuration, animations: {
                    self.button.frame.origin = self.buttonPreparePos
                    self.button.alpha = 0.0;
                    if let lbl = self.label {
                        lbl.frame.origin = self.buttonPreparePos
                        lbl.alpha = 0.0;
                    }
                })
                UIView.addKeyframe(withRelativeStartTime: self.buttonAniDuration/fullDuration, relativeDuration: endingDuration/fullDuration, animations: {
                    self.button.frame = self.attributes.initialFrame
                    self.button.alpha = 0.0;
                })
            }) { (finished) in
                self.button.removeFromSuperview()
                self.label?.removeFromSuperview()
                callback?()
            }
        }
    }
}

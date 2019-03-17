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
    private var label: UILabel = UILabel()
    private var image: UIImage?
    private var title: String = ""
    private var action: (()->Void)?
    
    internal var attributes: DZButtonMenuAttributes = DZButtonMenuAttributes.default() {
        didSet {
            self.adjustSubviews()
        }
    }
    internal var configuration: DZButtonMenuConfiguration = DZButtonMenuConfiguration.default()
    internal var initialLocation: CGPoint = .zero
    private var targetLocation: CGPoint = .zero
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String = "", image: UIImage? = nil, action: (()->Void)? = nil) {
        super.init()
        self.image = image
        self.title = title
        self.action = action
        self.makeButton()
        self.makeLabel()
    }
    
    private func targetFrame(for index: Int) -> CGRect {
        var rect = CGRect.zero
        var idx = CGFloat(index)
        switch self.configuration.style {
        case .sector:
            switch self.configuration.location {
            case .rightBottom:
                rect.origin.x = self.attributes.initialFrame.origin.x - cos(CGFloat.pi/4*idx) * 60
                rect.origin.y = self.attributes.initialFrame.origin.y - sin(CGFloat.pi/4*idx) * 60
            case .leftBottom:
                rect.origin.x = self.attributes.initialFrame.origin.x + cos(CGFloat.pi/4*idx) * 60
                rect.origin.y = self.attributes.initialFrame.origin.y - sin(CGFloat.pi/4*idx) * 60
            case .rightTop:
                rect.origin.x = self.attributes.initialFrame.origin.x - cos(CGFloat.pi/4*idx) * 60
                rect.origin.y = self.attributes.initialFrame.origin.y + sin(CGFloat.pi/4*idx) * 60
            case .leftTop:
                rect.origin.x = self.attributes.initialFrame.origin.x + cos(CGFloat.pi/4*idx) * 60
                rect.origin.y = self.attributes.initialFrame.origin.y + sin(CGFloat.pi/4*idx) * 60
            case .free:
                rect.origin.x = self.attributes.initialFrame.origin.x - cos(CGFloat.pi/4*idx) * 60
                rect.origin.y = self.attributes.initialFrame.origin.y - sin(CGFloat.pi/4*idx) * 60
            }
        case .line:
            idx += 1.0
            switch self.configuration.direction {
            case .up:
                rect.origin.x = self.attributes.initialFrame.origin.x
                rect.origin.y = self.attributes.initialFrame.origin.y - idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter)
            case .down:
                rect.origin.x = self.attributes.initialFrame.origin.x
                rect.origin.y = self.attributes.initialFrame.origin.y + idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter)
            case .left:
                rect.origin.x = self.attributes.initialFrame.origin.x + idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter)
                rect.origin.y = self.attributes.initialFrame.origin.y
            case .right:
                rect.origin.x = self.attributes.initialFrame.origin.x - idx*(self.attributes.buttonPadding+self.attributes.buttonDiameter)
                rect.origin.y = self.attributes.initialFrame.origin.y
            }
        }
        rect.size = CGSize(width: 40, height: 40)
        return rect
    }
}

extension DZButtonMenuItem {
    private func adjustSubviews() {
        let btn = self.button
        btn.frame = CGRect(x: 0, y: 0, width: attributes.buttonDiameter, height: attributes.buttonDiameter);
        
        let lbl = self.label
        let lblRect = self.title.boundingRect(with: CGSize(width: 200, height: attributes.labelHeight),
                                              options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)],
                                              context: nil);
        lbl.frame = CGRect(x: 0, y: 0, width: lblRect.size.width+20, height: attributes.labelHeight);
    }
    
    private func makeButton() {
        let btn = self.button
        btn.frame = CGRect(x: 0, y: 0, width: attributes.buttonDiameter, height: attributes.buttonDiameter);
        if let _img = image {
            btn.setImage(_img, for: .normal);
        }
        else {
            btn.titleLabel?.font    = UIFont.boldSystemFont(ofSize: 16);
            btn.setTitle(self.title.prefix(1).uppercased(), for: .normal);
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 24.0);
        }
        btn.backgroundColor     = attributes.closedColor;
        btn.layer.cornerRadius  = attributes.buttonDiameter/2
        btn.tag                 = attributes.mainButtonTag
        btn.alpha               = 0.0;
        
        btn.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControl.Event.touchUpInside);
    }
    
    private func makeLabel(){
        let lbl = self.label
        let lblRect = self.title.boundingRect(with: CGSize(width: 200, height: attributes.labelHeight),
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)],
                                            context: nil);
        lbl.font = UIFont.systemFont(ofSize: 12.0);
        lbl.numberOfLines = 1;
        lbl.frame = CGRect(x: 0, y: 0, width: lblRect.size.width+20, height: attributes.labelHeight);
        lbl.backgroundColor = attributes.closedColor;
        lbl.textAlignment = NSTextAlignment.center;
        lbl.textColor = UIColor.white;
        lbl.layer.cornerRadius = attributes.labelHeight/2;
        lbl.clipsToBounds = true;
        lbl.text = self.title;
        lbl.alpha = 0.0;
    }
}

extension DZButtonMenuItem {
    @objc private func buttonClicked(_ sender: UIButton) {
        Logger.debug("")
        self.action?()
    }
}

extension DZButtonMenuItem {
    internal func show(at view: UIView, index: Int, animated: Bool = true, callback: (()->Void)? = nil) {
        view.addSubview(self.button)
        self.button.frame.origin = self.attributes.initialFrame.origin
        switch self.configuration.style {
        case .sector:
            UIView.animate(withDuration: 0.3, delay: 0.2 * Double(self.index) , options: [], animations: {
                self.button.frame = self.targetFrame(for: self.index)
                self.button.alpha = 1.0;
                self.label.frame = self.targetFrame(for: self.index)
                self.label.alpha = 1.0;
            }) { (finished) in
                callback?()
            }
        case .line:
            UIView.animateKeyframes(withDuration: 0.3+0.3*Double(index), delay: 0.0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: Double(index)/Double(index+1), animations: {
                    self.button.frame = self.targetFrame(for: index-1)
                    self.button.alpha = 0.0;
                    self.label.frame = self.targetFrame(for: index-1)
                    self.label.alpha = 0.0;
                })
                UIView.addKeyframe(withRelativeStartTime: Double(index)/Double(index+1), relativeDuration: 1/Double(index+1), animations: {
                    self.button.frame = self.targetFrame(for: index)
                    self.button.alpha = 1.0;
                    self.label.frame = self.targetFrame(for: index)
                    self.label.alpha = 1.0;
                })
            }) { (finished) in
                callback?()
            }
        }
    }
    
    internal func hide(index: Int, of count: Int) {
        switch self.configuration.style {
        case .sector:
            UIView.animate(withDuration: 0.3, delay: 0.2 * Double(self.index) , options: [], animations: {
                self.button.frame.origin = self.attributes.initialFrame.origin
                self.button.alpha = 0.0;
            }) { (finished) in
                self.button.removeFromSuperview()
                self.label.removeFromSuperview()
            }
        case .line:
            let kDelay = count - self.index - 1
            UIView.animateKeyframes(withDuration: 0.3+0.3*Double(index), delay: 0.3*Double(kDelay), options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0/Double(count-kDelay), animations: {
                    self.button.frame = self.targetFrame(for: index-1)
                    self.button.alpha = 0.0;
                    self.label.frame = self.targetFrame(for: index-1)
                    self.label.alpha = 0.0;
                })
                UIView.addKeyframe(withRelativeStartTime: Double(index)/Double(index+1), relativeDuration: Double(index)/Double(count-kDelay), animations: {
                    self.button.frame = self.attributes.initialFrame
                    self.button.alpha = 0.0;
                    self.label.frame = self.attributes.initialFrame
                    self.label.alpha = 0.0;
                })
            }) { (finished) in
                self.button.removeFromSuperview()
                self.label.removeFromSuperview()
            }
        }
    }
}

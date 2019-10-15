//
//  DZButtonMenu.swift
//  DarkEggKit/ButtonMenu
//
//  Created by darkzero on 14/10/25.
//  Copyright © 2019 darkzero. All rights reserved.
//

import Foundation
import UIKit

public protocol DZButtonMenuDelegate {
    // click event
    func buttonMenu(_ aButtonMenu: DZButtonMenu, ClickedButtonAtIndex index: Int);
}

//let MAIN_BTN_OPEN_STR: String   = "▲";
//let MAIN_BTN_CLOSE_STR: String  = "▼";

public class DZButtonMenu : UIView {
    // MARK: - enums
    public enum State: String {
        case closed
        case opened
        case closing
        case opening
    }
    
    /// Location
    /// use 3 bit
    ///     0x000 (0) bottom + right
    ///     0x001 (1) bottom + left
    ///     0x010 (2) top + right
    ///     0x011 (3) top + left
    ///     0x100 (4) free //TODO:
    ///
    /// - free: free
    /// - leftTop: left + top
    /// - rightTop: right + top
    /// - leftBottom: left + bottom
    /// - rightBottom: right + bottom
    public enum Location: UInt {
        case rightBottom    = 0b000
        case leftBottom     = 0b001
        // TODO: deprecated in version 0.4.0, should be fixed in 0.4.1
        @available(*, deprecated, message: "Not available in this version(0.4.0) ...")
        case rightTop       = 0b010
        @available(*, deprecated, message: "Not available in this version(0.4.0) ...")
        case leftTop        = 0b011
        @available(*, deprecated, message: "Not available in this version(0.4.0) ...")
        case free           = 0b100
        
        var isLeft: Bool {
            return ((self.rawValue & 0b001) > 0)
        }
        
        var isTop: Bool {
            return ((self.rawValue & 0b010) > 0)
        }
    }
    
    /// Menu direction
    ///
    /// - left: left
    /// - right: right
    /// - up: up
    /// - down: down
    public enum Direction: String {
        case left
        case right
        case up
        case down
    }
    
    /// Style
    ///
    /// - line: line
    /// - sector: sector
    public enum Style: String {
        case line   = "line"
        @available(*, deprecated, message: "Not available(can use, not prefect) in this version(0.4.0) ...")
        case sector = "sector"
    }
    
    // MARK: - private properties
    private var configuration: DZButtonMenuConfiguration = DZButtonMenuConfiguration()
    private var attributes: DZButtonMenuAttributes = DZButtonMenuAttributes()
    private var items: [DZButtonMenuItem] = []
    private var maskBg: UIView?;
    private var mainButton: UIButton = UIButton(type: .custom)
    private var menuState: DZButtonMenu.State = .closed
    
    // MARK: - public properties
    public var delegate: DZButtonMenuDelegate?;
    
    // MARK: - internal properties
    internal var openImage: String?;
    internal var closeImage: String?;
    
    // MARK: - init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(configuration: DZButtonMenuConfiguration = .default(), attributes: DZButtonMenuAttributes = .default()) {
        super.init(frame: .zero)
        self.attributes = attributes
        self.configuration = configuration
        // adjust direction with location(20191007)
        self.configuration.adjustDirection()
        
        self.frame.size = CGSize(width: self.attributes.buttonDiameter, height: self.attributes.buttonDiameter)
        // Mask
        self.maskBg = UIView.init(frame: UIScreen.main.bounds)
        if #available(iOS 13, *) {
            #if swift(>=5.1)
            self.maskBg?.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.6)
            #else
            self.maskBg?.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            #endif
        }
        else {
            self.maskBg?.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        }
        self.maskBg?.isHidden = true;
        self.clipsToBounds = false;
        self.createMainButton(closeImage: nil, openImage: nil);
    }
    
    public func addButton(title: String = "", image: UIImage? = nil, action: (()->Void)? = nil) {
        // Button
        let btn = DZButtonMenuItem(title: title, image: image, action: action)
        btn.initialLocation = self.frame.origin
        btn.attributes = self.attributes
        btn.configuration = self.configuration
        btn.index = self.items.count
        self.items.append(btn)
    }
    
    // MARK: - private functions
    private func createMainButton(closeImage: String?, openImage: String?)
    {
        let btnMain = self.mainButton
        btnMain.frame = CGRect(origin: .zero, size: CGSize(width: self.attributes.buttonDiameter, height: self.attributes.buttonDiameter))
        btnMain.backgroundColor = self.attributes.closedColor
        btnMain.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
        // image
        if( closeImage != nil ) {
            btnMain.setImage(UIImage(named: closeImage!), for: .normal)
            btnMain.setImage(UIImage(named: openImage!), for: .selected)
        }
        else {
            let closeImage = UIImage(named: "main_close", in: Bundle(for: DZButtonMenu.self), compatibleWith: nil)//?.withRenderingMode(.alwaysTemplate)
            let openImage = UIImage(named: "main_open", in: Bundle(for: DZButtonMenu.self), compatibleWith: nil)//?.withRenderingMode(.alwaysTemplate)
            btnMain.setImage(openImage, for: .normal)
            btnMain.setImage(closeImage, for: .selected)
        }
        
        if #available(iOS 13, *) {
            btnMain.tintColor = .systemBackground
        }
        else {
            btnMain.tintColor = .white
        }
        
        btnMain.tag = self.attributes.mainButtonTag
        btnMain.layer.cornerRadius = self.attributes.buttonDiameter/2
        self.addSubview(btnMain)
        btnMain.addTarget(self, action: #selector(DZButtonMenu.switchMenuStatus), for: .touchUpInside)
    }
    
    // MARK: - button action
    @objc func buttonClicked(_ sender:AnyObject) {
        self.delegate?.buttonMenu(self, ClickedButtonAtIndex: (sender.tag - self.attributes.mainButtonTag));
    }
}

// MARK: - Menu Animations
extension DZButtonMenu {
    @objc internal func switchMenuStatus() {
        if ( self.menuState == .closed ) {
            self.showMenu(withAnimation: true)
        }
        else if ( self.menuState == .opened ) {
            self.hideMenu(withAnimation: true)
        }
    }
    
    private func showMenu(withAnimation animation: Bool = true) {
        self.menuState = .opening
        self.mainButton.isEnabled = false
        if let superView = self.superview {
            superView.addSubview(self.maskBg!);
            self.maskBg?.isHidden = false;
            superView.bringSubviewToFront(self);
            
            for (index, item) in self.items.enumerated() {
                if index >= (self.items.count-1) {
                    item.show(at: superView, callback: {
                        self.afterShow()
                    })
                }
                else {
                    item.show(at: superView)
                }
            }
        }
        return
    }
    
    private func afterShow() {
        let mainBtn = self.viewWithTag(self.attributes.mainButtonTag) as! UIButton
        mainBtn.isSelected = true
        mainBtn.isEnabled = true
        self.menuState = .opened
    }
    
    fileprivate func hideMenu(withAnimation animation:Bool = true) {
        self.menuState = .closing
        self.mainButton.isEnabled = false
        for (index, item) in self.items.enumerated() {
            if index >= (self.items.count-1) {
                item.hide(of: self.items.count, callback: {
                    self.afterHide()
                })
            }
            else {
                item.hide(of: self.items.count)
            }
        }
    }
    
    fileprivate func afterHide() {
        self.maskBg?.removeFromSuperview();
        self.maskBg?.isHidden = true;
        let mainBtn = self.viewWithTag(self.attributes.mainButtonTag) as! UIButton;
        mainBtn.isSelected = false
        mainBtn.isEnabled = true
        self.menuState = .closed;
    }
    
}

// MARK: - layoutSubviews
extension DZButtonMenu {
    public override func layoutSubviews() {
        super.layoutSubviews()
        if ( self.superview != nil ) {
            self.frame = self.attributes.mainFrameOf(location: self.configuration.location, inView: self.superview!)
        }
    }
}

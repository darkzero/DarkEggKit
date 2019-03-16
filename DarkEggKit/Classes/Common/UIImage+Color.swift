//
//  UIImage+Color.swift
//  DarkEggKit/Common
//
//  Created by darkzero on 2019/03/04.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

public enum GradientDirection: String {
    case vertical   = "vertical"
    case horizontal = "horizontal"
}

// MARK: - Extension of UIImage
extension UIImage {
    /// Create image with color
    ///
    /// - Parameters:
    ///   - color: color
    ///   - size: image size
    /// - Returns: image
    public class func imageWithColor( _ color:UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        var rect:CGRect
        rect = CGRect(origin: CGPoint.zero, size: size);
        
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// Make image with layer
    ///
    /// - Parameter layer: layer
    /// - Returns: image
    public class func imageWithLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return outputImage!
    }
    
    /// Make image with gradient color
    /// default size is 64x64
    ///
    /// - Parameters:
    ///   - direction: direction(GradientDirection.horizontal or .vertical)
    ///   - colors: colors(CGColor)
    /// - Returns: image
    public class func imageWithGradient(colors: CGColor..., size: CGSize = CGSize(width: 64, height: 64), direction: GradientDirection = .horizontal) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: size)
        gradient.colors = colors
        switch direction {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        }
        let outputImage = UIImage.imageWithLayer(layer: gradient);
        return outputImage;
    }
}

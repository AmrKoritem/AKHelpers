//
//  Gradient.swift
//  AKHelpers
//
//  Created by Amr Koritem on 11/02/2023.
//

import UIKit

public struct GradientPoint {
    let location: CGFloat
    let color: UIColor
}

public extension UIImage {
    convenience init?(size: CGSize, gradientPoints: [GradientPoint]) {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        // If the size is zero, then the context will be nil.
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        guard let gradient = CGGradient(
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            colorComponents: gradientPoints.compactMap { $0.color.cgColor.components }.flatMap { $0 },
            locations: gradientPoints.map { $0.location },
            count: gradientPoints.count) else { return nil }
        
        context.drawLinearGradient(
            gradient,
            start: CGPoint.zero,
            end: CGPoint(x: 0, y: size.height),
            options: CGGradientDrawingOptions()
        )
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        self.init(cgImage: image)
        defer { UIGraphicsEndImageContext() }
    }
}

public extension UIView {
    /// Adds a gradient colored layer for your view according to the points and frame provided.
    /// - Parameters:
    ///   - gradientPoints: Colors and positions that help determining the gradient color.
    ///   - frame: Bounds of your gradient layer.
    /// - Returns: The gradient layer.
    @discardableResult func gradiate(with gradientPoints: [GradientPoint], frame: CGRect? = nil) -> CAGradientLayer {
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = frame ?? bounds
        gradientMaskLayer.colors = gradientPoints.map { $0.color.cgColor }
        gradientMaskLayer.locations = gradientPoints.map { $0.location as NSNumber }
        layer.insertSublayer(gradientMaskLayer, at: 0)
        return gradientMaskLayer
    }
}

public extension UIViewController {
    /// Adds a gradient colored background for your view controller according to the points provided.
    /// - Parameters:
    ///   - gradientPoints: Colors and positions that help determining the gradient color.
    ///   - backgroundImage: If not nil, the provided image will be shown below the gradient color.
    /// - Returns: The image view that has the image and the gradient color, and the gradient layer.
    @discardableResult func gradiateBackground(
        gradientPoints: [GradientPoint],
        backgroundImage: UIImage? = nil
    ) -> (backgroundImageView: UIImageView, gradientLayer: CAGradientLayer) {
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.backgroundColor = .clear
        if let image = backgroundImage {
            backgroundImageView.image = image
        }
        let gradientLayer = backgroundImageView.gradiate(with: gradientPoints, frame: view.frame)
        view.addSubview(backgroundImageView)
        view.addConstraints([
            NSLayoutConstraint(
                item: backgroundImageView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view,
                attribute: .leading,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: backgroundImageView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view,
                attribute: .trailing,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: backgroundImageView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: view,
                attribute: .bottom,
                multiplier: 1,
                constant: 0
            )
        ])
        view.sendSubviewToBack(backgroundImageView)
        return (backgroundImageView: backgroundImageView, gradientLayer: gradientLayer)
    }
}

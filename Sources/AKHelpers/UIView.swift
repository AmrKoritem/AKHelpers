//
//  UIView.swift
//  AKHelpers
//
//  Created by Amr Koritem on 11/02/2023.
//

import UIKit

extension UIView {
    /// Default value for the _.xib_ file name usually used.
    open class var nibName: String {
        String(describing: self)
    }
    
    /// Load the view from a nib file.
    /// - Parameters:
    ///   - bundle: The bundle where the class is located.
    ///   - nibName: The name of the nib file, this is the class name by default.
    /// - Returns: The loaded view.
    open class func loadXib(bundle: Bundle = .main, nibName: String = nibName) -> Self? {
        bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? Self
    }

    @IBInspectable open var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable open var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable open var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    /// Sets clipsToBounds property to true.
    @discardableResult public func clipedToBounds() -> Self {
        clipsToBounds = true
        return self
    }
    
    /// Sets corner radius of the specified corners to the given radius.
    /// - Parameters:
    ///   - corners: Corners to be rounded.
    ///   - radius: If not provided, the corners radius value will be half of the view height.
    /// - Returns: The same view with its corners rounded.
    @discardableResult public func withRounded(
        corners: UIRectCorner = .allCorners,
        radius: CGFloat? = nil
    ) -> Self {
        let radius = radius ?? frame.size.height / 2
        guard corners != .allCorners else {
            layer.cornerRadius = radius
            return self
        }
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        return self
    }

    /// Adds a border to the view with the given line width and color.
    @discardableResult public func bordered(
        with borderWidth: CGFloat = 1.0,
        color borderColor: UIColor
    ) -> Self {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        return self
    }

    /// Shadows the view with the given parameters.
    @discardableResult public func shadowed(
        with color: UIColor,
        radius: CGFloat,
        offset: CGSize,
        opacity: Float
    ) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        return self
    }

    @discardableResult public func shadowRemoved() -> Self {
        layer.shadowColor = UIColor.clear.cgColor
        return self
    }

    /// Add another view as subview and constraints the added view to the edges.
    public func embed(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    /// Add another view as subview and constraints the added view to the edges of the safe area.
    public func embedWithSafeArea(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

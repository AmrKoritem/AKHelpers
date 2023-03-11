//
//  Utilities.swift
//  AKHelpers
//
//  Created by Amr Koritem on 10/02/2023.
//

import UIKit

// MARK: - Instantiation of view controllers
public extension UIStoryboard {
    /// The storyboard id of this view controller exactly as the view controller class name, else it won't work.
    func instantiate<T: UIViewController>(viewController: T.Type) -> T {
        instantiateViewController(withIdentifier: T.storyboardId) as? T ?? T()
    }

    func instantiate<T: UIViewController>(withIdentifier storyboardId: String) -> T {
        instantiateViewController(withIdentifier: storyboardId) as? T ?? T()
    }
}

public extension UIModalPresentationStyle {
    /// Typically used with `UIViewController.navigateTo(_:presentationStyle:transitionStyle:animated:)` when iOS versions below 13.0 is supported to make the method navigates using _present_ instead of _show_ .
    static var automaticAllVersions: UIModalPresentationStyle {
        guard #available(iOS 13.0, tvOS 13.0, *) else { return .fullScreen }
        return .automatic
    }
}

public extension UIApplication {
    /// The current root window.
    static var rootWindow: UIWindow? {
        guard #available(iOS 13, tvOS 13.0, *) else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }

    /// The current root view controller.
    static var rootViewController: UIViewController? {
        rootWindow?.rootViewController
    }

    /// Gets you the top most view controller.
    class func topViewController(
        controller: UIViewController? = UIApplication.rootViewController
    ) -> UIViewController? {
        switch controller {
        case is UINavigationController:
            return topViewController(controller: (controller as? UINavigationController)?.visibleViewController)
        case is UITabBarController:
            return topViewController(controller: (controller as? UITabBarController)?.selectedViewController)
        default:
            return controller?.presentedViewController ?? controller
        }
    }
}

precedencegroup OptionalAssignment { associativity: right }
infix operator ?= : OptionalAssignment
func ?= <T: Any> ( left: inout T, right: T?) {
    guard let right = right else { return }
    left = right
}

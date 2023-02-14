//
//  Navigation.swift
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

public extension UIViewController {
    /// Default value for the storyboard identifier usually used.
    class var storyboardId: String {
        String(describing: self)
    }

    /// Default value for the _.xib_ file name usually used.
    class var nibName: String {
        String(describing: self)
    }

    convenience init(bundle: Bundle?) {
        self.init(nibName: Self.nibName, bundle: bundle ?? .main)
    }

    /// Function that creates and returns instance of the current UIViewController given its storyboard.
    /// - Parameters:
    ///  - storyboard: Name of the resource (nib or storyboard), it is name of the UIViewController class by default.
    ///  - identifier: storyboard id of view controller in stroryboard. The default value is the UIViewController class.
    ///  - bundle: The bundle where nib file or storyboard exist. The default value is the main bundle.
    class func instance<T: UIViewController>(
      from storyboard: UIStoryboard,
      with storyboardId: String = String("\(T.self)")
    ) -> T {
        storyboard.instantiateViewController(withIdentifier: storyboardId) as? T ?? T()
    }

    /// Generic function that creates and returns instance of the current UIViewController.
    /// - Parameters:
    ///  - name: Name of the resource (nib or storyboard), it is name of the UIViewController class by default.
    ///  - identifier: storyboard id of view controller in stroryboard. The default value is the UIViewController class.
    ///  - bundle: The bundle where nib file or storyboard exist. The default value is the main bundle.
    class func instance<T: UIViewController>(
      from name: String = String("\(T.self)"),
      with identifier: String = String("\(T.self)"),
      bundle: Bundle? = nil
    ) -> T {
        let appBundle = bundle ?? .main
        guard appBundle.path(forResource: name, ofType: "storyboardc") != nil else {
            guard appBundle.path(forResource: name, ofType: "nib") != nil else { return T() }
            return T(nibName: name, bundle: appBundle)
        }
        let storyboard = UIStoryboard(name: name, bundle: appBundle)
        return instance(from: storyboard, with: identifier)
    }
}

// MARK: - Backward navigation functions
public extension UIViewController {
    /// Function that pops the view controller if it had a navigation controller.
    @objc func back(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    /// Function that dismisses the view controller if it was presented, else it will attempt to pop it if it had a navigation controller.
    @objc func close(animated: Bool = true) {
        guard isPresented else { return back() }
        dismiss(animated: animated)
    }
}

// MARK: - Forward navigation functions
public extension UIViewController {
    /// Function that will _present_ the provided view controller if a _presentationStyle_ was provided, else it will _show_ it.
    /// - Parameters:
    ///   - viewController: The destination view controller.
    ///   - presentationStyle: If not provided, the function will _show_ the view controller instead of _present_ it.
    ///   - transitionStyle: Transition style to be used when presenting.
    ///   - animated: Determines if the navigation will be animated.
    func navigateTo(
        _ viewController: UIViewController,
        presentationStyle: UIModalPresentationStyle? = nil,
        transitionStyle: UIModalTransitionStyle = .coverVertical,
        animated: Bool = true
    ) {
        guard let presentationStyle = presentationStyle else {
            return show(viewController, sender: self)
        }
        viewController.modalTransitionStyle = transitionStyle
        viewController.modalPresentationStyle = presentationStyle
        present(viewController, animated: animated)
    }

    @available(iOS 15.0, *)
    @available(tvOS, unavailable)
    /// Presents the given view controller as a sheet.
    /// - Parameters:
    ///   - viewController: Presented view controller.
    ///   - detents: Sheet detents. Must have at least one element.
    ///   - isDismissEnabled: When true, the presentation will prevent interactive dismiss and ignore events outside of the presented view controller's bounds.
    ///   - preferredCornerRadius: This value is only respected when the sheet is at the front of its stack.
    ///   - animated: Determines if the presentation is animated.
    func presentAsSheet(
        viewController: UIViewController,
        detents: [UISheetPresentationController.Detent] = [.medium()],
        isDismissEnabled: Bool = false,
        preferredCornerRadius: CGFloat = 0,
        animated: Bool = true
    ) {
        let navigationController = viewController as? UINavigationController
        let navC = navigationController ?? UINavigationController(rootViewController: viewController)
        present(
            navC.prepareSheetWith(
                detents: detents,
                isDismissEnabled: isDismissEnabled,
                preferredCornerRadius: preferredCornerRadius),
            animated: animated)
    }
}

@available(tvOS, unavailable)
public extension UIViewController {
    /// Presents the given view controller as an alert.
    /// - Parameters:
    ///   - popoverContentController: The view controller to be presented.
    ///   - preferredContentSize: Presented view controller size.
    ///   - popoverPresentationControllerDelegate: Provide your delegate if you don't want your view controller as the delegate.
    ///   - animated: Determines if the presentation is animated.
    func presentInMiddleOfScreen(
        _ popoverContentController: UIViewController,
        preferredContentSize: CGSize? = nil,
        popoverPresentationControllerDelegate: UIPopoverPresentationControllerDelegate? = nil,
        animated: Bool = true
    ) {
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.preferredContentSize ?= preferredContentSize

        guard let popoverPresentationController = popoverContentController.popoverPresentationController else { return }
        popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popoverPresentationController.sourceView = view
        let sourceRect = view.bounds
        popoverPresentationController.sourceRect = CGRect(x: sourceRect.midX, y: sourceRect.midY, width: 0, height: 0)
        popoverPresentationController.delegate = popoverPresentationControllerDelegate ?? self
        present(popoverContentController, animated: animated)
    }

    /// Presents a share sheet for the supplied items.
    /// - Parameters:
    ///   - activityItems: Items to be shared.
    ///   - animated: Determines if the presentation is animated.
    func share(activityItems: [Any], animated: Bool = true) {
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityVC, animated: animated)
    }
}

// MARK: - Navigation helpers
extension UIViewController {
    /// Checks if the current UIViewController instance is presented modally.
    var isPresented: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?
            .presentingViewController?
            .presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?
            .presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    /// Darkens the views under the presented view controller according to _alpha_ parameter value.
    /// - Parameter alpha: Its value should be within 0.0 : 1.0 . Values below 1 will darken the screen.
    public func setAlphaOfBackgroundViews(alpha: CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.alpha = alpha
            self?.navigationController?.navigationBar.alpha = alpha
        }
    }
}

@available(tvOS, unavailable)
extension UIViewController: UIPopoverPresentationControllerDelegate {
    // MARK: - UIAdaptivePresentationControllerDelegate
    open func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }

    // MARK: - UIPopoverPresentationControllerDelegate
    open func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        setAlphaOfBackgroundViews(alpha: 0.2)
    }

    open func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) {
        setAlphaOfBackgroundViews(alpha: 1)
    }

    open func popoverPresentationControllerShouldDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) -> Bool {
        true
    }
}

public extension UIModalPresentationStyle {
    /// Typically used with `UIViewController.navigateTo(_:presentationStyle:transitionStyle:animated:)` when iOS versions below 13.0 is supported to make the method navigates using _present_ instead of _show_ .
    static var automaticAllVersions: UIModalPresentationStyle {
        guard #available(iOS 13.0, tvOS 13.0, *) else { return .fullScreen }
        return .automatic
    }
}

@available(iOS 15.0, *)
@available(tvOS, unavailable)
public extension UINavigationController {
    /// Prepares the navigation controller to be presented as a sheet.
    /// - Parameters:
    ///   - detents: Sheet detents. Must have at least one element.
    ///   - isDismissEnabled: When true, the presentation will prevent interactive dismiss and ignore events outside of the presented view controller's bounds.
    ///   - preferredCornerRadius: This value is only respected when the sheet is at the front of its stack.
    func prepareSheetWith(
        detents: [UISheetPresentationController.Detent] = [.medium()],
        isDismissEnabled: Bool = false,
        preferredCornerRadius: CGFloat = 0
    ) -> Self {
        setValue(!isDismissEnabled, forKey: "isModalInPresentation")
        let sheet = sheetPresentationController
        sheet?.detents = detents
        sheet?.largestUndimmedDetentIdentifier = .large
        sheet?.setValue(preferredCornerRadius, forKey: "preferredCornerRadius")
        return self
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

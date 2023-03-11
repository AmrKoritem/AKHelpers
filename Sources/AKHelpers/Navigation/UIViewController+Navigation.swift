//
//  UIViewController+Navigation.swift
//  AKHelpers
//
//  Created by Amr Koritem on 10/03/2023.
//

import UIKit

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
    /// Pops view controllers until the one specified. Returns the popped controllers.
    @discardableResult func back(
        to viewController: UIViewController,
        animated: Bool = true
    ) -> [UIViewController]? {
        navigationController?.popToViewController(viewController, animated: animated)
    }

    /// Pops view controllers until the one with the specified class.
    func back<T: UIViewController>(
        to viewController: T.Type,
        animated: Bool = true
    ) {
        guard let viewControllers = navigationController?.viewControllers,
              let destinationVC = viewControllers.filter({ $0 is T }).last else { return }
        back(to: destinationVC, animated: animated)
    }

    /// Function that pops the view controller if it had a navigation controller. Returns the poped view controller.
    @discardableResult @objc func back(animated: Bool = true) -> UIViewController? {
        navigationController?.popViewController(animated: animated)
    }

    /// Function that dismisses the view controller if it was presented, else it will attempt to pop it if it had a navigation controller.
    @objc func close(animated: Bool = true) {
        guard isPresented else {
            back()
            return
        }
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

    /// Presents the given view controller as a sheet.
    /// - Parameters:
    ///   - view: Presented view.
    ///   - height: Sheet height.
    ///   - isDismissEnabled: When true, you will be able to dismiss the sheet by tapping outside it.
    ///   - cornerRadius: Sheet corner radius.
    ///   - alphaOfBackgroundViews: Darkens the views under the presented view controller when less than 1.
    ///   - animated: Determines if the presentation is animated.
    func presentAsSheet(
        view: UIView,
        height: CGFloat? = nil,
        isDismissEnabled: Bool = false,
        cornerRadius: CGFloat = 20,
        delegate: SheetViewControllerDelegate? = nil,
        animated: Bool = true
    ) {
        let svc = SheetViewController(
            height: height,
            isDismissEnabled: isDismissEnabled,
            cornerRadius: cornerRadius,
            delegate: delegate ?? self)
        svc.embededView = view
        present(svc, animated: true)
    }

    /// Presents the given view controller as a sheet.
    /// - Parameters:
    ///   - viewController: Presented view controller.
    ///   - height: Sheet height.
    ///   - isDismissEnabled: When true, you will be able to dismiss the sheet by tapping outside it.
    ///   - cornerRadius: Sheet corner radius.
    ///   - alphaOfBackgroundViews: Darkens the views under the presented view controller when less than 1.
    ///   - animated: Determines if the presentation is animated.
    func presentAsSheet(
        viewController: UIViewController,
        height: CGFloat? = nil,
        isDismissEnabled: Bool = false,
        cornerRadius: CGFloat = 20,
        delegate: SheetViewControllerDelegate? = nil,
        animated: Bool = true
    ) {
        let svc = SheetViewController(
            height: height,
            isDismissEnabled: isDismissEnabled,
            cornerRadius: cornerRadius,
            delegate: delegate ?? self)
        svc.addChild(viewController)
        svc.embededView = viewController.view
        viewController.didMove(toParent: svc)
        present(svc, animated: true)
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
        delegate: UIPopoverPresentationControllerDelegate? = nil,
        animated: Bool = true
    ) {
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.preferredContentSize ?= preferredContentSize

        guard let popoverPresentationController = popoverContentController.popoverPresentationController else { return }
        popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popoverPresentationController.sourceView = view
        let sourceRect = view.bounds
        popoverPresentationController.sourceRect = CGRect(x: sourceRect.midX, y: sourceRect.midY, width: 0, height: 0)
        popoverPresentationController.delegate = delegate ?? self
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
    public func setBackgroundViewsAlpha(alpha: CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.alpha = alpha
            self?.navigationController?.navigationBar.alpha = alpha
        }
    }
}

extension UIViewController: SheetViewControllerDelegate {
    open func prepareForSheetPresentation() {
        setBackgroundViewsAlpha(alpha: 0.5)
    }

    open func sheetPresentationControllerDidDismissPopover() {
        setBackgroundViewsAlpha(alpha: 1)
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
        setBackgroundViewsAlpha(alpha: 0.5)
    }

    open func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        setBackgroundViewsAlpha(alpha: 1)
    }

    open func popoverPresentationControllerShouldDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) -> Bool {
        true
    }
}

//
//  SheetViewController.swift
//  AKHelpers
//
//  Created by Amr Koritem on 10/03/2023.
//

import UIKit

public protocol SheetViewControllerDelegate: AnyObject {
    func prepareForSheetPresentation()
    func sheetPresentationControllerDidDismissPopover()
}

final class SheetViewController: UIViewController {
    var embededView: UIView? {
        willSet {
            embededView?.removeFromSuperview()
            addEmbededView(newValue)
        }
    }
    var isDismissEnabled = true
    var cornerRadius: CGFloat = 0

    weak var delegate: SheetViewControllerDelegate?

    lazy var height: CGFloat = view.frame.size.height

    private var heightConstraint: NSLayoutConstraint?

    convenience init(
        height: CGFloat? = nil,
        isDismissEnabled: Bool = false,
        cornerRadius: CGFloat = 0,
        delegate: SheetViewControllerDelegate?
    ) {
        self.init()
        self.height ?= height
        self.isDismissEnabled = isDismissEnabled
        self.cornerRadius = cornerRadius
        self.delegate = delegate
        modalPresentationStyle = .overCurrentContext
        delegate?.prepareForSheetPresentation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        guard isDismissEnabled else { return }
        dismissWhenTappedAround()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.sheetPresentationControllerDidDismissPopover()
    }

    func addEmbededView(_ embededView: UIView? = nil) {
        guard let embededView = embededView ?? self.embededView else { return }
        view.addSubview(embededView)
        embededView.withRounded(corners: [.topLeft, .topRight], radius: cornerRadius)
        embededView.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = embededView.heightAnchor.constraint(equalToConstant: height)
        guard let heightConstraint = heightConstraint else { return }
        NSLayoutConstraint.activate([
            embededView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            embededView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            heightConstraint,
            embededView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    func dismissWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

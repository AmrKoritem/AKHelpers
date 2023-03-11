//
//  SecondTabViewController.swift
//  Example
//
//  Created by Amr Koritem on 10/03/2023.
//

import UIKit

class SecondTabViewController: UIViewController {
    @IBAction func presentAlert() {
        guard let pvc = storyboard?.instantiate(viewController: PresentedViewController.self) else { return }
        presentInMiddleOfScreen(pvc)
    }

    @IBAction func presentSheet() {
        guard let pvc = storyboard?.instantiate(viewController: PresentedViewController.self) else { return }
        presentAsSheet(viewController: pvc, height: 200, isDismissEnabled: true, cornerRadius: 20)
    }
}

//
//  FirstViewController.swift
//  Example
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit
import AKHelpers

class FirstViewController: UIViewController {
    @IBAction func goToSecondScreen() {
        guard let vc = storyboard?.instantiate(viewController: SecondViewController.self) else { return }
        navigateTo(vc)
    }
}

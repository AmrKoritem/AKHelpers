//
//  SecondViewController.swift
//  Example
//
//  Created by Amr Koritem on 26/09/2022.
//

import UIKit

class SecondViewController: UIViewController {
    @IBAction func goToSettings() {
        guard let vc = storyboard?.instantiate(viewController: SettingsViewController.self) else { return }
        navigateTo(vc)
    }
}

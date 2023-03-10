//
//  SettingsViewController.swift
//  Example
//
//  Created by Amr Koritem on 09/09/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBAction func goBack() {
        back()
    }
    @IBAction func goToFirstScreen() {
        back(to: FirstViewController.self)
    }
}

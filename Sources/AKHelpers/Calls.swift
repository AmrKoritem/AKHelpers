//
//  Calls.swift
//  AKHelpers
//
//  Created by Amr Koritem on 11/02/2023.
//

import UIKit

public extension String {
    /// Use this method when your string is an email.
    func sendEmail() {
        "mailto:\(self)".openUrl()
    }

    /// Use this method when your string is a phone number.
    func dialNumber() {
        "tel://\(self)".openUrl()
    }

    /// For the method to work, add the following to _info.Plist_:
    /// <key>LSApplicationQueriesSchemes</key>
    /// <array>
    ///   <string>whatsapp</string>
    /// </array>
    func callWhatsapp(useWebIfAppNotAvailable useWeb: Bool = false, messagePreText: String? = nil) {
        let queryCharSet = NSCharacterSet.urlQueryAllowed
        // if your text message contains special characters like **+ and &** then add this line
        // queryCharSet.remove(charactersIn: "+&")
        let escapedString = (messagePreText ?? "").addingPercentEncoding(withAllowedCharacters: queryCharSet)
        let appUrl = "https://wa.me/\(self)?text=\(escapedString ?? "")"
        guard appUrl.openUrl() else {
            guard useWeb else { return }
            let webUrl = "https://api.whatsapp.com/send?phone=\(self)&text=\(escapedString ?? "")"
            webUrl.openUrl()
            return
        }
    }

    /// Returns true if the url is opened successfully.
    @discardableResult func openUrl() -> Bool {
        guard let url = URL(string: "\(self)"), UIApplication.shared.canOpenURL(url) else { return false }
        guard #available(iOS 10.0, *) else {
            UIApplication.shared.openURL(url)
            return true
        }
        UIApplication.shared.open(url)
        return true
    }

    /// Returns true if the url can be opened successfully.
    func canOpenURL() -> Bool {
        guard let url = URL(string: "\(self)") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}

//
//  TableViews.swift
//  AKHelpers
//
//  Created by Amr Koritem on 10/02/2023.
//

import UIKit

public extension UITableViewCell {
    /// Default value for the reuse identifier usually used.
    class var reuseIdentifier: String {
        String(describing: self)
    }

    /// UITableView containing the cell.
    var tableView: UITableView? {
        var view = superview
        while view != nil && (view as? UITableView) == nil {
          view = view?.superview
        }
        return view as? UITableView
    }
}

public extension UITableView {
    /// Use this function to register a cell that has a _.xib_ file.
    func registerNib<T: UITableViewCell>(
        _ tableViewCell: T.Type,
        in bundle: Bundle? = nil
    ) {
        register(
            UINib(nibName: T.nibName, bundle: bundle),
            forCellReuseIdentifier: T.reuseIdentifier
        )
    }

    /// Use this function to register a cell that doesn't have a _.xib_ file.
    func register<T: UITableViewCell>(_ tableViewCell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

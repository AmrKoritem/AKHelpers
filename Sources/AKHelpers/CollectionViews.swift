//
//  CollectionViews.swift
//  AKHelpers
//
//  Created by Amr Koritem on 10/02/2023.
//

import UIKit

public extension UICollectionViewCell {
    /// Default value for the reuse identifier usually used.
    class var reuseIdentifier: String {
        String(describing: self)
    }

    /// UICollectionView containing the cell.
    var collection: UICollectionView? {
        var view = superview
        while view != nil && (view as? UICollectionView) == nil {
          view = view?.superview
        }
        return view as? UICollectionView
    }
}

public extension UICollectionView {
    /// Use this function to register a cell that has a _.xib_ file.
    func registerNib<T: UICollectionViewCell>(
        _ collectionViewCell: T.Type,
        in bundle: Bundle? = nil
    ) {
        register(
            UINib(nibName: T.nibName, bundle: bundle),
            forCellWithReuseIdentifier: T.reuseIdentifier
        )
    }

    /// Use this function to register a cell that doesn't have a _.xib_ file.
    func register<T: UICollectionViewCell>(_ collectionViewCell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    /// Use this function to register a header that has a _.xib_ file.
    func registerHeaderNib<T: UICollectionReusableView>(
        _ collectionViewHeader: T.Type,
        in bundle: Bundle? = nil
    ) {
        register(
            UINib(nibName: T.nibName, bundle: bundle),
            forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader",
            withReuseIdentifier: T.nibName
        )
    }

    /// Use this function to register a header that doesn't have a _.xib_ file.
    func registerHeader<T: UICollectionReusableView>(_ collectionViewHeader: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader",
            withReuseIdentifier: T.nibName
        )
    }

    /// Use this function to register a footer that has a _.xib_ file.
    func registerFooterNib<T: UICollectionReusableView>(
        _ collectionViewHeader: T.Type,
        in bundle: Bundle? = nil
    ) {
        register(
            UINib(nibName: T.nibName, bundle: bundle),
            forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter",
            withReuseIdentifier: T.nibName
        )
    }

    /// Use this function to register a footer that doesn't have a _.xib_ file.
    func registerFooter<T: UICollectionReusableView>(_ collectionViewHeader: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter",
            withReuseIdentifier: T.nibName
        )
    }
}

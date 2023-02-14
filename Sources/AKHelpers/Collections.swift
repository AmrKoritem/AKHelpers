//
//  Collections.swift
//  AKHelpers
//
//  Created by Amr Koritem on 10/02/2023.
//

import Foundation

public extension Int {
    /// Check if the integer is within the available indices of the given collection.
    func isWithinBounds<T: Collection>(of collection: T) -> Bool where T.Index == Int {
        collection.indices.contains(self)
    }

    /// Check if the integer is within the available indices of the given collection.
    func isWithinBounds<T: MutableCollection>(of collection: T) -> Bool where T.Index == Int {
        collection.indices.contains(self)
    }
}

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

public extension MutableCollection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }
        set {
            guard let newValue = newValue, indices.contains(index) else { return }
            self[index] = newValue
        }
    }
}

public extension Sequence where Element: Hashable {
    /// Map representing the count of every element in the array.
    var histogram: [Element: Int] {
        reduce(into: [:]) { counts, element in counts[element, default: 0] += 1 }
    }
}

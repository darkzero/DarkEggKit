//
//  Array+SafeIndex.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2019/03/31.
//

import UIKit

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

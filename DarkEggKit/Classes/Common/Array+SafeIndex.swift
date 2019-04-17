//
//  Array+SafeIndex.swift
//  DarkEggKit
//
//  Created by darkzero on 2019/03/31.
//

import UIKit

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

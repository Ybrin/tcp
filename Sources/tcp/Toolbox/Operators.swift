//
//  Operators.swift
//  filecrypt
//
//  Created by Koray Koska on 28.09.17.
//

import Foundation

// MARK: - Color specific

func +(lhs: ANSIColor, rhs: String) -> String {
    return "\(lhs.rawValue)\(rhs)"
}

func +(lhs: String, rhs: ANSIColor) -> String {
    return "\(lhs)\(rhs.rawValue)"
}

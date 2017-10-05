//
//  Logger.swift
//  filecrypt
//
//  Created by Koray Koska on 28.09.17.
//

import Foundation

enum ANSIColor: String {

    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"

    case reset = "\u{001B}[0m"

    func queued(_ str: String) -> String {
        return "\(rawValue)\(str)"
    }

    func stacked(_ str: String) -> String {
        return "\(str)\(rawValue)"
    }
}

extension String {

    func color(_ clr: ANSIColor) -> String {
        return clr + self
    }
}

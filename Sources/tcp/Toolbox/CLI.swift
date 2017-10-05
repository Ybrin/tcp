//
//  CLI.swift
//  tcp
//
//  Created by Koray Koska on 05.10.17.
//

import Foundation

class CLI {

    let prefix: String

    init(prefix: String = "TCP") {
        self.prefix = prefix
        generatePrefix()
    }

    private func generatePrefix() {
        Swift.print("\(prefix)> ", terminator: "")
    }

    private func removePrefix() {
        Swift.print("\u{001B}[2K\r")
    }

    func print(_ str: String) {
        removePrefix()
        Swift.print(str)
        generatePrefix()
    }

    func print(color: ANSIColor, string: String) {
        removePrefix()
        Swift.print(color + string + ANSIColor.reset)
        generatePrefix()
    }

    func getLine() -> String? {
        var inLine: UnsafeMutablePointer<Int8>?
        getline(&inLine, lineCapp, stdin)

        generatePrefix()

        guard let inLinePtr = inLine else {
            return nil
        }

        return String(cString: inLinePtr)
    }
}

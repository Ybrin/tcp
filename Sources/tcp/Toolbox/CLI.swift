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

    func getLine() -> String {
        var string = ""
        while string.characters.last != "\n" {
            let lineCapp: Int32 = 1024
            let inLine: UnsafeMutablePointer<Int8> = UnsafeMutablePointer<Int8>.allocate(capacity: 1024)
            // getline(&inLine, &lineCapp, stdin)

            fgets(inLine, lineCapp, stdin)

            string += String(cString: inLine)

            inLine.deallocate(capacity: 1024)
        }

        generatePrefix()

        return string
    }
}

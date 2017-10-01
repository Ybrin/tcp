//
//  ReadableStreamExtensions.swift
//  tcp
//
//  Created by Koray Koska on 01.10.17.
//

import Foundation
import Sockets

extension ReadableStream {

    public func readUnixLine() throws -> Bytes {
        var line: Bytes = []

        while let byte = try readByte() {
            // Continues until a `crlf` sequence is found
            if byte == .newLine {
                break
            }

            // Skip over any non-valid ASCII characters
            if byte > .carriageReturn {
                line += byte
            }
        }

        return line
    }
}

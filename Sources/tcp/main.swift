import Foundation
import Docopt
import Sockets

let programName = CommandLine.arguments.first ?? "tcp"
let help = """
Opens a TCP Connection and let you interact with it.

Usage:
  \(programName) <host> <port>
  \(programName) (-h | --help)

Examples:
  \(programName) apple.com 80

Options:
  -h, --help  Show this screen.
"""

var arguments = CommandLine.arguments
if arguments.count > 0 {
    arguments.remove(at: 0)
}

let result = Docopt.parse(help, argv: arguments, help: true, version: "1.0")

guard let host = result["<host>"] as? String, let portStr = result["<port>"] as? String, let port = UInt16(portStr) else {
    print("Docopt failed. Consider opening an issue on Github.")
    exit(1)
}

let tcp = try TCPInternetSocket(scheme: "stratum+tcp", hostname: host, port: port)

try tcp.connect()

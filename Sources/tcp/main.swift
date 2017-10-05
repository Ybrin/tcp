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

let cli = CLI(prefix: "TCP Input")

let tcp = try TCPInternetSocket(scheme: "stratum+tcp", hostname: host, port: port)
try tcp.connect()

var shouldPoll = true
var shouldRead = true

// Polling
DispatchQueue.global(qos: .background).async {
    while shouldPoll {
        // print("::: Reading next line! :::")
        do {
            let bytes = try tcp.readUnixLine()

            let line = String(bytes: bytes)
            // print("::: NEXT LINE IS :::")
            cli.print(color: .blue, string: line)
        } catch {
            print("::: Read failed... :::")
            print(error)
            sleep(1)
            exit(1)
            continue
        }
        sleep(1)
    }
}

// Writing
var inLine: UnsafeMutablePointer<Int8>?
let lineCapp: UnsafeMutablePointer<Int> = UnsafeMutablePointer<Int>.allocate(capacity: 1)
while shouldRead {
    getline(&inLine, lineCapp, stdin)
    guard let line = inLine else {
        cli.print(color: .red, string: "::: Could not read input :::")
        continue
    }
    let str = String(cString: line)

    // print("::: READ LINE :::")
    // print(str)

    do {
        let bytes = try tcp.write(str.makeBytes())
        cli.print("Bytes written: \(bytes)")
    } catch {
        print("::: Write failed :::")
        print(error)
        exit(1)
    }
}

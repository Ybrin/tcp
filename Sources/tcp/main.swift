import Foundation
import Sockets
#if os(Linux)
    import Dispatch
#endif

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

if arguments.contains("-h") || arguments.contains("--help") {
    print(help)
    exit(0)
}

guard arguments.count == 2 else {
    print(help)
    exit(1)
}

let host = arguments[0]
let portStr = arguments[1]
guard let port = UInt16(portStr) else {
    print("Port must be a UInt16 compatible type")
    print()
    print(help)
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
while shouldRead {
    Thread.sleep(forTimeInterval: 0.1)
    let line = cli.getLine()
    // cli.print(color: .red, string: "::: Could not read input :::")

    // print("::: READ LINE :::")
    // print(str)

    do {
        let bytes = try tcp.write(line.makeBytes())
        cli.print("Bytes written: \(bytes)")
    } catch {
        print("::: Write failed :::")
        print(error)
        exit(1)
    }
}

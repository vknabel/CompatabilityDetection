import Foundation
import Overture

struct ProcessFailedError: Error {}

func bash(_ command: String) throws {
    let process = Process()
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", command]
    process.launch()
    process.waitUntilExit()
    let status = Int(process.terminationStatus)
    if status != 0 {
        throw ProcessFailedError()
    }
}

func bash(_ arguments: [String]) throws {
    let process = Process()
    process.launchPath = "/bin/bash"
    process.arguments = arguments
    process.launch()
    process.waitUntilExit()
    let status = Int(process.terminationStatus)
    if status != 0 {
        throw ProcessFailedError()
    }
}

import Foundation
import PromptLine

var Current = Environment()

struct Environment {
    var network = Network()
    var shell = Shell()
}

struct Network {
    var downloadDiff: (URL) throws -> String = downloadDiff(for:)
}

struct Shell {
    var shell: Prompt.Shell = Prompt.bashShell
}

private func downloadDiff(for url: URL) throws -> String {
    let request = URLRequest(url: url)
    let data = try sendSynchronousRequest(request)
    return String(data: data, encoding: .utf8)!
}

private func sendSynchronousRequest(_ request: URLRequest) throws -> Data {
    var data: Data?
    var error: Error?

    let semaphore = DispatchSemaphore(value: 0)

    let dataTask = URLSession.shared.dataTask(with: request) {
        data = $0
        error = $2
        semaphore.signal()
    }
    dataTask.resume()

    _ = semaphore.wait(timeout: .distantFuture)

    if let error = error {
        throw error
    }
    return data!
}

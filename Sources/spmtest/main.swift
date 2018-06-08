import Foundation
import CompatabilityDetection

let diffUrl = ProcessInfo.processInfo.arguments[1]
let results = try compatabilityTestAdditionsForUrl(diffUrl)

for case let .incompatible(repo, error)  in results {
    print("\(repo.name) seems to be incompatible: \(error)")
}

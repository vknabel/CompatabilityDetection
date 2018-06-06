import Foundation
import CompatabilityDetection

let diffUrl = ProcessInfo.processInfo.arguments[1]
let results = compatabilityTestAdditionsForUrl(diffUrl)

for (repo, error) in results {
    fail("\(repo.name) seems to be incompatible with \(osName): \(error)")
}

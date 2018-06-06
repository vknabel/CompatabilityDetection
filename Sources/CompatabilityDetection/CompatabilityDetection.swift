import Foundation
import Overture
import PromptLine

public struct AddedRepo {
    public let name: String
    public let url: URL
}

extension AddedRepo {
    init?(name: String, rawUrl: String) {
        guard let url = URL(string: rawUrl) else {
            return nil
        }
        self.init(name: name, url: url)
    }
}

let pattern = "\\s*\\*\\s*\\[([\\d\\w\\s-]+)\\]\\(([\\d\\w-/_:.]+)\\)"
let addedRepos: (String) throws -> [AddedRepo] = pipe(
    matchingResults(of: try! regex(pattern)),
    map(dropFirst()),
    compactMap(chain(
        firstTwoElements,
        AddedRepo.init(name:rawUrl:)
    ))
)

public enum RepoTestError: Error {
    case cloneFailed
    case resolveFailed
    case buildFailed
    case missingLinuxMain
    case testBuildFailed
    case testFailed

    var description: String {
        switch self {
        case .cloneFailed:
            return  "`git clone` failed."
        case .resolveFailed:
            return "`swift package resolve` failed."
        case .buildFailed:
            return "`swift build` failed."
        case .missingLinuxMain:
            return "`Tests/LinuxMain.swift` does not exist. It can be generated by `swift test --generate-linuxmain` or using Sourcery."
        case .testBuildFailed:
            return "`swift build --build-tests` failed."
        case .testFailed:
            return "`swift test` failed."
        }
    }
}

func first<A, B>(_ a: A) -> (B) -> A {
    return { _ in a }
}

func compatibilityResults(for changes: String) -> [(AddedRepo, RepoTestError)] {
    guard let repos = try? addedRepos(changes) else {
        return []
    }
    let compatibilityTest: [(AddedRepo, PromptRunner<RepoTestError>)] = repos.map { repo in
        let clone = Prompt.mkpath("tmp")
            %& Prompt.cd("tmp")
            %& >-["git", "clone", repo.url.description, repo.name]
            %& Prompt.cd(.init(repo.name))
            %? first(RepoTestError.cloneFailed)
        let swiftenv = >-"swiftenv install"
        let resolve = >-"swift package resolve" %? first(RepoTestError.resolveFailed)
        let build = >-"swift build" %? first(RepoTestError.buildFailed)
        let testLinuxMain = >-"test -f Tests/LinuxMain.swift" %? first(RepoTestError.missingLinuxMain)
        let buildTests = >-"swift build --build-tests" %? first(RepoTestError.testBuildFailed)
        let test = >-"swift test" %? first(RepoTestError.testFailed)
        return (repo, clone %& (swiftenv %> resolve) %& build %& buildTests %& test)
    }
    defer { try? FileManager.default.removeItem(atPath: "tmp") }
    return compatibilityTest
        .map { ($0.0, $0.1(Prompt.current).error) }
        .compactMap { report in
            if let result = report.1 {
                return (report.0, result)
            } else {
                return nil
            }
    }
}

func additions(of changelog: String) -> String {
    return changelog.split(separator: "\n")
        .filter({ !$0.starts(with: "+++") && $0.starts(with: "+") })
        .joined(separator: "\n")
}

func diff(for url: URL) throws -> String? {
    let request = URLRequest(url: url)
    var response: URLResponse?
    let data = try NSURLConnection.sendSynchronousRequest(request, returning: &response)
    return String(data: data, encoding: .utf8)
}

public let compatabilityTestAdditionsForUrl = chain(
    URL.init(string:),
    unsafelyUnthrow(diff(for:)),
    additions(of:),
    compatibilityResults(for:)
)

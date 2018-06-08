import Foundation
import Overture
import PromptLine

let addedRepoPattern = "\\s*\\*\\s*\\[([\\d\\w\\s-]+)\\]\\(([\\d\\w-/_:.]+)\\)"
let addedRepos: (String) throws -> [AddedRepo] = pipe(
    matchingResults(of: try! regex(addedRepoPattern)),
    map(dropFirst()),
    compactMap(chain(
        firstTwoElements,
        AddedRepo.init(name:rawUrl:)
    ))
)

func compatibilityResults(for changes: String) -> [Summary] {
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
        .map { testCase in
            switch testCase.1(Prompt.current) {
            case .success(_):
                return Summary.compatible(testCase.0)
            case let .failure(reason):
                return .incompatible(testCase.0, reason)
            }
        }
}

func additions(of changelog: String) -> String {
    return changelog.split(separator: "\n")
        .filter({ !$0.starts(with: "+++") && $0.starts(with: "+") })
        .joined(separator: "\n")
}

public let compatabilityTestAdditionsForUrl = pipe(
    URL.init(string:),
    unsafelyUnwrapped,
    Current.network.downloadDiff,
    additions(of:),
    compatibilityResults(for:)
)

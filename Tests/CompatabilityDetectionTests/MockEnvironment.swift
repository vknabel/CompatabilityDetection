import Overture
import PromptLine
import Result
@testable import CompatabilityDetection

extension Environment {
    static let mockEmptyDiff = Environment(
        network: .mockEmptyDiff,
        shell: .mock
    )
}

extension Network {
    static let mockEmptyDiff = Network(downloadDiff: { _ in "" })
}

extension Shell {
    static let mock = Shell.init { (command) -> (Prompt) -> Result<Prompt, PromptError> in
        switch command {
        case let .inlined(cmd):
            return { .success($0) }
        case let .prepared(cmd):
            return { .success($0) }
        case let .runner(fun):
            return fun
        }
    }
}

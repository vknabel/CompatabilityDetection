
public enum RepoTestError: Error, Hashable {
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

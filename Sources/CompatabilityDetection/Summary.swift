public enum Summary: Hashable {
    case compatible(AddedRepo)
    case incompatible(AddedRepo, RepoTestError)
}

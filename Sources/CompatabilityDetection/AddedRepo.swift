import Foundation

public struct AddedRepo: Hashable {
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

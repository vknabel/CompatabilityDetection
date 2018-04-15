import Overture

func dropFirst<S: Sequence>(_ n: Int = 1) -> (S) -> S.SubSequence {
    return { s in s.dropFirst(n) }
}

func compactMap<S: Sequence, T>(_ transform: @escaping (S.Element) -> T?) -> (S) -> [T] {
    return {
        $0.compactMap(transform)
    }
}

func flatMap<A, B>(_ transform: @escaping (A) -> B?) -> (A?) -> B? {
    return {
        $0.flatMap(transform)
    }
}

func firstTwoElements<S: Collection>(of seq: S) -> (S.Element, S.Element)? {
    guard let lhs = seq.first, let rhs = seq.dropFirst().first else {
        return nil
    }
    return (lhs, rhs)
}

func unsafelyUnwrapped<A>(_ opt: A?) -> A {
    return opt!
}

func unsafelyUnthrow<A, B>(_ f: @escaping (A) throws -> B) -> (A) -> B {
    return { try! f($0) }
}

func optionalUnthrow<A, B>(_ f: @escaping (A) throws -> B) -> (A) -> B? {
    return { try? f($0) }
}

public func pipe<A, B, C>(
  _ f: @escaping (_ a: A) throws -> B,
  _ g: @escaping (_ b: B) throws -> C
  )
  -> (A) throws -> C {

    return { (a: A) throws -> C in
      try g(f(a))
    }
}

public func pipe<A, B, C, D>(
  _ f: @escaping (A) throws -> B,
  _ g: @escaping (B) throws -> C,
  _ h: @escaping (C) throws -> D
  )
  -> (A) throws -> D {

    return { (a: A) throws -> D in
      try h(g(f(a)))
    }
}

public func pipe<A, B, C, D, E>(
  _ f: @escaping (A) throws -> B,
  _ g: @escaping (B) throws -> C,
  _ h: @escaping (C) throws -> D,
  _ i: @escaping (D) throws -> E
  )
  -> (A) throws -> E {

    return { (a: A) throws -> E in
      try i(h(g(f(a))))
    }
}

public func pipe<A, B, C, D, E, F>(
  _ f: @escaping (A) throws -> B,
  _ g: @escaping (B) throws -> C,
  _ h: @escaping (C) throws -> D,
  _ i: @escaping (D) throws -> E,
  _ j: @escaping (E) throws -> F
  )
  -> (A) throws -> F {

    return { (a: A) throws -> F in
      try j(i(h(g(f(a)))))
    }
}

public func pipe<A, B, C, D, E, F, G>(
  _ f: @escaping (A) throws -> B,
  _ g: @escaping (B) throws -> C,
  _ h: @escaping (C) throws -> D,
  _ i: @escaping (D) throws -> E,
  _ j: @escaping (E) throws -> F,
  _ k: @escaping (F) throws -> G
  )
  -> (A) throws -> G {

    return { (a: A) throws -> G in
      try k(j(i(h(g(f(a))))))
    }
}

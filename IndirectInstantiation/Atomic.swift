//
//  Atomic.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-24.
//

import Foundation

@dynamicMemberLookup
final class Atomic<T>: @unchecked Sendable {
    private let lock: NSLock = .init()
    private var _value: T

    init(_ value: T) {
        self._value = value
    }

    subscript<R: Sendable>(dynamicMember keyPath: KeyPath<T, R>) -> R where T: Sendable {
        withLock { $0[keyPath: keyPath] }
    }

    /// Overwrites the isolated value with a new value.
    /// > Tip: Use the closure parameter if the new value is derived from the current value instead
    /// > of using the subscript.
    /// > For instance:
    /// > ```swift
    /// > counter.withLock { $0.count += 1 }
    /// > ```
    /// > instead of:
    /// > ```swift
    /// > counter.withLock { $0.count = counter.count + 1 }
    /// > ```
    /// > which causes a deadlock.
    @discardableResult
    func withLock<R>(_ closure: (inout T) -> R) -> R {
        lock.lock()
        defer { lock.unlock() }

        return closure(&_value)
    }
}

extension Atomic where T: Sendable {
    /// The lock-isolated value.
    var value: T {
        withLock { $0 }
    }
}

extension Atomic<Bool>: ExpressibleByBooleanLiteral {
    convenience init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

extension Atomic<Int>: ExpressibleByIntegerLiteral {
    convenience init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

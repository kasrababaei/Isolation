//
//  CounterInterface.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-23.
//

internal import Dependencies

protocol CounterInterface: TestDependencyKey {
    var count: Int { get }
    func increment()
}

final class Counter: CounterInterface {
    static var testValue: Counter {
        Counter()
    }

    private(set) var count = 0
    func increment() {
        count += 1
    }
}

private enum CounterInterfaceKey: DependencyKey {
    static let liveValue: any CounterInterface = Counter()
}

extension DependencyValues {
  var getCounter: any CounterInterface {
    get { self[CounterInterfaceKey.self] }
    set { self[CounterInterfaceKey.self] = newValue }
  }
}

//
//  CounterInterface.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-24.
//


protocol CounterInterface {
    var count: Int { get }
    func increment()
}

final class Counter: CounterInterface {
    private(set) var count = 1
    func increment() {
        count += 1
    }
}

let getCounter = bind(CounterInterface.self, lifetime: .singleton) {
    Counter()
}


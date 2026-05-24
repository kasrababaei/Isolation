//
//  Calculator.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-23.
//

internal import Dependencies

final class Calculator {
    @Dependency(\.getCounter)
    var getCounter

    func start() async {
        await withTaskGroup { group in
            for _ in 0..<1000 {
                group.addTask {
                    self.getCounter.increment()
                }
            }
        }
    }
}

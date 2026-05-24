//
//  Calculator.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-24.
//


final class Calculator {
    func start() async {
        await withTaskGroup { group in
            for _ in 0..<1000 {
                group.addTask {
                    getCounter().increment()
                }
            }
        }
    }
}

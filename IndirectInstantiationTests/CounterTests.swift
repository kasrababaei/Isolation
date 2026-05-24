//
//  CounterTests.swift
//  IsolationUITests
//
//  Created by Kasra Babaei on 2026-05-12.
//

import XCTest
@testable import IndirectInstantiation

final class CounterTests: XCTestCase {
    func testStart() async {
        let calculator = Calculator()
        await calculator.start()
        XCTAssertEqual(getCounter().count, 1000)
    }
}

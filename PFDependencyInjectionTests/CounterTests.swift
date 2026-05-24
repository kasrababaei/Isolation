//
//  CounterTests.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-23.
//


import XCTest
@testable import PFDependencyInjection
internal import Dependencies

final class CounterTests: XCTestCase {
    @Dependency(\.getCounter) private var getCounter

    func testStart() async {
        await withDependencies {
            $0.getCounter = Counter()
        } operation: {


            let calculator = Calculator()
            await calculator.start()

            XCTAssertEqual(getCounter.count, 1000)
        }
    }
}

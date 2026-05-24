//
//  IsolationTests.swift
//  IsolationTests
//
//  Created by Kasra Babaei on 2026-05-08.
//

import Testing
import Foundation
@testable import Isolation

@Suite(.serialized)
@MainActor
final class BankTests {
    private var bank: Bank!

    init() {
        setup()
    }

    private func setup() {
        DispatchQueue.main.async {
            self.bank = Bank()
        }
    }

    @Test func basics() throws {
        let id1 = bank.openAccount(initialDeposit: 100)
        let id2 = bank.openAccount(initialDeposit: 100)
        try bank.transfer(amount: 50, from: id1, to: id2)
        #expect(bank.totalDeposits == 200)
        #expect(try bank.account(for: id1).balance == 50)
        #expect(try bank.account(for: id2).balance == 150)
    }
}

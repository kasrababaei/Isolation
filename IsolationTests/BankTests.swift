//
//  IsolationTests.swift
//  IsolationTests
//
//  Created by Kasra Babaei on 2026-05-08.
//

import Testing
import Foundation
@testable import Isolation

@Suite
struct BankTests {
  @Test func basics() throws {
    let bank = Bank()
    let id1 = bank.openAccount(initialDeposit: 100)
    let id2 = bank.openAccount(initialDeposit: 100)
    try bank.transfer(amount: 50, from: id1, to: id2)
    #expect(bank.totalDeposits == 200)
    #expect(try bank.account(for: id1).balance == 50)
    #expect(try bank.account(for: id2).balance == 150)
  }

  // BankAccount.swift:29
  // | - Task 29: EXC_BAD_ACCESS (code=1, address=0x10)
  @Test func newAccountRush() async {
    let bank = Bank()
    await withTaskGroup { group in
      for _ in 1...1000 {
        group.addTask {
          bank.openAccount(initialDeposit: 100)
        }
      }
    }
    #expect(bank.totalDeposits == 100 * 1000)
  }
}

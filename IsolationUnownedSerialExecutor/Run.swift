//
//  Run.swift
//  IsolationUnownedSerialExecutor
//
//  Created by Kasra Babaei on 2026-05-31.
//

import Foundation

extension Actor {
  public func run<R, Failure: Error>(_ body: @Sendable (isolated Self) throws(Failure) -> R) throws(Failure) -> R {
    try body(self)
  }
}

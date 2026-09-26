//
//  SequenceUniquedTests.swift
//  CakeListTests
//
//  Created by Eren on 26/09/2026.
//

import Testing
@testable import CakeList

struct SequenceUniquedTests {

    @Test func removesDuplicatesKeepingFirstOccurrence() {
        #expect([3, 1, 3, 2, 1].uniqued() == [3, 1, 2])
    }

    @Test func leavesUniqueSequenceUntouched() {
        #expect([1, 2, 3].uniqued() == [1, 2, 3])
    }
}

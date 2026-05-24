//
//  FooViewModel.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-24.
//


//
//  FooViewModel.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-12.
//

import Foundation
import Synchronization

final class FooViewModel: Sendable {
    // Stored property 'chef' of 'Sendable'-conforming class 'FooViewModel' has non-Sendable
    // type 'any ChefService'
//    private let chef: ChefService

//    init(chef: ChefService = getChefService()) {
//        self.chef = chef
//    }

//    func problematicLoadFoods() -> [Food] {
//        if chef.foods.isEmpty {
//            chef.cook()
//        }
//
//        return chef.foods
//    }

    func correctLoadFoods() -> [Food] {
        if getChefService().foods.isEmpty {
            getChefService().cook()
        }

        return getChefService().foods
    }
}

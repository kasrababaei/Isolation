//
//  ChefService.swift
//  Isolation
//
//  Created by Kasra Babaei on 2026-05-24.
//


let getChefService = bind(ChefService.self) {
    Chef()
}

protocol ChefService {
    var foods: [Food] { get }
    func cook()
}

final class Chef: ChefService {
    var foods: [Food] = []
    func cook() {
        foods.append(Food(name: ["Pizza", "Omlette", "Pasta"].randomElement()!))
    }
}

struct Food {
    let name: String
}


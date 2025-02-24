//
//  JuiceMaker - FruitStore.swift
//  Created by Kiseok, 쥬봉이.
//  Copyright © yagom academy. All rights reserved.
//


// 과일 저장소 타입
class FruitStore {
    static let shared = FruitStore(initialStock: 10)
    private(set) var fruits: [Fruit: Int] = [:]
    
    private init(initialStock: Int) {
        Fruit.allCases.forEach { self.fruits[$0] = initialStock }
    }
    
    func isValidStock(of recipe: [Fruit: Int]) -> Bool {
        for (fruit, quantity) in recipe {
            guard let stock = fruits[fruit], stock >= quantity else {
                return false
            }
        }
        
        return true
    }
    
    func decreaseStock(of recipe: [Fruit: Int]) {
        recipe.forEach { (fruit, quantity) in
            guard let stock = fruits[fruit] else { return }
            fruits[fruit] = stock - quantity
        }
    }
    
    func changeStock(of fruit: Fruit, by quantity: Int) {
        fruits.updateValue(quantity, forKey: fruit)
    }
}

//
//  JuiceMaker - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

final class JuiceMakerViewController: UIViewController {
    
    @IBOutlet var labelCollection: [UILabel]! {
        didSet {
            labelCollection.sort { $0.tag < $1.tag }
        }
    }

    @IBOutlet var orderButtons: [UIButton]! {
        didSet {
            orderButtons.sort { $0.tag < $1.tag }
        }
    }
    
    private let juiceMaker: JuiceMaker = JuiceMaker()
    private let fruitStore: FruitStore = FruitStore.shared
    
    private enum Message {
        static let yes: String = "예"
        static let no: String = "아니오"
        static let check: String = "확인"
        static let success: String = " 나왔습니다! 맛있게 드세요!"
        static let outOfStock: String = "재료가 모자라요. 재고를 수정할까요?"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        Fruit.allCases.enumerated().forEach { (index, fruit) in
            labelCollection[index].text = String(fruitStore.fruits[fruit] ?? .zero)
        }
        
        orderButtons.forEach {
            $0.titleLabel?.adjustsFontForContentSizeCategory = true
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        setAccessibilityLabel()
    }
    
    private func setAccessibilityLabel() {
        labelCollection.forEach {
            let fruit = Fruit.allCases[$0.tag].rawValue
            $0.accessibilityLabel = "\(fruit) 재고 \($0.text!)개"
        }
    }
    
    @IBAction func stockChangeButtonTapped(_ sender: Any) {
        pushToStockViewController()
    }
    
    @IBAction func juiceOrderButtonTapped(_ sender: UIButton) {
        let menu = JuiceMenu.allCases[sender.tag]
        
        makeJuice(of: menu)
    }
    
    private func makeJuice(of menu: JuiceMenu) {
        do {
            try juiceMaker.makeJuice(menu: menu)
            setupUI()
            alertJuiceMakeSucess(of: menu)
        } catch JuiceMakerError.outOfStock {
            alertOutOfStock()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func alertJuiceMakeSucess(of menu: JuiceMenu) {
        let message: String = menu.rawValue + Message.success
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let check = UIAlertAction(title: Message.check, style: .default) { _ in
            UIAccessibility.post(notification: .screenChanged, argument: "과일 소모했어요.")
        }
        
        alert.addAction(check)
        self.present(alert, animated: true)
    }
    
    private func alertOutOfStock() {
        let alert = UIAlertController(title: nil, message: Message.outOfStock, preferredStyle: .alert)
        let yes = UIAlertAction(title: Message.yes, style: .destructive) { _ in
            self.pushToStockViewController()
        }
        let no = UIAlertAction(title: Message.no, style: .default)
        
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true)
    }
    
    private func pushToStockViewController() {
        guard let stockNavigationController = self.storyboard?.instantiateViewController(
            withIdentifier: "StockChangeNavigationController"
        ) as? UINavigationController else {
            return
        }
        
        guard let stockChangeViewController = stockNavigationController.topViewController
                as? StockChangeViewController else {
            return
        }
        
        stockChangeViewController.delegate = self
        self.present(stockNavigationController, animated: true) {
            UIAccessibility.post(notification: .screenChanged, argument: "화면이 바뀌었어요.")
        }
    }
}

extension JuiceMakerViewController: StockChangeViewControllerDelegate {
    func updateLabel() {
        setupUI()
    }
}

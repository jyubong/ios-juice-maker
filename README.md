# 🥤 쥬스 메이커
다양한 쥬스를 만들고 재고를 관리하는 어플

### 🛠️ 쥬봉이 혼자 추가로 refactor 하는 중입니다 🛠️

---
## 🔎 목차
- [팀원](#-팀원)
- [타임라인](#-타임라인)
- [시각화 구조](#-시각화-구조)
- [실행화면](#-실행화면)
- [트러블 슈팅](#-트러블-슈팅)
- [참고 링크](#-참고-링크)

---
## 👥 팀원
|Kiseok🐶|쥬봉이🐱|
|---|---|
|<img src="https://cdn.discordapp.com/attachments/1146018665737752590/1152107904191701013/IMG_1011.png" width="200" height="200">|<img src="https://avatars.githubusercontent.com/u/126065608?v=4" width="200" height="200">|
|[GitHub](https://github.com/carti1108)|[GitHub](https://github.com/jyubong)|

## 📅 타임라인
### 👥 팀프로젝트
|날짜|내용|
|------|---|
|23.09.11|- 공식문서 공부<br> - 그라운드 룰 정하기|
|23.09.12|- juicemaker, fruitstore, fruit, juicemenu  타입  정의<br> - 쥬스 만드는 메소드, 과일 소모시키는 메소드 구현 <br>- Step1 PR|
|23.09.15|- 과일 소모시키는 메소드 기능 분리 <br> - 레시피 함수 -> 주스메뉴 열거형에 연산프로퍼티로 수정 <br>- ReadMe 작성|
|23.09.18|- 재고 부족 에러 정의 및 처리 <br> - 화면 전환 구현(네비게이션 방식) <br> - 쥬스 생성 완료 또는 재고 부족 alert 구현|
|23.09.19|- 화면 전환 방식 네비게이션 방식에서 모달로 수정 <br> - Step2 PR|
|23.09.20|- 컨벤션 수정<br> - class에 final 키워드 추가<br> - 메세지 namespace 추가|
|23.09.21|- 오토레이아웃 설정 <br> - stepper(-, +) 클릭시 화면 및 재고 수정 메서드 구현 <br> - Step3 PR|
|23.09.22|- 재고 수정 메소드 수정<br> - ViewController의 IBOutlet을 collection으로 변경<br> - UI나타내는 메서드 수정, stepper 탭했을 때 메서드 수정|
|23.09.25|- 코드 리팩터링|
|23.09.26|- delegate pattern 구현|
|23.09.27|- UML 시각화 구조 작성<br> - ReadMe 최종 작성|

### 👤 개별 프로젝트
|날짜|내용|
|------|---|
|23.11.09|- dynamic type 적용 <br> - accessibilityLabel 수정|

## 👀 시각화 구조
### 1. Sequence Diagram
<img width="500" alt="스크린샷 2023-09-27 오후 2 04 42" src="https://github.com/jyubong/ios-juice-maker/assets/126065608/5cda7caf-9027-48b2-a31c-20bc3c146391">

### 2. Class Diagram
<img width="716" alt="스크린샷 2023-09-27 오후 2 05 08" src="https://github.com/jyubong/ios-juice-maker/assets/126065608/7f8ddec0-00fb-403c-b56d-a17d1d3c6ae4">

## 💻 실행화면
|재고 수정 버튼 클릭|주문 성공|
|---|---|
|![재고수정 버튼](https://github.com/jyubong/ios-juice-maker/assets/126065608/875ea584-5470-4148-b12e-ae84ed9d429f)|![주문 성공](https://github.com/jyubong/ios-juice-maker/assets/126065608/49901382-8994-4907-8bc1-3d7723d8402a)|

|주문 실패(재고 수정 예)|주문 실패(재고 수정 아니오)|
|---|---|
|![재고수정 예](https://github.com/jyubong/ios-juice-maker/assets/126065608/44c14c91-dcc4-4e08-90b3-dc692ce757ff)|![재고 부족 아니오](https://github.com/jyubong/ios-juice-maker/assets/126065608/6ce3ee48-eee4-4c45-ae70-1f9a0d7f9f0c)|



## 🔥 트러블 슈팅
1. FruitStore의 decreaseStock메서드는 과일 재고를 확인하고 문제가 없으면 과일 수량을 낮추는 함수. 과일을 2개 소비해야할때 두 과일의 재고를 먼저 확인하고 수량을 낮추어주어야하는데, 이를 구현해보니 `for-loop 2개`를 사용하여 코드가 지저분해지는 문제 발생
-> 첫번째 for-in 루프가 isInvalidStock 함수와 기능이 비슷해 isInvalidStock으로 옮겨줌.

  - 수정 전 코드
```swift
func decreaseStock(fruits: [Fruit : Int]) -> Bool {
    for (fruit, quantity) in fruits {
        guard checkStock(fruit: fruit, quantity: quantity) else {
            return false
        }
    }

    for (fruit, quantity) in fruits {
        guard let stock = fruits[fruit] else {
            return false
        }
        self.fruits[fruit] = stock - quantity
    }

    return true
}
```

  - **수정 후 코드**
```swift
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
```

<br>

2. JuiceMakerViewController에서 StockChangeViewController로 바로 modal 연결을 했더니 `navigation bar가 안나타나는 문제` 발생
-> StockChangeViewController에 navigationController를 연결해준 후 `modal을 navigationController를 호출하는 방식`으로 변경

``` swift
guard let stockNavigationController = self.storyboard?.instantiateViewController(
    withIdentifier: "StockChangeNavigationController"
) as? UINavigationController else {
    return
}

stockNavigationController.modalPresentationStyle = .fullScreen
self.present(stockNavigationController, animated: true)

```

<br>

3. `stepper 사용 시` 아래와 같은 문제점들이 발생
    - stepper 초기값이 0으로 설정 -> stepper별 상이한 초기값을 어떻게 설정할지
    - label 값이 0보다 더 적어지는 문제
    - stepper 값이 (-)가 안되는 문제
    -> 처음에 각 stepper의 초기값을 fruitStore의 재고로 설정하는 것으로 해결
``` swift
// stepper 초기값 설정
private func setStepperValue() {
    Fruit.allCases.enumerated().forEach { (index, fruit) in
        stepperCollection[index].value = Double(fruitStore.fruits[fruit] ?? .zero)
    }
}

// label 값 설정
private func setupUI() {
    labelCollection.enumerated().forEach { (index, label) in
        label.text = String(changeStepperValueToInt(at: index))
    }
}

// stepper 클릭시 label 변경
@IBAction func stepperTapped(_ sender: UIStepper) {
    let index = sender.tag
    labelCollection[index].text = String(changeStepperValueToInt(at: index))
}
```

<br>

4. `IBOutlet Collection` 사용 시 각 요소를 어떻게 구분하고 순서를 어떻게 확인해야할지 고민
-> didSet을 활용하여 `각각의 tag값으로 순서를 정해줌`
``` swift
@IBOutlet var stepperCollection: [UIStepper]! {
    didSet {
        stepperCollection.sort { $0.tag < $1.tag }
    }
}
```

<br>

5. 재고수정 후 `delegate패턴`으로 수정된 재고를 UI에 반영하기위해 JuiceMakerViewController에서 StockChangeViewController를 호출하려고 했으나 동작 안함
-> NavigationController를 새로 만들고 추가로 또 StockChangeViewController를 새로 만들다보니 완전히 다른 ViewController가 되어 delegate가 호출이 안됨
-> NavigationController호출 후 그 Controller의 topViewController를 불러오는 방법으로 StockChangeViewController 호출
  - 동작 안된 코드 
``` swift
private func pushToStockViewController() {
    guard let stockNavigationController = self.storyboard?.instantiateViewController(
        withIdentifier: "StockChangeNavigationController"
    ) as? UINavigationController else {
        return
    }

    guard let stockChangeViewController = self.storyboard?.instantiateViewController(
        withIdentifier: "StockChangeViewController"
    ) as? StockChangeViewController else {
        return
    }

    stockChangeViewController.delegate = self
    self.present(stockNavigationController, animated: true)
}
```

  - 수정 코드
``` swift
private func pushToStockViewController() {
// (생략 부분 위와동일)

    guard let stockChangeViewController = stockNavigationController.topViewController
            as? StockChangeViewController else {
        return
    }

    stockChangeViewController.delegate = self
    self.present(stockNavigationController, animated: true)
}
```


## 📚 참고 링크
[애플 공식문서 Hashable](https://developer.apple.com/documentation/swift/hashable)   
[애플 공식문서 CustomStringConvertible](https://developer.apple.com/documentation/swift/customstringconvertible)   
[애플 공식문서 UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller)   
[애플 공식문서 forEach(_:)](https://developer.apple.com/documentation/swift/array/foreach(_:))   
[애플 공식문서 Protocol](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/)   
[애플 공식문서 UIAccessibility](https://developer.apple.com/documentation/objectivec/nsobject/uiaccessibility)

---
### 팀 회고
<details>
<summary>우리팀이 잘한 점</summary>
    
- 핵심경험, 요구사항 반영 노력함
- 피드백받은 사항에 대해 공부하고 적절히 개선함
</details>

<details>
<summary>우리팀이 개선할 점</summary>

- 배려가 있는 모습은 좋으나 자기 주장과 자신감이 다소 부족함
</details>

<details>
<summary>서로에게 피드백</summary>

- Kiseok: 구현 능력이 너무 뛰어나셔서 혼자 해결하지 못하는 부분들을 어려움없이 해결해 주시고 잘 알려주셨습니다.
- 쥬봉이 : 제가 생각하지 못한 부분을 Kiseok이 많이 알고 있어 도움이 많이되고 배울 수 있었습니다. 덕분에 큰 트러블없이 프로젝트를 진행할 수 있었습니다.
</details>

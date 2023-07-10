//
//  ViewController.swift
//  Swfit59
//
//  Created by chengbin on 2023/6/27.
//

import UIKit
import CryptoSwift
import RxSwift
import RxCocoa

class ViewController: UIViewController,Storyboardable {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    

    private let viewModel: SampleViewModel = SampleViewModel()
    private var eventsDataSource: [Event] = []
    private let disposeBag = DisposeBag()
    
    
    static var storyboardName: String {
        return "Main"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let success = ServerResponse.result("6:00 am", "8:09 pm")
//        let failure = ServerResponse.failure("Out of cheese.")
        switch success {
        case let .result(sunrise, sunset):
            print("Sunrise is at \(sunrise) and sunset is \(sunset)")
        case let .failure(message):
            print("Failure... \(message)")
        }
        let hearts = Suit.heats
        let heartsDescription = hearts.simpleDescription()
        print(heartsDescription)
        let five = ArithmeticExpress.number(5)
        let four = ArithmeticExpress.number(4)
        let sum = ArithmeticExpress.add(five, four)
        let product = ArithmeticExpress.multi(sum, ArithmeticExpress.number(2))
        print(evaluate(product))

        var names = ["a", "b", "c"]
        names.sort { $0 > $1 }
        
        print(names)
        let digitNames = [
            0: "Zero", 1: "One", 2: "Two", 3: "Three", 4: "Four",
            5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
        ]
        let numbers = [16, 58, 510]
        var strings = numbers.map { number -> String in
            var number = number
            var output = ""
            repeat {
                output = digitNames[number % 10]! + output
                number /= 10
            } while number > 0
            return output
        }
        print(strings)

        serve(customer: names.remove(at: 0))

        let result = strings.remove(at: 0)
        print(result)

        let res = SomeStruct(x: 200) + SomeStruct(x: 300)
        print(res)
        var somStr = SomeStructure()
        somStr.somNum = 66
        print(somStr.$somNum)
        print(UIApplication.shared.topViewController!)

        /// https://dev.classmethod.jp/articles/swift_keypath1/
        /// https://github.com/apple/swift-evolution/blob/main/proposals/0249-key-path-literal-function-expressions.md
        /// keyPath    \.
        struct Cat {
            var name: String
            var age: Int
            func meow() -> String {
                return "meow"
            }
        }
        _ = Cat(name: "mi-san", age: 10)

        let _: PartialKeyPath<Cat> = \.age
        let _: KeyPath<Cat, String> = \.name
        let _ = \Cat.age

        let cats = [Cat]()
        _ = cats.map {
            $0[keyPath: \Cat.name]
        }

        let f: (Cat) -> String = { kp in { root in root[keyPath: kp] } }(\Cat.name)
        _ = cats.map(f)
        // ^ prefix operators
        _ = cats.map(^\.name)
        _ = cats.map(\.age)
        _ = RxLab()
        
        let json = #" {"first_name":"Tom", "age":null, "additionalInfo":"123", "address":"abc"} "#
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let person = try decoder.decode(Man.self, from: json.data(using: .utf8)!)
            print(person)
        }catch {
            
        }
  
        
        let json1 = """
        {
            "phone": "12",
            "age": 12
        }
        """.data(using: .utf8)!
        
        do {
            let result = try JSONDecoder().decode(Human.self, from: json1)
            print(result)
        }catch {}
        UIView.animate(withDuration: 5, animations: self.view.backgroundColor = .blue)
    
        let xs = Observable.deferred { () -> Observable in
                       print("Performing work ...")
                       return Observable.just(Date().timeIntervalSince1970)
                   }
                   .share(replay: 1, scope: .forever)

        _ = xs.subscribe(onNext: { x in print("next \(x)") }, onCompleted: { print("completedn") })
               _ = xs.subscribe(onNext: {x in print("next \(x)") }, onCompleted: { print("completen") })
               _ = xs.subscribe(onNext: {x in print("next \(x)") }, onCompleted: { print("completen") })
 
        
        self.textField.rx.text.orEmpty.filter { x in
            x.count >= 1
        }.debounce(RxTimeInterval.milliseconds(3), scheduler: MainScheduler()).asDriver(onErrorDriveWith: Driver.empty()).drive(viewModel.searchWord).disposed(by: disposeBag)
        
        viewModel.events.subscribe {[weak self] events in
            guard let self = self else {return}
            if let events = events {
                self.eventsDataSource = events.events ?? []
                self.tableView.reloadData()
            }
        }.disposed(by: disposeBag)
    
        let db = viewModel.events.compactMap { $0?.events}
        db.observe(on: MainScheduler()).bind(to: tableView.rx.items(cellIdentifier: SampleCell.identifier,cellType: SampleCell.self)){
          (_,element,cell) in
            var c = cell.defaultContentConfiguration()
            c.text = element.title
            cell.contentConfiguration = c
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        
        let keyboard = MechanicalKeyboard(keySwitch: .tactile, name: "a", numberOfKeys: 67)
        print(keyboard.numbers)
        print(countDown())
    }
    @StringBuilder
    func getStrings() -> String {
        "喜洋洋"
        "美羊羊"
        "灰太狼"
    }
    
    @ComplexStringBuilder
    func countDown() -> String {
       for i in (0...10).reversed() {
            "\(i)..."
        }
        "Lift off!"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(UIApplication.shared.topViewController!)
    }

    func balance(_ x: inout Int, _ y: inout Int) {
        let sum = x + y
        x = sum / 2
        y = sum - x
    }

    func evaluate(_ e: ArithmeticExpress) -> Int {
        switch e {
        case let .number(value):
            return value
        case let .add(left, right):
            return evaluate(left) + evaluate(right)
        case let .multi(left, right):
            return evaluate(left) * evaluate(right)
        }
    }
}

enum ServerResponse {
    case result(String, String)
    case failure(String)
}

enum Suit: String, CaseIterable {
    case spades, heats, diamonds, clubs
    func simpleDescription() -> String {
        switch self {
        case .spades:
            return "spades"
        case .heats:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
}

indirect enum ArithmeticExpress {
    case number(Int)
    case add(ArithmeticExpress, ArithmeticExpress)
    case multi(ArithmeticExpress, ArithmeticExpress)
}

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

struct SomeStruct {
    var x = 10
    mutating func doSomething() {
        someFunctionWithNonescapingClosure {
            x = 100
        }
    }
}

extension SomeStruct {
    static func +(lhs: SomeStruct, rhs: SomeStruct) -> Int {
        return lhs.x + rhs.x
    }
}

func serve(customer provider: @autoclosure () -> String) {
    print("Now serving \(provider())!")
}

@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int

    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, maximum) }
    }

    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }

    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }

    init() {
        maximum = 12
        number = 0
    }
}

struct ZeroRectangle {
    @SmallNumber var height: Int = 0
    @SmallNumber(maximum: 10) var width: Int = 1
}

@propertyWrapper
struct SmallNum {
    private var number: Int
    private(set) var projectedValue: Bool
    var wrappedValue: Int {
        get {
            return number
        }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }

    init() {
        number = 0
        projectedValue = false
    }
    init(wrappedValue: Int) {
        number = wrappedValue
        projectedValue = false
    }
}

struct SomeStructure {
    @SmallNum var somNum: Int = 10
}

extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100 }
    var mm: Double { return self / 1_000.0 }
}

extension Int {
    mutating func square() {
        self = self * self
    }

    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0 ..< digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }

    enum Kind {
        case negative, zero, positive
    }

    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

protocol FullyNamed {
    var fullName: String { get set }
}

struct Person: FullyNamed {
    var prefix: String?
    var name: String
    init(prefix: String? = nil, name: String) {
        self.prefix = prefix
        self.name = name
    }

    var fullName: String {
        get {
            return (prefix != nil ? prefix! + " " : "") + name
        }
        set {
            name = newValue
        }
    }
}

protocol Toggleable {
    mutating func toggle()
}

enum OnOffSwitch: Toggleable {
    case off, on
    mutating func toggle() {
        switch self {
        case .on:
            self = .off
        case .off:
            self = .on
        }
    }
}

protocol Container {
    associatedtype Item
    var count: Int {
        get
    }
    subscript(i: Int) -> Item { get }
}

extension Array: Container {}

func make<T>(item: T) -> any Container {
    return [item]
}

protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        var result: [String] = []
        for length in 1 ... size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}

struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}

struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = [String](repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}

/// - @see https://swiftsenpai.com/swift/dynamic-dispatch-with-generic-protocols/
/// - @see https://juejin.cn/post/7119062263406788616
protocol Vehicle {
    var name: String { get }
    associatedtype FuelType: Fuel
    func fillGasTank(with fuel: FuelType)
    func startEngin()
}

protocol Fuel {
    associatedtype FuelType where FuelType == Self
    static func purchase() -> FuelType
}

struct Gasoline: Fuel {
    let name = "gasoline"
    static func purchase() -> Gasoline {
        print("Purchase Gasoline from gas station")
        return Gasoline()
    }
}

struct Diesel: Fuel {
    let name = "diesel"
    static func purchase() -> Diesel {
        print("Purchase Diesel from gas station")
        return Diesel()
    }
}

struct Car: Vehicle {
    let name: String = "car"
//    typealias FuelType = Gasoline
    func fillGasTank(with fuel: Gasoline) {
        print("Fill (name) with (fuel.name)")
    }

    func startEngin() {}
}

struct Bus: Vehicle {
    let name: String = "bus"
//    typealias FuelType = Diesel
    func fillGasTank(with fuel: Diesel) {
        print("Fill (name) with (fuel.name)")
    }

    func startEngin() {}
}

func fillAllGasTank(for vehicles: [any Vehicle]) {
    for vehicle in vehicles {
        fillGasTank(for: vehicle)
        vehicle.startEngin()
    }
}

func fillGasTank(for vehicle: some Vehicle) {
    // type(of:) 查找动态类型，并返回该元类型的实例
    let vehicleType = type(of: vehicle)
    let fuel = vehicleType.FuelType.purchase()
    vehicle.fillGasTank(with: fuel)
}

func wash<T: Vehicle>(_ vehicle: T) {}

func wash2<T>(_ vehicle: T) where T: Vehicle {}

func wash3(_ vehicle: some Vehicle) {}

struct Man: Codable {
    var firstName: String
    @DecodableDefault.Zero var age: Int = 1
    var additionalInfo: String?
    var address: String?
    
}

struct Human: Kodable {
    init() {

    }
    
    @Coding()  var phone: String = "123456"
    @Coding()  var age: Int = 0
    
}

extension UIView {
   class func animate(withDuration duration: TimeInterval, animations: @escaping @autoclosure () -> Void) {
        UIView.animate(withDuration: duration, animations: animations)
    }
}

class ExView: UIView {
    var text: String
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension Reactive where Base: ExView {
    var text: Binder<String> {
      return Binder(base) { t, title in
            t.text = title
        }
    }
}

enum KeySwitch {
    case liner
    case tactile
    case clicky
}

@dynamicMemberLookup
class MechanicalKeyboard {
    let keySwitch: KeySwitch
    let name: String
    let numberOfKeys: Int
    
    init(keySwitch: KeySwitch, name: String, numberOfKeys: Int) {
        self.keySwitch = keySwitch
        self.name = name
        self.numberOfKeys = numberOfKeys
    }
    
    subscript(dynamicMember key: String) -> Any{
        switch key {
        case "siwtch":
            return keySwitch
        case "type":
            return "This keyboard is \(name)"
        case "numbers":
            return numberOfKeys
        default:
            return ""
        }
    }
}


@resultBuilder
struct StringBuilder {
    static func buildBlock(_ parts: String...) -> String {
        parts.map { s in
            "⭐️" + s + "🌈"
        }.joined(separator: "  ")
    }
}

@resultBuilder
struct ComplexStringBuilder {
    static func buildBlock(_ parts: String...) -> String {
        parts.joined(separator: "\n")
    }
    
    static func buildArray(_ components: [String]) -> String {
        components.joined(separator: "\n")
    }
    
    static func buildEither(first component: String) -> String {
        return component
    }
    
    static func buildEither(second component: String) -> String {
        return component
    }
}

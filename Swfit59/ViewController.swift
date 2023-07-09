//
//  ViewController.swift
//  Swfit59
//
//  Created by chengbin on 2023/6/27.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {
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
        _ = cats.map(^\.name)
        _ = cats.map(\.age)
        _ = RxLab()
 
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
}

struct SomeStructure {
    @SmallNum var somNum: Int
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

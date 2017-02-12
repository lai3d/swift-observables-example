//: Playground - noun: a place where people can play

protocol ObservableProtocol {
    associatedtype T
    var value: T { get set }
    
    typealias ObserverBlock = (_ newValue: T, _ oldValue: T) -> ()
    
//    func subscribe(observer: AnyObject, block: (_ newValue: T, _ oldValue: T) -> ())
    func subscribe(observer: AnyObject, block: @escaping ObserverBlock)

    func unsubscribe(observer: AnyObject)
}

public final class Observable<T>: ObservableProtocol {
    
    typealias ObserverBlock = (_ newValue: T, _ oldValue: T) -> ()
    typealias ObserversEntry = (observer: AnyObject, block: ObserverBlock)
    
    private var observers: Array<ObserversEntry>
    
    init(_ value: T) {
        self.value = value
        observers = []
    }
    
    var value: T {
        didSet {
            observers.forEach { (entry: ObserversEntry) in
                let (_, block) = entry
                block(value, oldValue)
            }
        }
    }
    
    func subscribe(observer: AnyObject, block: @escaping ObserverBlock) {
        let entry: ObserversEntry = (observer: observer, block: block)
        observers.append(entry)
    }
    
    func unsubscribe(observer: AnyObject) {
        let filtered = observers.filter { entry in
            let (owner, _) = entry
            return owner !== observer
        }
        
        observers = filtered
    }
    
}

func <<<T>(observable: Observable<T>, value: T) {
    observable.value = value
}

/*: ## Example */
class ExampleStruct {
    var v: Int
    var obs: Observable<Int>
    
    init() {
        let initial = 3
        v = initial
        obs = Observable(initial)
    }
    
    func demo() {
        obs.subscribe(observer: self) { (newValue, oldValue) in
            self.v = newValue
        }
        
        obs << 4
        print(v)
    }
}

ExampleStruct().demo()  // Check the right side pane for values!





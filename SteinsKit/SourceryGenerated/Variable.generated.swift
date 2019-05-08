// Generated using Sourcery 0.16.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT




public final class Variable<Value> {

    private var value: Value {
        didSet { runObservations() }
    }

    private var observations: Set<Observation<Value>> = []

    private var children: Set<VariableNodeContainer> = []

    public init(_ value: Value) {
        self.value = value
    }



}

extension Variable {

    private func runObservations() {

        let newValue = value

        for child in children {
            if child.isObservationsEmpty {
                children.remove(child)
            }
        }

        for observation in observations {
            if observation.canRunObservingAction {
                observation.run(with: newValue)

            } else {
                observations.remove(observation)
            }

        }

    }

}

extension Variable {

    private func addObserver <Observer: AnyObject> (_ observer: Observer,
                                                    disposer: AnyObject?,
                                                    executionMethod: ExecutionMethod,
                                                    handler: @escaping (Observer, Value) -> Void) {

        guard let disposer = disposer else { return }

        let observation = Observation(observer: observer, disposer: disposer, method: executionMethod, observingAction: handler)

        observations.insert(observation)

        let currentValue = value
        handler(observer, currentValue)

    }

}

extension Variable {

    public var currentValue: Value {
        return value
    }

    public func accept(_ newValue: Value) {
        value = newValue
    }

    public func accept(_ calculation: (Value) -> Value) {
        let newValue = calculation(currentValue)
        accept(newValue)
    }

}

extension Variable {

    public func asAnyObservable() -> AnyObservable<Value> {
        return AnyObservable(self)
    }

}

extension Variable: VariableNode {

    var isObservationsEmpty: Bool {
        return observations.isEmpty
    }

}

extension Variable: Observable {

    public func runWithLatestValue (_ execution: (Value) -> Void) {

        let value = currentValue
        execution(value)

    }

    public func map <NewValue> (_ transform: @escaping (Value) -> NewValue) -> AnyObservable<NewValue> {


        let transformedValue = transform(value)
        let transformedVariable = Variable<NewValue>(transformedValue)


        addObserver(transformedVariable, disposer: transformedVariable, executionMethod: .directly, handler: { $0.accept(transform($1)) })

        let child = VariableNodeContainer(node: transformedVariable)
        children.insert(child)

        let wrappedVariable = AnyObservable(transformedVariable)
        return wrappedVariable

    }

    public func beObserved <Observer: AnyObject> (by observer: Observer, _ method: ExecutionMethod, disposer: AnyObject?, onChanged handler: @escaping (Observer, Value) -> Void) {

        addObserver(observer, disposer: disposer, executionMethod: method, handler: handler)

    }

}


public final class LazyVariable<Value> {

    private var value: Lazy<Value> {
        didSet { runObservations() }
    }

    private var observations: Set<Observation<Value>> = []

    private var children: Set<VariableNodeContainer> = []

    public init(_ value: Value) {
        self.value = .initialized(value)
    }

    public init() {
        self.value = .uninitialized
    }

    init(lazyValue: Lazy<Value>) {
        self.value = lazyValue
    }

}

extension LazyVariable {

    private func runObservations() {

        guard let newValue = value.value else { return }

        for child in children {
            if child.isObservationsEmpty {
                children.remove(child)
            }
        }

        for observation in observations {
            if observation.canRunObservingAction {
                observation.run(with: newValue)

            } else {
                observations.remove(observation)
            }

        }

    }

}

extension LazyVariable {

    private func addObserver <Observer: AnyObject> (_ observer: Observer,
                                                    disposer: AnyObject?,
                                                    executionMethod: ExecutionMethod,
                                                    handler: @escaping (Observer, Value) -> Void) {

        guard let disposer = disposer else { return }

        let observation = Observation(observer: observer, disposer: disposer, method: executionMethod, observingAction: handler)

        observations.insert(observation)

        guard let currentValue = value.value else { return }
        handler(observer, currentValue)

    }

}

extension LazyVariable {

    public var currentValue: Value? {
        return value.value
    }

    public func accept(_ newValue: Value) {
        value = .initialized(newValue)
    }

    public func accept(_ calculation: (Value?) -> Value) {
        let newValue = calculation(currentValue)
        accept(newValue)
    }

}

extension LazyVariable {

    public func asAnyObservable() -> AnyObservable<Value> {
        return AnyObservable(self)
    }

}

extension LazyVariable: VariableNode {

    var isObservationsEmpty: Bool {
        return observations.isEmpty
    }

}

extension LazyVariable: Observable {

    public func runWithLatestValue (_ execution: (Value) -> Void) {

        guard let value = currentValue else { return }
        execution(value)

    }

    public func map <NewValue> (_ transform: @escaping (Value) -> NewValue) -> AnyObservable<NewValue> {


        let transformedValue = value.transformed(by: transform)
        let transformedVariable = LazyVariable<NewValue>(lazyValue: transformedValue)


        addObserver(transformedVariable, disposer: transformedVariable, executionMethod: .directly, handler: { $0.accept(transform($1)) })

        let child = VariableNodeContainer(node: transformedVariable)
        children.insert(child)

        let wrappedVariable = AnyObservable(transformedVariable)
        return wrappedVariable

    }

    public func beObserved <Observer: AnyObject> (by observer: Observer, _ method: ExecutionMethod, disposer: AnyObject?, onChanged handler: @escaping (Observer, Value) -> Void) {

        addObserver(observer, disposer: disposer, executionMethod: method, handler: handler)

    }

}


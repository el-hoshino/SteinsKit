//: A UIKit based Playground for presenting user interface
import UIKit
import PlaygroundSupport
import SteinsKit

// MARK: - Model
final class Model {
    
    private var _count: Variable<Int> = .init(0)
    
    private func _countUp() {
        _count.accept({ $0 + 1 })
    }
    
}

extension Model: ModelProtocol {
    
    var count: AnyObservable<Int> {
        return _count.asAnyObservable()
    }
    
    func countUp() {
        _countUp()
    }
    
}
// MARK: Model End -

// MARK: - View Controller
protocol ModelProtocol: AnyObject {
    var count: AnyObservable<Int> { get }
    func countUp()
}

final class ViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 25, y: 200, width: 320, height: 100)
        label.numberOfLines = 0
        return label
    }()
    
    var model: ModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(label)
        startObservation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        addCount()
    }
    
    private func startObservation() {
        model.count
            .map({ "Welcome!\nWe have \($0) visitors visited\nour playground!" })
            .beObserved(by: label, .asyncOnMain, onChanged: { $0.text = $1 })
    }
    
    private func addCount() {
        model.countUp()
    }
    
}
// MARK: View Controller End -

// MARK: - Main
let vc = ViewController()
let model = Model()
vc.model = model

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = vc

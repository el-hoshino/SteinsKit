//: A UIKit based Playground for presenting user interface
import UIKit
import PlaygroundSupport
import SteinsKit

protocol ModelProtocol: AnyObject {
    var title: AnyObservable<String> { get }
}
final class MyViewController : UIViewController {
    var model: ModelProtocol!
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect(x: 25, y: 200, width: 320, height: 60)
        label.numberOfLines = 0
        
        view.addSubview(label)
        self.view = view
        
        model.title.beObserved(by: label, onChanged: { $0.text = $1 })
    }
}

final class Model {
    private var _counter = 0
    private let _title: LazyVariable<String> = .init()
    func countUp() {
        _counter += 1
        _title.accept("Welcome!\nWe have \(_counter) people visited our playground!")
    }    
}
extension Model: ModelProtocol {
    var title: AnyObservable<String> {
        return _title.asAnyObservable()
    }
}

let vc = MyViewController()
let model = Model()
vc.model = model

PlaygroundPage.current.liveView = vc

model.countUp()

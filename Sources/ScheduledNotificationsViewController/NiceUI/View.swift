import UIKit

class View: UIView {
    init() {
        super.init(frame: .zero)
        self.didLoad()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func didLoad() {
        // initialize your view here
    }
}

extension UIView {
    func addSubview<Subview: UIView>(_ view: Subview, configure: (Subview) -> Void) {
        addSubview(view)
        configure(view)
    }
}

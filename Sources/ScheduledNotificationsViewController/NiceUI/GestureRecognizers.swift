//
//  File.swift
//  
//
//  Created by Oleg Dreyman on 1/22/21.
//

import UIKit

final class TapGestureRecognizer: UITapGestureRecognizer {
    
    @Delegated1 var action: (TapGestureRecognizer) -> Void
    
    init() {
        super.init(target: nil, action: nil)
        super.addTarget(self, action: #selector(didDetect))
    }
    
    @available(*, deprecated, renamed: "TapGestureRecognizer()")
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    @objc
    private func didDetect() {
        self.action(self)
    }
}

extension TapGestureRecognizer: Delegating1 {
    static var keyPathForDelegatedFunction: KeyPath<TapGestureRecognizer, Delegated1<TapGestureRecognizer>> {
        return \._action
    }
}

final class PinchGestureRecognizer: UIPinchGestureRecognizer {
    
    @Delegated1 var action: (PinchGestureRecognizer) -> Void
    
    init() {
        super.init(target: nil, action: nil)
        super.addTarget(self, action: #selector(didDetect))
    }
    
    @available(*, deprecated, renamed: "PinchGestureRecognizer()")
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    @objc
    private func didDetect() {
        self.action(self)
    }
}

extension PinchGestureRecognizer: Delegating1 {
    static var keyPathForDelegatedFunction: KeyPath<PinchGestureRecognizer, Delegated1<PinchGestureRecognizer>> {
        return \._action
    }
}

final class RotationGestureRecognizer: UIRotationGestureRecognizer {
    
    @Delegated1 var action: (RotationGestureRecognizer) -> Void
    
    init() {
        super.init(target: nil, action: nil)
        super.addTarget(self, action: #selector(didDetect))
    }
    
    @available(*, deprecated, renamed: "RotationGestureRecognizer()")
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    @objc
    private func didDetect() {
        self.action(self)
    }
}

extension RotationGestureRecognizer: Delegating1 {
    static var keyPathForDelegatedFunction: KeyPath<RotationGestureRecognizer, Delegated1<RotationGestureRecognizer>> {
        return \._action
    }
}

final class SwipeGestureRecognizer: UISwipeGestureRecognizer {
    
    @Delegated1 var action: (SwipeGestureRecognizer) -> Void
    
    init() {
        super.init(target: nil, action: nil)
        super.addTarget(self, action: #selector(didDetect))
    }
    
    @available(*, deprecated, renamed: "SwipeGestureRecognizer()")
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    @objc
    private func didDetect() {
        self.action(self)
    }
}

extension SwipeGestureRecognizer: Delegating1 {
    static var keyPathForDelegatedFunction: KeyPath<SwipeGestureRecognizer, Delegated1<SwipeGestureRecognizer>> {
        return \._action
    }
}

final class PanGestureRecognizer: UIPanGestureRecognizer {
    
    @Delegated1 var action: (PanGestureRecognizer) -> Void
    
    init() {
        super.init(target: nil, action: nil)
        super.addTarget(self, action: #selector(didDetect))
    }
    
    @available(*, deprecated, renamed: "PanGestureRecognizer()")
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    @objc
    private func didDetect() {
        self.action(self)
    }
}

extension PanGestureRecognizer: Delegating1 {
    static var keyPathForDelegatedFunction: KeyPath<PanGestureRecognizer, Delegated1<PanGestureRecognizer>> {
        return \._action
    }
}

final class ScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer {
    
    @Delegated1 var action: (ScreenEdgePanGestureRecognizer) -> Void
    
    init() {
        super.init(target: nil, action: nil)
        super.addTarget(self, action: #selector(didDetect))
    }
    
    @available(*, deprecated, renamed: "ScreenEdgePanGestureRecognizer()")
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    @objc
    private func didDetect() {
        self.action(self)
    }
}

extension ScreenEdgePanGestureRecognizer: Delegating1 {
    static var keyPathForDelegatedFunction: KeyPath<ScreenEdgePanGestureRecognizer, Delegated1<ScreenEdgePanGestureRecognizer>> {
        return \._action
    }
}

final class LongPressGestureRecognizer: UILongPressGestureRecognizer {
    
    @Delegated1 var action: (LongPressGestureRecognizer) -> Void
    
    init() {
        super.init(target: nil, action: nil)
        super.addTarget(self, action: #selector(didDetect))
    }
    
    @available(*, deprecated, renamed: "LongPressGestureRecognizer()")
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    @objc
    private func didDetect() {
        self.action(self)
    }
}

extension LongPressGestureRecognizer: Delegating1 {
    static var keyPathForDelegatedFunction: KeyPath<LongPressGestureRecognizer, Delegated1<LongPressGestureRecognizer>> {
        return \._action
    }
}

@available(iOS 13.0, *)
final class HoverGestureRecognizer: UIHoverGestureRecognizer {
    
    @Delegated1 var action: (HoverGestureRecognizer) -> Void
    
    init() {
        super.init(target: nil, action: nil)
        super.addTarget(self, action: #selector(didDetect))
    }
    
    @available(*, deprecated, renamed: "HoverGestureRecognizer()")
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    @objc
    private func didDetect() {
        self.action(self)
    }
}

@available(iOS 13.0, *)
extension HoverGestureRecognizer: Delegating1 {
    static var keyPathForDelegatedFunction: KeyPath<HoverGestureRecognizer, Delegated1<HoverGestureRecognizer>> {
        return \._action
    }
}

protocol Delegating1 {
    associatedtype DelegatedInput
    
    static var keyPathForDelegatedFunction: KeyPath<Self, Delegated1<DelegatedInput>> { get }
}

extension Delegating1 {
    @discardableResult
    func delegate<Target: AnyObject>(
        to target: Target,
        with callback: @escaping (Target, DelegatedInput) -> Void
    ) -> Self {
        self[keyPath: Self.keyPathForDelegatedFunction].delegate(to: target, with: callback)
        return self
    }
    
    @discardableResult
    func manuallyDelegate(with callback: @escaping (DelegatedInput) -> Void) -> Self {
        self[keyPath: Self.keyPathForDelegatedFunction].manuallyDelegate(with: callback)
        return self
    }
    
    func removeDelegate() {
        self[keyPath: Self.keyPathForDelegatedFunction].removeDelegate()
    }
}

extension UIView {
    func recognizeTaps(
        numberOfTapsRequired: Int = 1,
        numberOfTouchesRequired: Int = 1
    ) -> TapGestureRecognizer {
        let tap = TapGestureRecognizer()
        tap.numberOfTapsRequired = numberOfTapsRequired
        tap.numberOfTouchesRequired = numberOfTouchesRequired
        return recognize(tap)
    }
    
    func recognizeSwipe(
        direction: UISwipeGestureRecognizer.Direction,
        numberOfTouchesRequired: Int = 1
    ) -> SwipeGestureRecognizer {
        let swipe = SwipeGestureRecognizer()
        swipe.direction = direction
        swipe.numberOfTouchesRequired = numberOfTouchesRequired
        return recognize(swipe)
    }
    
    func recognizeLongPress(
        minimumPressDuration: TimeInterval = 0.5,
        numberOfTouchesRequired: Int = 1,
        numberOfTapsRequired: Int = 0,
        allowableMovement: CGFloat = 10
    ) -> LongPressGestureRecognizer {
        let longPress = LongPressGestureRecognizer()
        longPress.minimumPressDuration = minimumPressDuration
        longPress.numberOfTouchesRequired = numberOfTouchesRequired
        longPress.numberOfTapsRequired = numberOfTapsRequired
        longPress.allowableMovement = allowableMovement
        return recognize(longPress)
    }
    
    @available(iOS 13.0, *)
    func recognizeHover() -> HoverGestureRecognizer {
        return recognize(HoverGestureRecognizer())
    }
    
    func recognize<Recognizer: UIGestureRecognizer>(_ recognizer: Recognizer) -> Recognizer {
        isUserInteractionEnabled = true
        addGestureRecognizer(recognizer)
        return recognizer
    }
}

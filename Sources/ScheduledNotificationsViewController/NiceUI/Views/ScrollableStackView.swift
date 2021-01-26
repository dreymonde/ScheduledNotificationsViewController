//
//  ScrollableStackView.swift
//  Private Analytics
//
//  Created by Oleg Dreyman on 28.08.2020.
//  Copyright © 2020 Confirmed, Inc. All rights reserved.
//

import UIKit

final class ScrollableStackView: UIView {
    
    let scrollView: UIScrollView = EnhancedControlTouchScrollView()
    let stackView = UIStackView()
    
    init(axis: NSLayoutConstraint.Axis, contentInset: UIEdgeInsets = .zero) {
        stackView.axis = axis
        super.init(frame: .zero)
        setup(contentInset: contentInset)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    // Note: we should probably remove these? Too hacky for my taste (Oleg)
    
    @_Proxy(\ScrollableStackView.scrollView.alwaysBounceHorizontal)
    var alwaysBounceHorizontal: Bool
    
    @_Proxy(\ScrollableStackView.scrollView.alwaysBounceVertical)
    var alwaysBounceVertical: Bool
    
    @_Proxy(\ScrollableStackView.scrollView.contentInset)
    var contentInset: UIEdgeInsets
    
    @_Proxy(\ScrollableStackView.stackView.spacing)
    var spacing: CGFloat
    
    @_Proxy(\ScrollableStackView.stackView.alignment)
    var alignment: UIStackView.Alignment
    
    @_Proxy(\ScrollableStackView.stackView.distribution)
    var distribution: UIStackView.Distribution
    
    func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    // MARK: - Private

    private func setup(contentInset: UIEdgeInsets) {
        scrollView.addSubview(stackView)
        addSubview(scrollView)
        
        with(stackView) {
            $0.anchors.edges.pin()
            
            switch stackView.axis {
            case .vertical:
                $0.anchors.width.equal(
                    scrollView.anchors.width,
                    constant: -(contentInset.left + contentInset.right)
                )
            case .horizontal:
                $0.anchors.height.equal(
                    scrollView.anchors.height,
                    constant: -(contentInset.top + contentInset.bottom)
                )
            default:
                assertionFailure("unknown layout axis")
            }
        }
        
        with(scrollView) {
            $0.anchors.edges.pin()
            $0.contentInset.top += contentInset.top
            $0.contentInset.left += contentInset.left
            $0.contentInset.right += contentInset.right
            $0.contentInset.bottom += contentInset.bottom
        }
    }
}

final class EnhancedControlTouchScrollView: UIScrollView {
    override var delaysContentTouches: Bool {
        get { return false }
        set {  }
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}

// https://swiftbysundell.com/articles/accessing-a-swift-property-wrappers-enclosing-instance/
@propertyWrapper
struct _Proxy<EnclosingType, Value> {
    typealias ValueKeyPath = ReferenceWritableKeyPath<EnclosingType, Value>
    typealias SelfKeyPath = ReferenceWritableKeyPath<EnclosingType, Self>

    static subscript(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ValueKeyPath,
        storage storageKeyPath: SelfKeyPath
    ) -> Value {
        get {
            let keyPath = instance[keyPath: storageKeyPath].keyPath
            return instance[keyPath: keyPath]
        }
        set {
            let keyPath = instance[keyPath: storageKeyPath].keyPath
            instance[keyPath: keyPath] = newValue
        }
    }
    
    @available(*, unavailable,
        message: "@Proxy can only be applied to classes"
    )
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    private let keyPath: ValueKeyPath

    init(_ keyPath: ValueKeyPath) {
        self.keyPath = keyPath
    }
}

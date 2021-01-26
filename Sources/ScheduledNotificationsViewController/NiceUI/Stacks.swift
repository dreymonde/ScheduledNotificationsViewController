//
//  Stacks.swift
//  DailyQuestions
//
//  Created by Oleg Dreyman on 9/29/20.
//  Copyright © 2020 Oleg Dreyman. All rights reserved.
//

import UIKit

func Vertically(_ views: [UIView]) -> UIStackView {
    return with(UIStackView()) {
        $0.axis = .vertical
        views.forEach($0.addArrangedSubview(_:))
    }
}

func Vertically(_ views: UIView...) -> UIStackView {
    return Vertically(views)
}

func Vertically(_ views: [UIView], setup: (UIStackView) -> Void) -> UIStackView {
    return with(UIStackView()) {
        $0.axis = .vertical
        views.forEach($0.addArrangedSubview(_:))
        setup($0)
    }
}

func Vertically(_ views: UIView..., setup: (UIStackView) -> Void) -> UIStackView {
    return Vertically(views, setup: setup)
}

func VerticallyScrollable(_ views: [UIView], contentInset: UIEdgeInsets = .zero) -> ScrollableStackView {
    return with(ScrollableStackView(axis: .vertical, contentInset: contentInset)) {
        views.forEach($0.addArrangedSubview(_:))
    }
}

func VerticallyScrollable(_ views: UIView..., contentInset: UIEdgeInsets = .zero) -> ScrollableStackView {
    return VerticallyScrollable(views, contentInset: contentInset)
}

func VerticallyScrollable(_ views: [UIView], contentInset: UIEdgeInsets = .zero, setup: (UIStackView) -> Void) -> ScrollableStackView {
    return with(ScrollableStackView(axis: .vertical, contentInset: contentInset)) {
        views.forEach($0.addArrangedSubview(_:))
        setup($0.stackView)
    }
}

func VerticallyScrollable(_ views: UIView..., contentInset: UIEdgeInsets = .zero, setup: (UIStackView) -> Void) -> ScrollableStackView {
    return VerticallyScrollable(views, contentInset: contentInset, setup: setup)
}

func VerticalContainer<View: UIView>(_ view: View, alignment: Alignmment = .center, insets: UIEdgeInsets = .zero) -> ContainerView<View> {
    let container = ContainerView(contentView: view)
    container.addSubview(view) {
        $0.anchors.edges.pin(insets: insets, axis: .vertical, alignment: alignment)
        $0.anchors.edges.pin(insets: insets, axis: .horizontal)
    }
    
    return container
}

func Horizontally(_ views: [UIView]) -> UIStackView {
    return with(UIStackView()) {
        $0.axis = .horizontal
        views.forEach($0.addArrangedSubview(_:))
    }
}

func Horizontally(_ views: UIView...) -> UIStackView {
    return Horizontally(views)
}

func Horizontally(_ views: [UIView], setup: (UIStackView) -> Void) -> UIStackView {
    return with(UIStackView()) {
        $0.axis = .horizontal
        views.forEach($0.addArrangedSubview(_:))
        setup($0)
    }
}

func Horizontally(_ views: UIView..., setup: (UIStackView) -> Void) -> UIStackView {
    return Horizontally(views, setup: setup)
}

func HorizontallyScrollable(_ views: [UIView], contentInset: UIEdgeInsets = .zero) -> ScrollableStackView {
    return with(ScrollableStackView(axis: .horizontal)) {
        views.forEach($0.addArrangedSubview(_:))
    }
}

func HorizontallyScrollable(_ views: UIView..., contentInset: UIEdgeInsets = .zero) -> ScrollableStackView {
    return HorizontallyScrollable(views, contentInset: contentInset)
}

func HorizontallyScrollable(_ views: [UIView], contentInset: UIEdgeInsets = .zero, setup: (UIStackView) -> Void) -> ScrollableStackView {
    return with(ScrollableStackView(axis: .horizontal)) {
        views.forEach($0.addArrangedSubview(_:))
        setup($0.stackView)
    }
}

func HorizontallyScrollable(_ views: UIView..., contentInset: UIEdgeInsets = .zero, setup: (UIStackView) -> Void) -> ScrollableStackView {
    return HorizontallyScrollable(views, contentInset: contentInset, setup: setup)
}

func HorizontalContainer<View: UIView>(_ view: View, alignment: Alignmment = .center, insets: UIEdgeInsets = .zero) -> ContainerView<View> {
    let container = ContainerView(contentView: view)
    container.addSubview(view) {
        $0.anchors.edges.pin(insets: insets, axis: .horizontal, alignment: alignment)
        $0.anchors.edges.pin(insets: insets, axis: .vertical)
    }
    return container
}

extension UIEdgeInsets {
    static func top(_ topInset: CGFloat) -> UIEdgeInsets {
        return .init(top: topInset, left: 0, bottom: 0, right: 0)
    }
    static func bottom(_ bottomInset: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
    static func left(_ leftInset: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: leftInset, bottom: 0, right: 0)
    }
    static func right(_ rightInset: CGFloat) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: rightInset)
    }
    static func all(_ inset: CGFloat) -> UIEdgeInsets {
        return .init(top: inset, left: inset, bottom: inset, right: inset)
    }
}

@discardableResult
func with<Obj: AnyObject>(_ object: Obj, _ block: (Obj) -> Void) -> Obj {
    block(object)
    return object
}

@discardableResult
func withMany<Obj: AnyObject>(_ objects: [Obj], _ block: (Obj) -> Void) -> [Obj] {
    objects.forEach(block)
    return objects
}

/// Create this by using functions `VerticalContainer` and `HorizontalContainer`
final class ContainerView<ContentView: UIView>: View {
    let contentView: ContentView
    
    internal init(contentView: ContentView) {
        self.contentView = contentView
        super.init()
    }
}

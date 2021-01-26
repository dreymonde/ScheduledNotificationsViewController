//
//  StaticTableView.swift
//  DailyQuestions
//
//  Created by Oleg Dreyman on 9/10/20.
//  Copyright © 2020 Oleg Dreyman. All rights reserved.
//

import NiceUI

enum Segment {
    case staticCell(SelectableTableViewCell)
    case dynamic(Dynamic)
    
    func makeRows() -> [Row] {
        switch self {
        case .staticCell(let cell):
            return [.staticCell(cell)]
        case .dynamic(let dynamic):
            let dataSet = dynamic.dataSet()
            return dataSet.map { Row.dynamicCell(reuseIdentifier: dynamic.reuseIdentifier, data: $0) }
        }
    }
    
    class Dynamic {
        init(dataSet: @escaping () -> [Any], reuseIdentifier: String) {
            self.dataSet = dataSet
            self.reuseIdentifier = reuseIdentifier
        }
        
        fileprivate var dataSet: () -> [Any]
        let reuseIdentifier: String
    }
}

class DynamicSegment<Content>: Segment.Dynamic {
    func reload(with content: [Content]) {
        self.dataSet = { content }
    }
}

struct SectionDescriptor {
    var title: String?
    var footer: String?
    var segments: [Segment]
}

enum Row {
    case staticCell(SelectableTableViewCell)
    case dynamicCell(reuseIdentifier: String, data: Any)
}

final class StaticTableView: UITableView {
    
    @Delegated var pullToRefreshCallback: (StaticTableView) -> ()
    
    var descriptor: [SectionDescriptor] = []
    private var reuseIdentifiers: [String] = []
    
    struct Section {
        var title: String?
        var footer: String?
        var rows: [Row]
    }
    
    private var _sections: [Section] = []
        
    private var _rows: [Row] {
        return _sections.flatMap(\.rows)
    }
    
    private var dynamicCreators: [String: (() -> DynamicSelectableTableViewCell)] = [:]
//
//    private var setups: [String: DynamicSetup] = [:]
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    func setup() {
        dataSource = self
        delegate = self
        separatorStyle = .none
        tableFooterView = UIView()
        cellLayoutMarginsFollowReadableWidth = true
    }
    
    enum Insert {
        case last
        case dontInsert
    }
    
    @discardableResult
    func addRow(_ configure: (UIView) -> ()) -> SelectableTableViewCell {
        let cell = SelectableTableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = nil
        configure(cell.contentView)
        if deselectCellsWhenSelected {
            cell.actions.insert(.deselect)
        }
        self.insert(segment: .staticCell(cell), insert: .last)
        return cell
    }
    
    @discardableResult
    func addRowCell(style: UITableViewCell.CellStyle = .default, _ configure: (UITableViewCell) -> ()) -> SelectableTableViewCell {
        let cell = SelectableTableViewCell(style: style, reuseIdentifier: nil)
        cell.selectionStyle = .none
        configure(cell)
        if deselectCellsWhenSelected {
            cell.actions.insert(.deselect)
        }
        self.insert(segment: .staticCell(cell), insert: .last)
//        self.insert(cell: cell, insert: .last)
        return cell
    }
    
    @discardableResult
    func addRow(view: UIView, marginInsets: UIEdgeInsets = .zero) -> SelectableTableViewCell {
        return addRow { (row) in
            row.addSubview(view)
            view.anchors.edges.marginsPin(insets: marginInsets)
        }
    }
    
    @discardableResult
    func addDynamicSegment<Content>(initialDataSet: [Content], style: UITableViewCell.CellStyle = .default, _ configure: @escaping (SpecifiedDynamicSelectableTableViewCell<Content>) -> ()) -> DynamicSegment<Content> {
        return insertDynamicSegment(dataSet: { initialDataSet }, style: style, configure)
    }
    
    func addDynamicSegment<Provider: AnyObject, Content>(provider: Provider, dataSet: @escaping (Provider) -> [Content], style: UITableViewCell.CellStyle = .default, _ configure: @escaping (SpecifiedDynamicSelectableTableViewCell<Content>) -> ()) {
        let getDataSet: () -> [Content] = { [weak provider] in
            if let provider = provider {
                return dataSet(provider)
            } else {
                return []
            }
        }
        insertDynamicSegment(dataSet: getDataSet, style: style, configure)
    }
    
    @discardableResult
    private func insertDynamicSegment<Content>(dataSet: @escaping () -> [Content], style: UITableViewCell.CellStyle, _ configure: @escaping (SpecifiedDynamicSelectableTableViewCell<Content>) -> ()) -> DynamicSegment<Content> {
        let newReuseIdentifier = UUID().uuidString
        
        self.dynamicCreators[newReuseIdentifier] = {
            let newCell = SpecifiedDynamicSelectableTableViewCell<Content>(style: style, reuseIdentifier: newReuseIdentifier)
            newCell.selectionStyle = .none
            configure(newCell)
            return newCell
        }
        
        let getDataSet: () -> [Content] = dataSet
        let dynamicSegment = DynamicSegment<Content>(dataSet: getDataSet, reuseIdentifier: newReuseIdentifier)
        insert(segment: .dynamic(dynamicSegment), insert: .last)
        return dynamicSegment
    }
    
    func startSection(title: String?, footer: String? = nil) {
        descriptor.append(.init(title: title, footer: footer, segments: []))
    }
    
//    func addSeparator(_ insets: UIEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)) {
//        if let last = _rows.last {
//            Separator.addBottomSeparator(to: last, insets: insets)
//        }
//    }
    
    private func insert(segment: Segment, insert: Insert) {
//        if deselectCellsWhenSelected {
//            cell.actions.insert(.deselect)
//        }
        
        switch insert {
        case .dontInsert:
            break
        case .last:
            if descriptor.isEmpty {
                let newSection = SectionDescriptor(title: nil, segments: [segment])
                descriptor = [newSection]
//                sections = [newSection]
            } else {
                descriptor[descriptor.count - 1].segments.append(segment)
            }
        }
        
        self.render()
    }
    
    func clear() {
        descriptor = []
        self.render()
//        sections = []
    }
    
    override func reloadData() {
        self.render()
        super.reloadData()
    }
    
    func render() {
        _sections = descriptor.map({ (sectionDescriptor) in
            return Section(title: sectionDescriptor.title, footer: sectionDescriptor.footer, rows: sectionDescriptor.segments.flatMap({ $0.makeRows() }))
        })
    }
    
    @discardableResult
    func onPulledToRefresh<Delegate: AnyObject>(to delegate: Delegate, callback: @escaping (Delegate) -> ()) -> Self {
        if self.refreshControl == nil {
            let new = UIRefreshControl()
            new.addTarget(self, action: #selector(refreshControlDidChangeValue), for: .valueChanged)
            self.refreshControl = new
        }
        $pullToRefreshCallback.delegate(to: delegate) { (target, _) in
            callback(target)
        }
        return self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isEnhancedControlSelectionEnabled: Bool = false {
        didSet {
            delaysContentTouches = !isEnhancedControlSelectionEnabled
        }
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        guard isEnhancedControlSelectionEnabled else {
            return super.touchesShouldCancel(in: view)
        }
        
        if view is UIControl {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
    
    var deselectCellsWhenSelected: Bool = true
    var shouldCenterContentIfFits: Bool = false
    
    @objc
    private func refreshControlDidChangeValue() {
        pullToRefreshCallback(self)
    }
}

class SelectableTableViewCell: UITableViewCell {
    @Delegated var selectionCallback: (SelectableTableViewCell) -> ()
    
    var actions: Set<Action> = []
    
    enum Action {
        case toggleCheckmark
        case deselect
    }
    
    @discardableResult
    func onSelect<Delegate: AnyObject>(to delegate: Delegate, callback: @escaping (Delegate, SelectableTableViewCell) -> ()) -> Self {
        selectionStyle = .default
        $selectionCallback.delegate(to: delegate, with: callback)
        return self
    }
    
    @discardableResult
    func withAccessoryType(_ accessoryType: AccessoryType) -> SelectableTableViewCell {
        self.accessoryType = accessoryType
        return self
    }
    
    @discardableResult
    func onSelect(_ action: Action) -> Self {
        if action == .deselect {
            selectionStyle = .default
        }
        actions.insert(action)
        return self
    }
}

extension StaticTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return _sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = _sections[indexPath.section].rows[indexPath.row]
        switch row {
        case .staticCell(let cell):
            return cell
        case .dynamicCell(reuseIdentifier: let reuseIdentifier, data: let data):
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
            if let existing = reusableCell as? DynamicSelectableTableViewCell {
                existing.reuse(with: data)
                return existing
            } else if let creator = dynamicCreators[reuseIdentifier] {
                let new = creator()
                new.reuse(with: data)
                if self.deselectCellsWhenSelected {
                    new.actions.insert(.deselect)
                }
                return new
            } else {
                preconditionFailure("Dynamic cell was misconfigured somehow")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _sections[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return _sections[section].footer
    }
}

extension StaticTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath) as? SelectableTableViewCell {
            return cell.selectionStyle != .none
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SelectableTableViewCell {
            cell.selectionCallback(cell)
            for action in cell.actions {
                switch action {
                case .deselect:
                    tableView.deselectRow(at: indexPath, animated: true)
                case .toggleCheckmark:
                    if cell.accessoryType == .checkmark {
                        cell.accessoryType = .none
                    } else {
                        cell.accessoryType = .checkmark
                    }
                }
            }
        }
    }
}

extension UIViewController {
    func addKeyboardAwareTableView(_ tableView: UITableView) {
        let tableViewController = StaticTableViewController()
        tableViewController.tableView = tableView
        view.addSubview(tableViewController.view)
        tableViewController.view.anchors.edges.pin()
        addChild(tableViewController)
        tableViewController.didMove(toParent: self)
    }
}

final class StaticTableViewController: UITableViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableView = self.tableView as! StaticTableView
        guard tableView.shouldCenterContentIfFits else {
            return
        }
        
        DispatchQueue.main.async {
            let totalHeight = tableView.contentSize.height
            let screenHeight = self.view.frame.size.height - (self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom)
            let diff = screenHeight - tableView.contentInset.bottom - totalHeight
            if diff > 0 {
                let topOffset = diff / 2
                if topOffset > 80 {
                    tableView.contentInset.top = topOffset - 30
                } else {
                    tableView.contentInset.top = topOffset
                }
            }
        }
    }
}

enum Separator {
    private static func contains(tag: String, inSubviewsOf view: UIView) -> Bool {
        return view.subviews.contains { $0.accessibilityIdentifier == tag }
    }
    
    fileprivate static func makeSeparatorView(tag: String, axis: NSLayoutConstraint.Axis) -> UIView {
        let separator = UIView()
        separator.accessibilityIdentifier = tag
        separator.backgroundColor = .separator
        switch axis {
        case .horizontal:
            separator.anchors.height.equal(0.33)
        case .vertical:
            separator.anchors.width.equal(0.33)
        @unknown default:
            break
        }
        return separator
    }
    
    static func topSeparator(for view: UIView) -> UIView? {
        return view.subviews.first(where: { $0.accessibilityIdentifier == "top_separator" })
    }
    
    static func bottomSeparator(for view: UIView) -> UIView? {
        return view.subviews.first(where: { $0.accessibilityIdentifier == "bottom_separator" })
    }
    
    static func addTopSeparator(to view: UIView, insets: UIEdgeInsets) {
        if contains(tag: "top_separator", inSubviewsOf: view) {
            return
        }
        
        let separator = makeSeparatorView(tag: "top_separator", axis: .horizontal)
        view.addSubview(separator)
        separator.anchors.leading.marginsPin(inset: insets.left - 8)
        separator.anchors.trailing.marginsPin(inset: insets.right - 8)
        separator.anchors.top.pin(inset: insets.top)
    }
    
    static func addLeadingSeparator(to view: UIView, insets: UIEdgeInsets) {
        if contains(tag: "leading_separator", inSubviewsOf: view) {
            return
        }
        
        let separator = makeSeparatorView(tag: "leading_separator", axis: .vertical)
        view.addSubview(separator)
        separator.anchors.leading.pin(inset: insets.left)
        separator.anchors.top.pin(inset: insets.top)
        separator.anchors.bottom.pin(inset: insets.top)
    }
    
    static func addTrailingSeparator(to view: UIView, insets: UIEdgeInsets) {
        if contains(tag: "trailing_separator", inSubviewsOf: view) {
            return
        }
        
        let separator = makeSeparatorView(tag: "trailing_separator", axis: .vertical)
        view.addSubview(separator)
        separator.anchors.trailing.pin(inset: insets.right)
        separator.anchors.top.pin(inset: insets.top)
        separator.anchors.bottom.pin(inset: insets.top)
    }
    
    static func addBottomSeparator(to view: UIView, insets: UIEdgeInsets) {
        if contains(tag: "bottom_separator", inSubviewsOf: view) {
            return
        }
        
        let separator = makeSeparatorView(tag: "bottom_separator", axis: .horizontal)
        view.addSubview(separator)
        separator.anchors.leading.marginsPin(inset: insets.left - 8)
        separator.anchors.trailing.marginsPin(inset: insets.right - 8)
        separator.anchors.bottom.pin(inset: insets.bottom)
    }
}

struct Nope: Error { }

class DynamicSelectableTableViewCell: SelectableTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    var setup: (Any) -> () = { _ in }
    func reuse(with content: Any) {
        setup(content)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SpecifiedDynamicSelectableTableViewCell<Content>: DynamicSelectableTableViewCell {
     
    var content: Content?
    
    func onReuse(perform: @escaping (SelectableTableViewCell, Content) -> ()) {
        setup = { [weak self] data in
            if let content = data as? Content, let strongSelf = self {
                strongSelf.content = content
                perform(strongSelf, content)
            } else {
                assertionFailure("\(data) is not of type \(Content.self)")
            }
        }
    }
    
}

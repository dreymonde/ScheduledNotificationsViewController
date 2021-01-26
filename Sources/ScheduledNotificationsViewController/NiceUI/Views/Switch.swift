//
//  File.swift
//  
//
//  Created by Oleg Dreyman on 1/22/21.
//

import UIKit

final class Switch: UISwitch {
    
    @Delegated1 var didToggle: (Switch) -> ()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setTargetAction()
    }
    
    private func setTargetAction() {
        addTarget(self, action: #selector(_valueChanged), for: .valueChanged)
    }
    
    @objc
    private func _valueChanged() {
        didToggle(self)
    }
}

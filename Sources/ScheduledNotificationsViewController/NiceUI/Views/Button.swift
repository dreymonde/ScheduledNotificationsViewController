//
//  File.swift
//  
//
//  Created by Oleg Dreyman on 1/22/21.
//

import UIKit

final class Button: UIButton {
    
    @Delegated1 var didTap: (Button) -> ()
    
    @available(*, deprecated, renamed: "Button()")
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(type: .system)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func solidBackground(_ backgroundColor: UIColor = .systemBlue, cornerRadius: CGFloat = 8) -> Button {
        let button = Button()
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        button.setBackgroundColor(backgroundColor, for: .normal)
        return button
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setTargetAction()
    }
    
    private func setTargetAction() {
        addTarget(self, action: #selector(_didTouchUpInside), for: .touchUpInside)
    }
    
    @objc
    private func _didTouchUpInside() {
        didTap(self)
    }
}

// Original authors: Kickstarter
// https://github.com/kickstarter/Kickstarter-Prelude/blob/master/Prelude-UIKit/UIButton.swift

extension Button {
    /**
     Sets the background color of a button for a particular state.
     - parameter backgroundColor: The color to set.
     - parameter state:           The state for the color to take affect.
     */
    func setBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) {
        Button.setBackgroundColor(backgroundColor, to: self, for: state)
    }
    
    static func setBackgroundColor(_ backgroundColor: UIColor, to button: UIButton, for state: UIControl.State) {
        button.setBackgroundImage(NiceImage.pixel(ofColor: backgroundColor), for: state)
    }
}

enum NiceImage {
    
    /**
     - parameter color: A color.
     - returns: A 1x1 UIImage of a solid color.
     */
    static func pixel(ofColor color: UIColor) -> UIImage {
        if #available(iOS 12.0, *) {
            let lightModeImage = NiceImage.generatePixel(ofColor: color, userInterfaceStyle: .light)
            let darkModeImage = NiceImage.generatePixel(ofColor: color, userInterfaceStyle: .dark)
            lightModeImage.imageAsset?.register(darkModeImage, with: UITraitCollection(userInterfaceStyle: .dark))
            return lightModeImage
        } else {
            return generatePixel(ofColor: color)
        }
    }
    
    @available(iOS 12.0, *)
    static private func generatePixel(ofColor color: UIColor, userInterfaceStyle: UIUserInterfaceStyle) -> UIImage {
        var image: UIImage!
        UITraitCollection(userInterfaceStyle: userInterfaceStyle).performAsCurrent {
            image = NiceImage.generatePixel(ofColor: color)
        }
        return image
    }
    
    static private func generatePixel(ofColor color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(pixel.size)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        context.setFillColor(color.cgColor)
        context.fill(pixel)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

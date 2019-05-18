//
//  UICheckBox.swift
//  UICheckBox
//
//  Created by Patrick Gorospe on 5/17/19.
//

import Foundation
import UIKit
import SnapKit

open class UICheckBox: UIControl {
    // MARK: - Enums
    public enum Style {
        case normal
        case indeterminate
    }
    
    public enum Status: Int {
        case inactive
        case indeterminate
        case active
    }
    
    public var imgActive = UIImage(named: "imgCheckbox_active", in: Bundle.Icons, compatibleWith: nil)
    public var imgInactive = UIImage(named: "imgCheckbox_default", in: Bundle.Icons, compatibleWith: nil)
    public var imgIndeterminate = UIImage(named: "imgCheckbox_indeterminate", in: Bundle.Icons, compatibleWith: nil)
    
    /// Default is
    /// Style.normal
    public var style: Style = .normal
    
    /// Callback
    public var valueChanged: ((_ isChecked: Status) -> Void)?
    
    public var status: Status = .inactive {
        didSet {
            changeImage(forStatus: status)
        }
    }
    
    private let imgCheckbox = UIImageView()
    
    // MARK: - Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
        setupUI()
    }
    
    private func setupUI() {
        addSubview(imgCheckbox)
        
        imgCheckbox.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        changeImage(forStatus: status)
    }
    
    private func setupDefaults() {
        backgroundColor = UIColor.init(white: 1, alpha: 0)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Touch
    @objc private func handleTapGesture(recognizer: UITapGestureRecognizer) {
        updateStatus()
        valueChanged?(status)
        sendActions(for: .valueChanged)
    }
    
    private func updateStatus() {
        if style == .normal {
            status = status == .inactive ? .active : .inactive
        } else {
            status = UICheckBox.Status(rawValue: status.rawValue + 1) ?? .inactive
        }
        changeImage(forStatus: status)
    }
    
    private func changeImage(forStatus status: Status) {
        var img = imgActive!
        
        switch status {
        case .inactive:
            img = imgInactive!
            break
        case .indeterminate:
            img = imgIndeterminate!
            break
        default:
            img = imgActive!
            break
        }
        
        self.alpha = 1
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.alpha = 1
                self.imgCheckbox.image = img
                
            }
        }
    }

}

extension Bundle {
    static public var Icons = UICheckboxIcons()
    
    static public func UICheckboxIcons() -> Bundle {
        let bundle = Bundle(for: UICheckBox.self)
        
        if let path = bundle.path(forResource: "UICheckBox", ofType: "bundle") {
            return Bundle(path: path)!
        } else {
            return bundle
        }
    }
}



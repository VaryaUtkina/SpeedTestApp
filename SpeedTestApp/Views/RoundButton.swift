//
//  RounfButton.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 04.04.2024.
//

import UIKit

final class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: - Private Methods
    private func setupButton() {
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
        backgroundColor = .background
        setTitleColor(.white, for: .normal)
    }
}


//
//  RounfButton.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 04.04.2024.
//

import UIKit

// класс для создания круглой кнопки
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
        backgroundColor = Theme.currentTheme.buttonColor
        setTitleColor(.white, for: .normal)
    }
    
    func displayButton(_ isTestingInProgress: Bool) {
        if isTestingInProgress {
            setTitle("Go", for: .normal)
            isEnabled = true
            backgroundColor = Theme.currentTheme.buttonColor
        } else {
            setTitle("wait...", for: .normal)
            isEnabled = false
            backgroundColor = .customGrey
        }
    }
}


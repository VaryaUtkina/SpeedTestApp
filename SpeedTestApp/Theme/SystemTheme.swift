//
//  SystemTheme.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 09.04.2024.
//

import UIKit

// системная тема и ее параметры
final class SystemTheme: ThemeProtocol {
    var option = ThemeOption.system
    var backgroundColor = UIColor.backgroundSystem
    var textColor = UIColor.white
    var buttonColor = UIColor.backgroundDark
    
    func applyThemeToButton(_ button: UIButton) {
        button.backgroundColor = Theme.currentTheme.buttonColor
        button.layer.cornerRadius = button.frame.height / 3
    }
    
    func applyThemeToLabel(_ label: UILabel) {
        label.textColor = Theme.currentTheme.textColor
    }
}

//
//  DarkTheme.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 09.04.2024.
//

import UIKit

// темная тема и ее параметры
final class DarkTheme: ThemeProtocol {
    var option = ThemeOption.dark
    var backgroundColor = UIColor.backgroundDark
    var textColor = UIColor.white
    var buttonColor = UIColor.backgroundSystem
    
    func applyThemeToButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 3
        button.backgroundColor = Theme.currentTheme.buttonColor
    }
    
    func applyThemeToLabel(_ label: UILabel) {
        label.textColor = Theme.currentTheme.textColor
    }
}

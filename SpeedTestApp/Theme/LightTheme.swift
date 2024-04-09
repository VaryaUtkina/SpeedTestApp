//
//  LightTheme.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 09.04.2024.
//

import UIKit

final class LightTheme: ThemeProtocol {
    var option = ThemeOption.light
    var backgroundColor = UIColor.backgroundLight
    var textColor = UIColor.black
    var buttonColor = UIColor.backgroundDark
    
    func applyThemeToButton(_ button: UIButton) {
        button.backgroundColor = Theme.currentTheme.buttonColor
        button.layer.cornerRadius = button.frame.height / 3
    }
    
    func applyThemeToLabel(_ label: UILabel) {
        label.textColor = Theme.currentTheme.textColor
    }
}

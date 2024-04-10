//
//  Theme.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 09.04.2024.
//

import UIKit

// перечисление возможных тем
enum ThemeOption: String, CaseIterable {
    case system = "System theme"
    case light = "Light theme"
    case dark = "Dark theme"
    
    var type: ThemeProtocol {
        switch self {
        case .system:
            SystemTheme()
        case .light:
            LightTheme()
        case .dark:
            DarkTheme()
        }
    }
}

// протокол для назначения основных параметров тем
protocol ThemeProtocol {
    var option: ThemeOption { get }
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var buttonColor: UIColor { get }
    
    func applyThemeToButton(_ button: UIButton)
    func applyThemeToLabel(_ label: UILabel)
}

// класс, который содержит текущую тему
final class Theme {
    static var currentTheme: ThemeProtocol = SystemTheme()
}


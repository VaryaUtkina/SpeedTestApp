//
//  ViewController.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 04.04.2024.
//

import UIKit

// протокол для передачи свойств на другой экран через делегат
protocol SettingsViewControllerDelegate: AnyObject {
    func didChangeDownloadSelection(_ value: Bool)
    func didChangeUploadSelection(_ value: Bool)
    func didChangeURL(_ value: String)
}

final class SpeedViewController: UIViewController {
    
    @IBOutlet var goButton: RoundButton!
    
    @IBOutlet var downloadTitle: UILabel!
    @IBOutlet var uploadTitle: UILabel!
    @IBOutlet var downloadLabel: UILabel!
    @IBOutlet var currentDownloadSpeedLabel: UILabel!
    @IBOutlet var uploadLabel: UILabel!
    @IBOutlet var currentUploadLabel: UILabel!
    
    @IBOutlet var downloadStack: UIStackView!
    @IBOutlet var uploadStack: UIStackView!
    
    let networkManager = NetworkManager.shared
    var serverURL = ""
    var shouldMeasureDownloadSpeed = true
    var shouldMeasureUploadSpeed = true
    
    private var isTestingInProgress = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // настройка отображения экраны с учетом выбранной темы
        view.backgroundColor = Theme.currentTheme.backgroundColor
        [
            downloadTitle,
            uploadTitle,
            downloadLabel,
            uploadLabel,
            currentDownloadSpeedLabel,
            currentUploadLabel
        ].forEach{ label in
            Theme.currentTheme.applyThemeToLabel(label ?? UILabel())
        }
        guard let navigationBar = navigationController?.navigationBar else { return }
        let attributes = [NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor]
        navigationBar.titleTextAttributes = attributes
        goButton.displayButton(!isTestingInProgress)
    }
    
    // передача данных при переходе на другой экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.delegate = self
        settingsVC.downloadIsSelected = shouldMeasureDownloadSpeed
        settingsVC.uploadIsSelected = shouldMeasureUploadSpeed
        settingsVC.url = serverURL
    }
    
    // логика при нажатии на кнопку Go
    @IBAction func goButtonTapped(_ sender: RoundButton) {
        // не дает возможности нажать на кнопку, если процесс был запущен
        if isTestingInProgress {
            return
        }
        
        // обновление вида кнопки
        downloadLabel.text = "Average speed: -"
        uploadLabel.text = "Average speed: -"
        sender.displayButton(isTestingInProgress)
        isTestingInProgress.toggle()
        
        // проверка чекбоксов (какие параметры выбраны) и реализация кода
        if shouldMeasureDownloadSpeed && !shouldMeasureUploadSpeed {
            measureDownloadSpeed { result in
                if result {
                    sender.displayButton(self.isTestingInProgress)
                    self.isTestingInProgress.toggle()
                } else {
                    sender.displayButton(true)
                    self.isTestingInProgress = false
                }
            }
        } else if shouldMeasureUploadSpeed && !shouldMeasureDownloadSpeed {
            measureUploadSpeed { result in
                if result {
                    sender.displayButton(self.isTestingInProgress)
                    self.isTestingInProgress.toggle()
                } else {
                    sender.displayButton(true)
                    self.isTestingInProgress = false
                }
            }
        } else {
            measureDownloadSpeed { downloadResult in
                if downloadResult {
                    self.measureUploadSpeed { uploadResult in
                        if uploadResult {
                            sender.displayButton(self.isTestingInProgress)
                            self.isTestingInProgress.toggle()
                        } else {
                            sender.displayButton(true)
                            self.isTestingInProgress = false
                        }
                    }
                } else {
                    sender.displayButton(true)
                    self.isTestingInProgress = false
                }
            }
        }
    }
}

// MARK: - SettingsViewControllerDelegate
extension SpeedViewController: SettingsViewControllerDelegate {
    func didChangeDownloadSelection(_ value: Bool) {
        shouldMeasureDownloadSpeed = value
        downloadStack.isHidden = !value
    }
    
    func didChangeUploadSelection(_ value: Bool) {
        shouldMeasureUploadSpeed = value
        uploadStack.isHidden = !value
    }
    
    func didChangeURL(_ value: String) {
        serverURL = value
    }
}

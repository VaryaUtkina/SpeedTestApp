//
//  ViewController.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 04.04.2024.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didChangeDownloadSelection(_ value: Bool)
    func didChangeUploadSelection(_ value: Bool)
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
    let serverURL = "https://www.speedtest.net"
    var shouldMeasureDownloadSpeed = true
    var shouldMeasureUploadSpeed = true
    
    private var isTestingInProgress = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.delegate = self
        settingsVC.downloadIsSelected = shouldMeasureDownloadSpeed
        settingsVC.uploadIsSelected = shouldMeasureUploadSpeed
    }
    
    @IBAction func goButtonTapped(_ sender: RoundButton) {
        if isTestingInProgress {
            return
        }
        
        downloadLabel.text = "Average speed: -"
        uploadLabel.text = "Average speed: -"
        sender.displayButton(isTestingInProgress)
        isTestingInProgress.toggle()
        
        if shouldMeasureDownloadSpeed && !shouldMeasureUploadSpeed {
            measureDownloadSpeed {
                sender.displayButton(self.isTestingInProgress)
                self.isTestingInProgress.toggle()
            }
        } else if shouldMeasureUploadSpeed && !shouldMeasureDownloadSpeed {
            measureUploadSpeed {
                sender.displayButton(self.isTestingInProgress)
                self.isTestingInProgress.toggle()
            }
        } else {
            measureDownloadSpeed {
                self.measureUploadSpeed {
                    sender.displayButton(self.isTestingInProgress)
                    self.isTestingInProgress.toggle()
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
}

//
//  ViewController.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 04.04.2024.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func setupURL()
}

final class SpeedViewController: UIViewController {
    @IBOutlet var downloadLabel: UILabel!
    @IBOutlet var currentDownloadSpeedLabel: UILabel!
    @IBOutlet var uploadLabel: UILabel!
    @IBOutlet var currentUploadLabel: UILabel!
    
    let networkManager = NetworkManager.shared
    let serverURL = "https://www.speedtest.net"
    private var isTestingInProgress = false
    private var shouldMeasureDownloadSpeed = true
    private var shouldMeasureUploadSpeed = true

    override func viewDidLoad() {
        super.viewDidLoad()

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

extension SpeedViewController: SettingsViewControllerDelegate {
    func setupURL() {
        
    }
    
    
}

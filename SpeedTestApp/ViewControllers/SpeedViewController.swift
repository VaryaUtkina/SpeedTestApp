//
//  ViewController.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 04.04.2024.
//

import UIKit

final class SpeedViewController: UIViewController {
    @IBOutlet var downloadLabel: UILabel!
    @IBOutlet var currentDownloadSpeedLabel: UILabel!
    @IBOutlet var uploadLabel: UILabel!
    @IBOutlet var currentUploadLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    private let serverURL = "https://www.speedtest.net"
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
    
    private func measureDownloadSpeed(completion: @escaping () -> Void) {
        var allDownloadSpeeds: [Double] = []
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [unowned self] timer in
            networkManager.testDownloadSpeed(serverURL: self.serverURL) { speed in
                DispatchQueue.global().async {
                    allDownloadSpeeds.append(speed)
                    
                    DispatchQueue.main.async {
                        self.currentDownloadSpeedLabel.text = String(format: "Current speed: %.2f Mbps", speed)
                    }
                    
                    if allDownloadSpeeds.count == 10 {
                        timer.invalidate()
                        
                        let totalSpeed = allDownloadSpeeds.reduce(0, +)
                        let averageSpeed = totalSpeed / Double(allDownloadSpeeds.count)
                        
                        DispatchQueue.main.async {
                            self.downloadLabel.text = String(format: "Average speed: %.2f Mbps", averageSpeed)
                            self.currentDownloadSpeedLabel.text = "Current speed: -"
                            completion()
                        }
                    }
                }
            }
        }
        timer.fire()
    }
        
    private func measureUploadSpeed(completion: @escaping () -> Void) {
        var allUploadSpeeds: [Double] = []
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [unowned self] timer in
            networkManager.testUploadSpeed(serverURL: self.serverURL) { uploadSpeed in
                DispatchQueue.global().async {
                    allUploadSpeeds.append(uploadSpeed)
                    
                    DispatchQueue.main.async {
                        self.currentUploadLabel.text = String(format: "Current speed: %.2f Mbps", uploadSpeed)
                    }
                    
                    if allUploadSpeeds.count == 10 {
                        timer.invalidate()
                        
                        let totalUploadSpeed = allUploadSpeeds.reduce(0, +)
                        let averageUploadSpeed = totalUploadSpeed / Double(allUploadSpeeds.count)
                        
                        DispatchQueue.main.async {
                            self.uploadLabel.text = String(format: "Average speed: %.2f Mbps", averageUploadSpeed)
                            self.currentUploadLabel.text = "Current speed: -"
                            completion()
                        }
                    }
                }
            }
        }
        timer.fire()
    }
}

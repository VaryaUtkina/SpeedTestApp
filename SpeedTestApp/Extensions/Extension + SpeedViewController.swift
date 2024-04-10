//
//  Extension + SpeedViewController.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 08.04.2024.
//

import UIKit

// реализация измерения скорости
extension SpeedViewController {
    func measureDownloadSpeed(completion: @escaping (Bool) -> Void) {
        var allDownloadSpeeds: [Double] = []
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [unowned self] timer in
            networkManager.testDownloadSpeed(serverURL: self.serverURL) { result in
                switch result {
                case .success(let speed):
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
                                completion(true) // вычисление успешно завершено
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async { [ unowned self ] in
                        showAlert(withStatus: error)
                        timer.invalidate()
                        completion(false) // обнаружена ошибка
                    }
                }
            }
        }
        timer.fire()
    }
        
    func measureUploadSpeed(completion: @escaping (Bool) -> Void) {
        var allUploadSpeeds: [Double] = []
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [unowned self] timer in
            networkManager.testUploadSpeed(serverURL: self.serverURL) { result in
                switch result {
                case .success(let uploadSpeed):
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
                                completion(true) // вычисление успешно завершено
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async { [ unowned self ] in
                        showAlert(withStatus: error)
                        timer.invalidate()
                        completion(false) // обнаружена ошибка
                    }
                }
            }
        }
        timer.fire()
    }
}

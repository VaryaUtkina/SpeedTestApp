//
//  NetworkManager.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 07.04.2024.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func testDownloadSpeed(serverURL: String, completion: @escaping (Double) -> Void) {
        AF.request(serverURL).response { response in
            if let data = response.data, let _ = String(data: data, encoding: .utf8) {
                let contentLength = Double(response.response?.expectedContentLength ?? 0)
                let totalTime = Double(response.metrics?.taskInterval.duration ?? 0)
                let speed = contentLength / totalTime / 1_024 / 1_024
                completion(speed)
            }
        }
    }
    
    func testUploadSpeed(serverURL: String, completion: @escaping (Double) -> Void) {
        let parameters = ["data": Data(count: 1024)] // Отправляем 1 КБ данных
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(parameters["data"]!, withName: "data")
        },
                  to: serverURL).response { response in
            if let error = response.error {
                print("Upload Error: \(error)")
                completion(0.0) // В случае ошибки, возвращаем 0 скорость загрузки
                return
            }
            
            if let data = response.data {
                let uploadTime = Double(response.metrics?.taskInterval.duration ?? 0)
                let uploadSpeed = Double(data.count) / uploadTime / 1024 / 1024
                completion(uploadSpeed)
            }
        }
    }
}

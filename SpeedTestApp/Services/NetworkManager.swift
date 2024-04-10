//
//  NetworkManager.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 07.04.2024.
//

import Alamofire
import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // функция по вычислению скорости загрузки
    func testDownloadSpeed(
        serverURL: String,
        completion: @escaping (Result<Double, Alert>) -> Void
    ) {
        // проверка url
        guard let url = URL(string: serverURL) else {
            // при обнаружении ошибки передаем ее в completion
            completion(.failure(.invalidURL))
            return
        }
        
        // отправляем запрос, используя Alamofire
        AF.request(serverURL).response { response in
            if let data = response.data, let _ = String(data: data, encoding: .utf8) {
                let contentLength = Double(response.response?.expectedContentLength ?? 0)
                let totalTime = Double(response.metrics?.taskInterval.duration ?? 0)
                let speed = contentLength / totalTime / 1_024 / 1_024
                // в случае получения расчетов, передаем их в completion
                completion(.success(speed))
            }
        }
    }
    
    // функция по вычислению скорости отдачи
    func testUploadSpeed(
        serverURL: String,
        completion: @escaping (Result<Double, Alert>) -> Void
    ) {
        // проверка url
        guard let url = URL(string: serverURL) else {
            // при обнаружении ошибки передаем ее в completion
            completion(.failure(.invalidURL))
            return
        }
        
        let parameters = ["data": Data(count: 1024)] // Отправляем 1 КБ данных
        
        // загружаем данные, используя Alamofire
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(parameters["data"]!, withName: "data")
        },
                  to: serverURL).response { response in
            if let error = response.error {
                print("Upload Error: \(error)")
                // при обнаружении ошибки передаем ее в completion
                completion(.failure(.uploadError))
                return
            }
            
            if let data = response.data {
                let uploadTime = Double(response.metrics?.taskInterval.duration ?? 0)
                let uploadSpeed = Double(data.count) / uploadTime / 1024 / 1024
                // в случае получения расчетов, передаем их в completion
                completion(.success(uploadSpeed))
            }
        }
    }
}

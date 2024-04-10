//
//  StorageManager.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 10.04.2024.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Data")

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        }

        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func create(_ download: Bool, _ upload: Bool, _ url: String, _ theme: String, completion: (Speed) -> Void) {
        let data = Speed(context: viewContext)
        data.download = download
        data.upload = upload
        data.url = url
        data.theme = theme
        completion(data)
        saveContext()
    }
    
    func fetchData(completion: (Result<[Speed], Error>) -> Void) {
        let fetchRequest = Speed.fetchRequest()
        
        do {
            let data = try viewContext.fetch(fetchRequest)
            completion(.success(data))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

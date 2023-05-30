//
//  GeneratedImagesLocalService.swift
//  image-generator
//
//  Created by Alexey Zubkov on 30.05.2023.
//

import CoreData

protocol IGeneratedImagesLocalService: AnyObject {
    func isModelSaved(_ model: GeneratedImageModel) -> Bool
    func isModelSaved(_ requestBaseUrl: String) -> Bool
    func save(_ model: GeneratedImageModel, _ completion: @escaping (Result<Void, LocalStorageError>) -> Void)
    func fetchData(_ completion: @escaping (Result<[GeneratedImageModel], LocalStorageError>) -> Void)
    func deleteData(with model: GeneratedImageModel, _ completion: @escaping (Result<Void, LocalStorageError>) -> Void)
}

final class GeneratedImagesLocalService: IGeneratedImagesLocalService {

    // MARK: Dependencies

    private lazy var persistentContainer = makePersistentContainer()
    private lazy var context = makeContext()
    private lazy var fetchRequest = GeneratedImage.fetchRequest()

    // MARK: IGeneratedImagesLocalService

    func isModelSaved(_ model: GeneratedImageModel) -> Bool {
        isModelSaved(model.request.baseUrl)
    }
    
    func isModelSaved(_ requestBaseUrl: String) -> Bool {
        if let count = count(with: NSPredicate(format: "requestBaseURL = %@", requestBaseUrl)),
           count > 0 {
            return true
        }
        return false
    }
    
    func save(_ model: GeneratedImageModel, _ completion: @escaping (Result<Void, LocalStorageError>) -> Void) {
        if isModelSaved(model) {
            completion(.failure(.unableToSaveData))
            return
        }
        if count() == Constants.maxCountOfSavedModels {
            deleteTheOldestData()
        }
        guard let entity = NSEntityDescription.entity(
            forEntityName: String(describing: GeneratedImage.self),
            in: context
        ) else {
            completion(.failure(.unableToSaveData))
            return
        }
        let object = GeneratedImage(entity: entity, insertInto: context)
        object.imageData = model.imageData
        object.requestBaseURL = model.request.baseUrl
        
        saveContext { result in
            completion(result)
        }
    }
    
    func fetchData(_ completion: @escaping (Result<[GeneratedImageModel], LocalStorageError>) -> Void) {
        fetch { result in
            switch result {
            case .success(let response):
                var data = [GeneratedImageModel]()
                response.forEach {
                    guard let imageData = $0.imageData,
                          let requestBaseUrl = $0.requestBaseURL else {
                        return
                    }
                    let generatedImageModel = GeneratedImageModel(
                        uuid: UUID(),
                        imageData: imageData,
                        request: ImageGenerationRequest(baseUrl: requestBaseUrl)
                    )
                    data.append(generatedImageModel)
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteData(with model: GeneratedImageModel, _ completion: @escaping (Result<Void, LocalStorageError>) -> Void) {
        fetchRequest.predicate = NSPredicate(format: "requestBaseURL = %@", model.request.baseUrl)
        guard let objects = try? context.fetch(fetchRequest) else {
            completion(.failure(.unableToDeleteData))
            return
        }
        for object in objects {
            context.delete(object)
        }
        saveContext(completion)
    }
}

// MARK: - Private API

private extension GeneratedImagesLocalService {
    
    func fetch(_ completion: @escaping (Result<[GeneratedImage], LocalStorageError>) -> Void) {
        if count() == 0 {
            completion(.success([]))
            return
        }
        fetchRequest.predicate = nil
        do {
            let data = try context.fetch(fetchRequest)
            completion(.success(data))
        } catch {
            completion(.failure(.unableToFetchData))
        }
    }
    
    func count(with predicate: NSPredicate? = nil) -> Int? {
        fetchRequest.predicate = predicate
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch(let error) {
            print("Unable to count \(GeneratedImage.self) entities in LocalStorage (error = \(error))")
            return nil
        }
    }
    
    func saveContext(_ completion: ((Result<Void, LocalStorageError>) -> Void)? = nil) {
        guard context.hasChanges else {
            completion?(.failure(.unableToSaveData))
            return
        }
        do {
            try context.save()
            completion?(.success(Void()))
        } catch {
            context.rollback()
            completion?(.failure(.unableToSaveData))
        }
    }

    func deleteTheOldestData() {
        guard let objects = try? context.fetch(fetchRequest),
              let theOldestObject = objects.first else {
            return
        }
        context.delete(theOldestObject)
        saveContext()
    }
}

// MARK: - Factory methods

private extension GeneratedImagesLocalService {
    
    func makePersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "image_generator")
        container.loadPersistentStores { _, error in
            guard let error = error else {
                return
            }
            fatalError("Unable to load persistent stores in LocalStorage with error = \(error)")
        }
        return container
    }
    
    func makeContext() -> NSManagedObjectContext {
        persistentContainer.viewContext
    }
}


// MARK: - Constants

private extension GeneratedImagesLocalService {
    
    enum Constants {
        static let maxCountOfSavedModels = 15
    }
}

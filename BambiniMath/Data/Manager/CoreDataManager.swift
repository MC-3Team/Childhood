//
//  CoreDataManager.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import CoreData

class CoreDataManager: DataService {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func insertAllData(object: Objects) {
        viewContext.insert(object)
        saveContext()
    }

    func getQuestionByObjectId(objectId: Int) -> [Question] {
        let fetchRequest: NSFetchRequest<Objects> = Objects.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", objectId)
        do {
            if let object = try viewContext.fetch(fetchRequest).first {
                return object.questions?.allObjects as? [Question] ?? []
            } else {
                return []
            }
        } catch {
            print("Failed to fetch questions: \(error)")
            return []
        }
    }
    
    func updateQuestionisUsed(question: Question, isUsed: Bool) {
        question.isUsed = isUsed
        saveContext()
    }

    func updateObjectisComplete(object: Objects, isComplete: Bool) {
        object.isComplete = isComplete
        saveContext()
    }

    func updateObjectOnGoing(object: Objects, onGoing: Bool) {
        object.onGoing = onGoing
        saveContext()
    }

    func updateObjectCurrentQuestion(object: Objects, currentQuestion: Int) {
        object.currentQuestion = Int64(currentQuestion)
        saveContext()
    }

    func updateObjectIndexBreakdown(object: Objects, indexBreakdown: Int) {
        object.indexBreakdown = Int64(indexBreakdown)
        saveContext()
    }

    func updateObjectHealth(object: Objects, health: Int) {
        object.health = Int64(health)
        saveContext()
    }

    func printHello() {
        print("Hello World")
    }
    
    private func saveContext() {
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

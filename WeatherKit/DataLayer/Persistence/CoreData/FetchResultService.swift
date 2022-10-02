//
//  FetchResultService.swift
//  WeatherKit
//
//  Created by Павел Барташов on 09.09.2022.
//

import CoreData
import Combine

//public enum FetchResultServiceState {
//    case initial
//    case willChangeContent
//    case insert(at: IndexPath)
//    case update(at: IndexPath)
//    case move(from: IndexPath, to: IndexPath)
//    case delete(at: IndexPath)
//    case didChangeContent
//}

//https://www.mattmoriarity.com/observing-core-data-changes-with-combine/creating-pipelines/
final class FetchResultService: NSObject, NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    private let onObjectsChange = CurrentValueSubject<[NSFetchRequestResult], Never>([])

//    var sections: AnyPublisher<[NSFetchedResultsSectionInfo], Never> {
//        onObjectsChange.eraseToAnyPublisher()
//    }
    var objects: AnyPublisher<[NSFetchRequestResult], Never> {
        onObjectsChange.eraseToAnyPublisher()
    }

//    @Published public var state: FetchResultServiceState = .initial
//    var stateChanged: ((FetchResultServiceState) -> Void)?
//    private var state: FetchResultServiceState? {
//        didSet {
//            if let state = state {
//                stateChanged?(state)
//            }
//        }
//    }



    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private let context: NSManagedObjectContext

//    var results: [NSFetchRequestResult]? {
//        fetchedResultsController?.fetchedObjects
//    }


    // MARK: - LifeCicle

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Metods

    private func sendCurrentObjects() {
        onObjectsChange.send(fetchedResultsController?.fetchedObjects ?? [])



        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    func startFetching(with request: NSFetchRequest<NSFetchRequestResult>,
                       sectionNameKeyPath: String? = nil) throws {
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: sectionNameKeyPath,
                                                              cacheName: nil)
        controller.delegate = self

        do {
            try controller.performFetch()
        } catch {
            throw DatabaseError.error(desription: "Failed to fetch entities: \(error)")
        }

        fetchedResultsController = controller

        sendCurrentObjects()
    }

    // MARK: - NSFetchedResultsControllerDelegate

//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        state = .willChangeContent
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange anObject: Any,
//                    at indexPath: IndexPath?,
//                    for type: NSFetchedResultsChangeType,
//                    newIndexPath: IndexPath?) {
//
//        switch type {
//            case .insert:
//                if let indexPath = newIndexPath {
//                    state = .insert(at: indexPath)
//                }
//
//            case .update:
//                if let indexPath = indexPath {
//                    state = .update(at: indexPath)
//                }
//
//            case .move:
//                if let indexPath = indexPath,
//                   let newIndexPath = newIndexPath {
//                    state = .move(from: indexPath, to: newIndexPath)
//                }
//
//            case .delete:
//                if let indexPath = indexPath {
//                    state = .delete(at: indexPath)
//                }
//
//            @unknown default:
//                break
//        }
//    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sendCurrentObjects()

        print("🍏 controllerDidChangeContent")
        //        state = .didChangeContent
    }
}

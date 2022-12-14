//
//  DatabaseError.swift
//  WeatherKit
//
//  Created by Павел Барташов on 28.08.2022.
//

import Foundation

//https://github.com/tfsaidov/DatabaseDemo/tree/CoreData
enum DatabaseError: Error {
    /// Невозможно добавить данные в хранилище.
    case store(model: String)
    /// Не найдена модель объекта.
    case invalidManagedObjectType
    /// Кастомная ошибка.
    case error(desription: String)
    /// Объект не найден.
    case notFound
    /// Неизвестная ошибка.
    case unknown(error: Error)
}

extension DatabaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .store(let model):
                return NSLocalizedString("Невозможно добавить данные в хранилище: \(model).", comment: "")

            case .invalidManagedObjectType:
                return NSLocalizedString("Не найдена модель объекта.", comment: "")

            case .error(let description):
                return NSLocalizedString(description, comment: "")

            case .notFound:
                return NSLocalizedString("Объект не найден", comment: "")

            case .unknown(let error as LocalizedError):
                return error.errorDescription

            case .unknown(error: let error):
                return NSLocalizedString(error.localizedDescription, comment: "")
        }
    }
}

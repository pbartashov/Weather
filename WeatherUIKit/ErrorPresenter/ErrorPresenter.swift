//
//  ErrorPresenter.swift
//  Weather
//
//  Created by Павел Барташов on 25.09.2022.
//

import UIKit

public final class ErrorPresenter {
    
    //MARK: - Properties
    
    public static let shared = ErrorPresenter()
    
    private weak var presenter: UIViewController?
    
    private var errorQueue: [Error] = []
    private var isErrorPresenting = false
    
    //MARK: - LifeCicle
    
    private init() { }
    
    public func initialize(with presenter: UIViewController) {
        self.presenter = presenter
    }
    
    //MARK: - Metods
    
    public func show(error: Error) {
        guard presenter != nil else {
            preconditionFailure("ErrorPresenter not initialized")
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.isErrorPresenting == true {
                self.errorQueue.append(error)
            } else {
                self.isErrorPresenting = true
                
                let alert = UIAlertController(title: error.localizedDescription,
                                              message: nil,
                                              preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ясно", style: .default) { [weak self] _ in
                    self?.isErrorPresenting = false
                    if let nextError = self?.errorQueue.popLast() {
                        DispatchQueue.main.async {
                            self?.show(error: nextError)
                        }
                        
                    }
                }
                alert.addAction(cancelAction)
                
                if let presented = self.presenter?.presentedViewController {
                    if presented.isBeingPresented {
                        presented.present(alert, animated: true)
                    } else {
                        self.isErrorPresenting = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.show(error: error)
                        }
                    }
                    return
                }
                
                self.presenter?.present(alert, animated: true)
            }
        }
    }
}

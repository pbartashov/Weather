//
//  OnboardingViewModel.swift
//  WeatherKit
//
//  Created by Павел Барташов on 10.10.2022.
//


public struct OnboardingViewModel {
    public let imageName: String = "Logo"
    public let title: String = "Разрешить приложению  Weather использовать данные\nо местоположении вашего устройства"
    public let text: String = "Чтобы получить более точные прогнозы погоды во время движения или путешествия"
    public let secondaryText: String = "Вы можете изменить свой выбор в любое время из меню приложения"

    public let yesButtonText = "ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ  УСТРОЙСТВА"
    public let noButtonText = "НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ"

    public init() { }

//    init(imageName: String,
//         title: String,
//         text: String,
//         secondaryText: String,
//         yesButtonText: String,
//         noButtonText: String
//    ) {
//        self.imageName = imageName
//        self.title = title
//        self.text = text
//        self.yesButtonText
//        self.noButtonText = noButtonText
//    }
}


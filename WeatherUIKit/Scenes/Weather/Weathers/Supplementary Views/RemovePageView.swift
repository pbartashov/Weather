//
//  RemovePageView.swift
//  WeatherUIKit
//
//  Created by Павел Барташов on 17.10.2022.
//

import UIKit
import Combine

final class RemovePageView: UICollectionReusableView {
    enum Button {
        case remove
    }

    // MARK: - Properties

    var buttonTappedPublisher: AnyPublisher<Button, Never> {
        removeButton.tappedPublisher
    }

    // MARK: - Views

    private lazy var removeButton: PublishedButton<Button> = {
        let button = PublishedButton(publishedValue: Button.remove)
        button.setTitle("Удалить вкладку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)

        return button
    }()

    // MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {
        addSubview(removeButton)

        setupLayouts()
    }

    private func setupLayouts() {
        removeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//
//  OnboardingView.swift
//  Weather
//
//  Created by Павел Барташов on 15.09.2022.
//

import UIKit
import SnapKit
import WeatherKit

final class OnboardingView: UIView {



    // MARK: - Properties

    private let onboardingResponder: OnboardingResponder

    // MARK: - Views
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never

        return scrollView
    }()

    private let logoView: UIImageView = {
//        let image = UIImage(named: "Logo")
//        let imageView = UIImageView(image: image)

        return UIImageView()
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private let secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    private lazy var yesButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)

        button.backgroundColor = .brandOrange
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true

        button.addTarget(onboardingResponder,
                         action: #selector(OnboardingResponder.locationAccessGranted),
                         for: .touchUpInside)

        return button
    }()

    private lazy var noButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)

        button.addTarget(onboardingResponder,
                         action: #selector(OnboardingResponder.locationAccessDenied),
                         for: .touchUpInside)

        return button
    }()

    // MARK: - LifeCicle

    init(onboardingResponder: OnboardingResponder) {
        self.onboardingResponder = onboardingResponder
        super.init(frame: .zero)

        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    private func initialize() {

        addSubview(scrollView)

        [logoView,
         titleLabel,
         textLabel,
         secondaryTextLabel,
         yesButton,
         noButton

        ].forEach {
            scrollView.addSubview($0)
        }

        setupLayouts()

//        setupView()
    }

    private func setupLayouts() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.width.equalTo(scrollView.contentLayoutGuide)
            #warning("need???")
        }





//        scrollView.backgroundColor = .green

        logoView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(148)
            make.top.equalTo(scrollView.contentLayoutGuide).offset(148)
            make.centerX.equalTo(scrollView.contentLayoutGuide.snp.centerX).offset((111 - 84) / 2)
//            make.centerX.equalToSuperview().offset((111 - 84) / 2)
//
//            make.bottom.equalTo(scrollView.contentLayoutGuide).offset(-77)
//
////            make.leading.greaterThanOrEqualToSuperview().offset(111)
////            make.trailing.greaterThanOrEqualToSuperview().offset(-84)
////            make.leading.equalToSuperview()..multipliedBy(1)
////            make.trailing.equalTo(self.snp.trailing).multipliedBy(1 - 84.0 / Constants.Design.width)
//
            make.width.equalTo(180)
            make.height.equalTo(196)

//            make.width.equalTo()
//            make.height.equalTo(196)


//            make.leading.equalTo(self.snp.trailing).multipliedBy(111.0 / Constants.Design.width)
//            make.height.equalTo(logoView.snp.width).multipliedBy(196 / 180)

        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(56)
            make.centerX.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(322)
            make.height.equalTo(63)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(56)
            make.centerX.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(314)
            make.height.equalTo(36)
        }

        secondaryTextLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(14)
            make.centerX.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(314)
            make.height.equalTo(36)
        }

        yesButton.snp.makeConstraints { make in
            make.top.equalTo(secondaryTextLabel.snp.bottom).offset(44)
            make.centerX.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(340)
            make.height.equalTo(40)
        }

        noButton.snp.makeConstraints { make in
            make.top.equalTo(yesButton.snp.bottom).offset(25)
            make.trailing.equalTo(yesButton)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView.contentLayoutGuide).offset(-77)
        }


    }

    func setupView(with viewModel: OnboardingViewModel) {

        logoView.image = UIImage(named: viewModel.imageName)

        titleLabel.text = viewModel.title
        textLabel.text = viewModel.text
        secondaryTextLabel.text = viewModel.secondaryText

        yesButton.setTitle(viewModel.yesButtonText, for: .normal)
        noButton.setTitle(viewModel.noButtonText, for: .normal)

//        scrollView.scrollRectToVisible(self.frame, animated: true)

    }
}




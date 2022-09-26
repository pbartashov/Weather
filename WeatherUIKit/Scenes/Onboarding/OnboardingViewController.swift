//
//  OnboardingViewController.swift
//  Weather
//
//  Created by Павел Барташов on 15.09.2022.
//

import UIKit

final class OnboardingViewController: UIViewController {

    // MARK: - Properties

    // MARK: - Views

    // MARK: - LifeCicle

    override func loadView() {
        view = OnboardingView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .brandBlue
        
//        let onboardingView = OnboardingView()
//        view.addSubview(onboardingView)
//
//        onboardingView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        setupViewModel()
        // Do any additional setup after loading the view.
    }



    // MARK: - Metods

    private func setupViewModel() {

    }
    

}

#warning("Readme")

//
//  SettingsViewController.swift
//  Weather
//
//  Created by Павел Барташов on 17.09.2022.
//

import UIKit

final class SettingsViewController: UIViewController {


    // MARK: - Properties

    // MARK: - Views

    // MARK: - LifeCicle

    override func loadView() {
        view = SettingsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .brandBlue
        
        setupViewModel()
        // Do any additional setup after loading the view.
    }



    // MARK: - Metods

    private func setupViewModel() {

    }


}

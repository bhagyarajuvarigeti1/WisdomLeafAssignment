//
//  SplashScreenViewController.swift
//  WisdomLeafAssignment
//
//  Created by bhagyaraju on 05/09/24.
//

import Foundation
import UIKit

// MARK: - SplashScreenViewController
class SplashScreenViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = SplashScreenViewModel()
    
    // MARK: - @IBOutlets
    @IBOutlet weak var splashScreenImageView: UIImageView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        setupView()
        
        // Bind ViewModel
        bindViewModel()
        
        // Start the delay
        viewModel.startDelay()
    }
    
    // MARK: - Methods
    private func setupView() {
        self.view.backgroundColor = .black
        splashScreenImageView.image = UIImage(named: "wisdomLeafLogo")
    }
    
    private func bindViewModel() {
        viewModel.onTransition = { [weak self] in
            self?.showInitialViewController()
        }
    }
    
    private func showInitialViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialViewController")
        let navigationController = UINavigationController(rootViewController: initialViewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        self.present(navigationController, animated: true, completion: nil)
    }
}


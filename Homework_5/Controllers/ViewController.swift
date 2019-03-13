//
//  ViewController.swift
//  Homework_5
//
//  Created by Aleksandr Avdukich on 10/03/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private var dataManager: ProfileDataManagerDelegate?
    
    
    // MARK: - Outlets

    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    
    // MARK: - Private
    
    private func configureView() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 45
        
        editButton.clipsToBounds = true
        editButton.layer.cornerRadius = 10
//        editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        
        activityController.isHidden = true
      
        dataManager = GCDDataManager()
    }
    
//    @objc private func handleEdit() {
//        UIView.animate(withDuration: 0.10, animations: { [weak self] in
//            guard let self = self else { return }
//            self.editButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        }) { (_) in
//            UIView.animate(withDuration: 0.10, animations: { [weak self] in
//                guard let self = self else { return }
//                self.editButton.transform = CGAffineTransform.identity
//                }, completion: { (_) in
//                    let editController = EditProfileViewController()
//                    self.present(editController, animated: true, completion: nil)
//            })
//        }
//    }
    
    private func loadData() {
        self.activityController.isHidden = false
        self.activityController.startAnimating()
        self.dataManager?.loadProfileInfo(isDone: { [weak self] (profile) in
            guard let self = self else { return }
            
            if let profile = profile {
                self.nameLabel.text = profile["name"]
                self.aboutLabel.text = profile["description"]
                let dataDecoded: Data = Data(base64Encoded: profile["photo"]!, options: .ignoreUnknownCharacters)!
                self.profileImageView.image = UIImage(data: dataDecoded)
            }
          
          self.activityController.stopAnimating()
          self.activityController.isHidden = true
        })
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue" {
            guard let editController = segue.destination as? EditProfileViewController else { return }
            editController.name = nameLabel.text
            editController.about = aboutLabel.text
            editController.image = profileImageView.image
        }
    }
}

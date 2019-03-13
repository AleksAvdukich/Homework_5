//
//  EditProfileViewController.swift
//  Homework_5
//
//  Created by Aleksandr Avdukich on 10/03/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit
import AVKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var isPhotoEdited: Bool = false
    private var dataManager: ProfileDataManagerDelegate?
    var name: String?
    var about: String?
    var image: UIImage?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Actions
    
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Выберите изображение профиля", message: nil, preferredStyle: .actionSheet)
        
        let choiseImage = UIAlertAction(title: "Установить из галереи", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.chooseImagePickerAction(source: UIImagePickerController.SourceType.photoLibrary)
        }
        let doPhoto = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.chooseImagePickerAction(source: UIImagePickerController.SourceType.camera)
        }
        let deletePhoto = UIAlertAction(title: "Удалить фото", style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
            self.profileImageView.image = UIImage(named: "user")
            self.isPhotoEdited = false
            let buttonsArray: [UIButton] = [self.gcdButton, self.operationButton]
            for item in buttonsArray {
                item.backgroundColor = .lightGray
                item.isEnabled = false
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(choiseImage)
        alertController.addAction(doPhoto)
        if profileImageView.image != UIImage(named: "user") {
            alertController.addAction(deletePhoto)
        }
        
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func nameTextFieldEdited(_ sender: UITextField) {
        let buttonsArray: [UIButton] = [self.gcdButton, self.operationButton]
        
        if isPhotoEdited && sender.text != "" {
            for item in buttonsArray {
                item.backgroundColor = #colorLiteral(red: 0.9989228845, green: 0.8825955987, blue: 0.219720602, alpha: 1)
                item.isEnabled = true
            }
        } else {
            for item in buttonsArray {
                item.backgroundColor = .lightGray
                item.isEnabled = false
            }
        }
    }
    
    @IBAction func gcdButtonTapped(_ sender: UIButton) {
        self.viewIsEnabled()
        
        dataManager = GCDDataManager()
        
        if let name = nameTextField.text,
            !name.isEmpty {
            self.dataManager?.saveProfileInfo(name: self.nameTextField.text!, description: self.aboutTextView.text!, photo: convertImageToString(), isDone: { [weak self] (error) in
                guard let self = self else { return }
                
                if error {
                    self.profileIsNotSaved()
                } else {
                    self.profileWasSaved()
                }
            })
        } else {
            self.viewIsAble()
            
            let alert = UIAlertController(title: nil, message: "Пожалуйста, заполните все поля", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func operationButtonTapped(_ sender: UIButton) {
        self.viewIsEnabled()
        
        dataManager = OperationDataManager()
        
        if let name = nameTextField.text,
            !name.isEmpty {
            self.dataManager?.saveProfileInfo(name: self.nameTextField.text!, description: self.aboutTextView.text!, photo: convertImageToString(), isDone: { [weak self] (error) in
                guard let self = self else { return }
                
                if error {
                    self.profileIsNotSaved()
                } else {
                    self.profileWasSaved()
                }
            })
        } else {
            self.viewIsAble()
            
            let alert = UIAlertController(title: nil, message: "Пожалуйста, заполните все поля", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Private
    
    private func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            print("Приложение запускается на реальном устройстве или на симуляторе (когда выбирается бибилиотека)")
            
            if source == .camera {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in // Проверка на то, дал ли пользователь разрешение на доступ к камере или нет.
                    if response {
                        self.createImagePicker(source: source)
                    } else {
                        self.alertCameraAction()
                    }
                }
            } else {
                createImagePicker(source: source)
            }
        } else {
            print("Приложение запускается на симуляторе")
            
            alertCameraAction()
        }
    }
    
    private func createImagePicker(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func alertCameraAction() {
        let alertController = UIAlertController(title: "Доступ к камере запрещён", message: "Чтобы сделать фотографию, необходимо разрешить доступ к камере в настройках приложения", preferredStyle: .alert)
        
        let openSetting = UIAlertAction(title: "Открыть настройки", style: .default) { (_) in
            if let url = URL(string: UIApplication.openSettingsURLString) as URL? {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(openSetting)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func convertImageToString() -> String {
        let image = profileImageView.image
        let imageData = image!.pngData()
        let str = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        return str!
    }
    
    func profileIsNotSaved() {
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
        
        let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при сохранении данных", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let retry = UIAlertAction(title: "Повторить", style: .default, handler: { (action) in
            self.dataManager?.saveProfileInfo(name: self.nameTextField.text!, description: self.aboutTextView.text!, photo: self.convertImageToString(), isDone: { (error) in
                if error {
                    self.profileIsNotSaved()
                } else {
                    self.profileWasSaved()
                }
            })
        })
        
        alert.addAction(cancel)
        alert.addAction(retry)
        self.present(alert, animated: true, completion: nil)
    }
    
    func profileWasSaved() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        
        self.nameTextField.isEnabled = true
        self.aboutTextView.isSelectable = true
        self.aboutTextView.isEditable = true
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
        
        let alert = UIAlertController(title: nil, message: "Данные сохранены", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func viewIsEnabled() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.nameTextField.isEnabled = false
        self.aboutTextView.isSelectable = false
        self.aboutTextView.isEditable = false
        self.gcdButton.isEnabled = false
        self.operationButton.isEnabled = false
    }
    
    private func viewIsAble() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        self.nameTextField.isEnabled = true
        self.aboutTextView.isSelectable = true
        self.aboutTextView.isEditable = true
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
    }
    
    
    // MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.editedImage] as? UIImage
        setImageInProfileImageView(selectedImage: selectedImage!)
        self.isPhotoEdited = true
        let buttonsArray: [UIButton] = [self.gcdButton, self.operationButton]
        for item in buttonsArray {
            item.backgroundColor = #colorLiteral(red: 0.9989228845, green: 0.8825955987, blue: 0.219720602, alpha: 1)
            item.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func setImageInProfileImageView(selectedImage: UIImage) {
        profileImageView.image = selectedImage
        profileImageView.contentMode = .scaleToFill
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    
    // MARK: - Private
    
    private func configureView() {
        activityIndicator.isHidden = true
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 45
        
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 45
        
        profileImageView.image = image
        nameTextField.text = name
        aboutTextView.text = about
        
        let buttonsArray: [UIButton] = [gcdButton, operationButton]
        for item in buttonsArray {
            item.clipsToBounds = true
            item.layer.cornerRadius = 10
            item.isEnabled = false
            item.backgroundColor = .lightGray
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        
        let buttonsArray: [UIButton] = [gcdButton, operationButton]
        if nameTextField.text != name || aboutTextView.text != about || isEditing {
            for item in buttonsArray {
                item.backgroundColor = #colorLiteral(red: 0.9989228845, green: 0.8825955987, blue: 0.219720602, alpha: 1)
                item.isEnabled = true
            }
        } else {
            for item in buttonsArray {
                item.backgroundColor = .lightGray
                item.isEnabled = false
            }
        }
    }
}

//
//  ViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class AddNewCarViewController: UIViewController {
    
    @IBOutlet private(set) weak var carImage: UIImageView!
    @IBOutlet private(set) weak var brandTextField: UITextField!
    @IBOutlet private(set) weak var modelTextField: UITextField!
    @IBOutlet private(set) weak var descriptionTextField: UITextView!
    @IBOutlet private(set) weak var releaseDateTextField: UITextField! {
        didSet {
            releaseDateTextField.inputView = datePicker
        }
    }
    
    weak var delegate: AddNewCarDelegate?
    weak var editedCar: Car?
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        return imagePicker
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self,
                             action: #selector(self.datePickerChanged),
                             for: .valueChanged)
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCarForEdit()
    }
    
    func loadCarForEdit() {
        if let editedCar = editedCar {
            brandTextField.text = editedCar.brand
            modelTextField.text = editedCar.model
            releaseDateTextField.text = dateFormat.string(from: editedCar.releaseDate)
            descriptionTextField.text = editedCar.description
            carImage.image = editedCar.image
        }
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        releaseDateTextField.text = dateFormat.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func onTouchSaveData(_ sender: UIButton) {
        
        guard let brand = brandTextField.text, !brand.isEmpty else {
            showAlert(with: "Fill brand")
            return
        }
        
        guard let model = modelTextField.text, !model.isEmpty else {
            showAlert(with: "Fill model")
            return
        }
        
        guard let releaseDate = dateFormat.date(from: releaseDateTextField.text!) else {
            showAlert(with: "Fill release date")
            return
        }
        
        var descriptionText: String?
        if let description = descriptionTextField.text, !description.isEmpty {
            descriptionText = description
        }

        if let editedCar = editedCar {
            editedCar.brand = brand
            editedCar.model = model
            editedCar.releaseDate = releaseDate
            editedCar.description = descriptionText
            editedCar.image = carImage.image!
            delegate?.refreshList()
        } else {
            let car = Car(brand: brand,
                          model: model,
                          releaseDate: releaseDate,
                          description: descriptionText,
                          image: carImage.image!)
            delegate?.onCreatedNew(car: car)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func choosePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePicker, animated: true)
        }
    }
    
}

extension UIViewController {
    
    func showAlert(with title: String) {
        let alert = UIAlertController(title: "Error",
                                      message: title,
                                      preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(actionOk)
        present(alert, animated: true)
    }
    
}

extension AddNewCarViewController: UINavigationControllerDelegate { }

extension AddNewCarViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageFromGallery = info[UIImagePickerControllerOriginalImage] as? UIImage
        carImage.image = imageFromGallery
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}


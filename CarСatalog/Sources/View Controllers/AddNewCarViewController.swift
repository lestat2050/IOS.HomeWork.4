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
    weak var carForEdit: Car?
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        return imagePicker
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self,
                             action: #selector(AddNewCarViewController.datePickerChanged),
                             for: .valueChanged)
        return datePicker
    }()
    
    private lazy var dateFormat: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        return dateFormat
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCarForEdit()
    }
    
    func loadCarForEdit() {
        if let carForEdit = carForEdit {
            brandTextField.text = carForEdit.brand
            modelTextField.text = carForEdit.model
            releaseDateTextField.text = dateFormat.string(from: carForEdit.releaseDate)
            descriptionTextField.text = carForEdit.description
            if let image = carForEdit.image {
                carImage.image = image
            }
        }
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        releaseDateTextField.text = dateFormat.string(from: sender.date)
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
        
        var newCarImage: UIImage?
        if let image = carImage.image {
            newCarImage = image
        }

        if let carForEdit = carForEdit {
            carForEdit.brand = brand
            carForEdit.model = model
            carForEdit.releaseDate = releaseDate
            carForEdit.description = descriptionText
            carForEdit.image = newCarImage
            delegate?.refreshList()
        } else {
            let car = Car(brand: brand,
                          model: model,
                          releaseDate: releaseDate,
                          description: descriptionText,
                          image: newCarImage)
            delegate?.onCreatedNew(car: car)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
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
        present(alert, animated: true, completion: nil)
    }
    
}

extension AddNewCarViewController: UINavigationControllerDelegate { }

extension AddNewCarViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        carImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


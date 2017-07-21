//
//  ViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class AddNewCarVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    var carForEdit: Car?
    
    private let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    /*do not work datePickerChanged
    var datePicker: UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }
    */
    
    private var dateFormat: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        return dateFormat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        
        if let carForEdit = carForEdit {
            brandTextField.text = carForEdit.brand
            modelTextField.text = carForEdit.model
            releaseDateTextField.text = dateFormat.string(from: carForEdit.releaseDate)
            descriptionTextField.text = carForEdit.description
        }
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
        
        let descriptionText: String
        if let description = descriptionTextField.text, !description.isEmpty {
            descriptionText = description
        } else {
            descriptionText = ""
        }

        if let carForEdit = carForEdit {
            carForEdit.brand = brand
            carForEdit.model = model
            carForEdit.releaseDate = releaseDate
            carForEdit.description = descriptionText
            delegate?.refreshCarList()
        } else {
            let car = Car(brand: brand, model: model, releaseDate: releaseDate, description: descriptionText)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        carImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(with title: String) {
        let alert = UIAlertController(title: "Error", message: title, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(actionOk)
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker.addTarget(self, action: #selector(AddNewCarVC.datePickerChanged), for: .valueChanged)
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        releaseDateTextField.text = dateFormat.string(from: sender.date)
    }
    
}

extension AddNewCarVC: UITextFieldDelegate {

}


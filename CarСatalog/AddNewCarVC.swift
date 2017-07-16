//
//  ViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class AddNewCarVC: UIViewController, UITextFieldDelegate {

    @IBOutlet private(set) weak var brandTextField: UITextField!
    @IBOutlet private(set) weak var modelTextField: UITextField!
    @IBOutlet private(set) weak var releaseDateTextField: UITextField!
    
    weak var delegate: AddNewCarDelegate?
    var carForEdit: Car?
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let carForEdit = carForEdit {
            dateFormat.dateStyle = .medium
            
            brandTextField.text = carForEdit.brand
            modelTextField.text = carForEdit.model
            releaseDateTextField.text = dateFormat.string(from: carForEdit.releaseDate)
        }
    }

    @IBAction func onTouchSaveData(_ sender: UIButton) {
        var car: Car
        
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
        
        if let carForEdit = carForEdit {
            car = carForEdit
            car.brand = brand
            car.model = model
            car.releaseDate = releaseDate
            delegate?.refreshCarList()
        } else {
            car = Car(brand: brand, model: model, releaseDate: dateFormat.date(from: releaseDateTextField.text!)!)
            delegate?.onCreatedNew(car: car)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert(with title: String) {
        let alert = UIAlertController(title: "Error", message: title, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(actionOk)
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker.datePickerMode = .date
        releaseDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddNewCarVC.datePickerChanged), for: .valueChanged)
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        dateFormat.dateStyle = .medium
        releaseDateTextField.text = dateFormat.string(from: sender.date)
    }
    
}


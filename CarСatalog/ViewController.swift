//
//  ViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var releaseDateTextField: UITextField!
    
    var delegate: AddNewCarDelegate?
    var carForEdit: Car?
    let formatted = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let carForEdit = carForEdit {
            formatted.dateStyle = .medium
            
            brandTextField.text = carForEdit.brand
            modelTextField.text = carForEdit.model
            releaseDateTextField.text = formatted.string(from: carForEdit.releaseDate)
        }
    }

    @IBAction func onTouchSaveData(_ sender: UIButton) {
        var car: Car
        
        guard let brand = brandTextField.text, !brand.isEmpty else {
            return
        }
        
        guard let model = modelTextField.text, !model.isEmpty else {
            return
        }
        
        guard let releaseDate = formatted.date(from: releaseDateTextField.text!) else {
            return
        }
        
        if let carForEdit = carForEdit {
            car = carForEdit
            car.brand = brand
            car.model = model
            car.releaseDate = releaseDate
            delegate?.reloadData()
        } else {
            car = Car(brand: brand, model: model, releaseDate: formatted.date(from: releaseDateTextField.text!)!)
            delegate?.onCreatedNew(car: car)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        releaseDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(ViewController.datePickerChanged), for: .valueChanged)
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        formatted.dateStyle = .medium
        releaseDateTextField.text = formatted.string(from: sender.date)
    }
    
}


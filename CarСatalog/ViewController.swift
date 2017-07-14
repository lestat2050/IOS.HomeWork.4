//
//  ViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    
    var delegate: AddNewCarDelegate?
    var carForEdit: Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let carForEdit = carForEdit {
            brandTextField.text = carForEdit.brand
            modelTextField.text = carForEdit.model
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
        
        if let carForEdit = carForEdit {
            car = carForEdit
            car.brand = brand
            car.model = model
            delegate?.reloadData()
        } else {
            car = Car(brand: brand, model: model, releaseDate: Date())
            delegate?.onCreatedNew(car: car)
        }
        navigationController?.popViewController(animated: true)
    }
    
}


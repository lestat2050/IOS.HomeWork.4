//
//  CarListViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CarListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private(set) weak var carListTableView: UITableView! {
        didSet {
            carListTableView.dataSource = self
            carListTableView.delegate = self
        }
    }
    
    private let addNewCarSegueID = "createNewCarSegue"
    private let editCarSegueID = "editCarSegue"
    private var carList: [Car] = []
    
    private var dateFormat: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        return dateFormat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addListSample()
    }
    
    private func addListSample() {
        if let date1 = dateFormat.date(from: "May 17, 2012") {
            addCarInList(brand: "Tesla", model: "Model S", releaseDate: date1, description: "Price 39900$")
        }
        if let date2 = dateFormat.date(from: "Jun 14, 2013") {
            addCarInList(brand: "Tesla", model: "Model X", releaseDate: date2, description: "Price 49900$")
        }
    }
    
    private func addCarInList(brand: String, model: String, releaseDate: Date, description: String) {
        let car = Car(brand: brand, model: model, releaseDate: releaseDate, description: description)
        carList.append(car)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.identifier, for: indexPath) as! CarCell
        let car = carList[indexPath.row]
        
        cell.brandLabel.text = car.brand
        cell.modelLabel.text = car.model
        cell.releaseDateLabel.text = dateFormat.string(from: car.releaseDate)
        cell.descriptionLabel.text = car.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func onCreatedNew(car: Car) {
        carList.append(car)
        carListTableView.reloadData()
    }
    
    func refreshCarList() {
        carListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addNewCarSegueID {
            let nextVC = segue.destination as! AddNewCarVC
            nextVC.delegate = self
        }
        
        if segue.identifier == editCarSegueID {
            if let indexPath = carListTableView.indexPathForSelectedRow {
                let nextVC = segue.destination as! AddNewCarVC
                nextVC.delegate = self
                nextVC.carForEdit = carList[indexPath.row]
            }
        }
    }
    
}

extension CarListViewController: AddNewCarDelegate {
    
}






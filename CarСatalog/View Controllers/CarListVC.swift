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
            carListTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    private let addNewCarSegueID = "createNewCarSegue"
    private let editCarSegueID = "editCarSegue"
    private var carList: [Car] = []
    private var brandList: [String] = []
    
    private var dateFormat: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        return dateFormat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addListSample()
        refreshBrandList()
    }
    
    func refreshBrandList() {
        for item in carList {
            if !brandList.contains(item.brand) {
                brandList.append(item.brand)
            }
        }
        brandList.sort(by: <)
    }
    
    private func addListSample() {
        if let date1 = dateFormat.date(from: "May 17, 2012") {
            addCarInList(brand: "Tesla", model: "Model S", releaseDate: date1, description: "Price 39900$. The Tesla Model S is a full-sized all-electric five-door, luxury liftback, produced by Tesla, Inc., and introduced on 22 June 2012.[14] It scored a perfect 5.0 NHTSA automobile safety rating.")
        }
        if let date2 = dateFormat.date(from: "Jun 14, 2013") {
            addCarInList(brand: "Tesla", model: "Model X", releaseDate: date2, description: "Price 49900$")
        }
        if let date3 = dateFormat.date(from: "Jun 18, 2010") {
            addCarInList(brand: "BMW", model: "X5", releaseDate: date3, description: "Price 39900$")
        }
        if let date4 = dateFormat.date(from: "Jul 21, 2005") {
            addCarInList(brand: "Chevrolet", model: "Camaro", releaseDate: date4, description: "Price 69900$")
        }
        if let date5 = dateFormat.date(from: "Feb 24, 1995") {
            addCarInList(brand: "Audi", model: "A6", releaseDate: date5, description: "Price 19900$")
        }
    }
    
    private func addCarInList(brand: String, model: String, releaseDate: Date, description: String) {
        let car = Car(brand: brand, model: model, releaseDate: releaseDate, description: description)
        carList.append(car)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return brandList.count
        }
        return carList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = UIColor.yellow
        let label = UILabel()
        if section == 0 {
            label.text = "Brands"
        } else {
            label.text = "Full list"
        }
        label.frame = CGRect(x: 5, y: 5, width: 100, height: 20)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CarCellSmall.identifier, for: indexPath) as! CarCellSmall
            let brand = brandList[indexPath.row]
            
            cell.brandLabel.text = brand
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.identifier, for: indexPath) as! CarCell
        let car = carList[indexPath.row]
            
        cell.brandLabel.text = car.brand
        cell.modelLabel.text = car.model
        cell.releaseDateLabel.text = dateFormat.string(from: car.releaseDate)
        cell.descriptionLabel.text = car.description
        cell.descriptionLabel.numberOfLines = 0
        if let image = car.image {
            cell.carImage.image = image
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func onCreatedNew(car: Car) {
        carList.append(car)
        refreshBrandList()
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






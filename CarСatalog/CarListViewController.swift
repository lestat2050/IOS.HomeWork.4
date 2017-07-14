//
//  CarListViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CarListViewController: UIViewController, UITableViewDataSource, AddNewCarDelegate {
    
    @IBOutlet weak var CarListTableView: UITableView!
    var cars: [Car] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatted = DateFormatter()
        formatted.dateStyle = .medium
        let teslaModelS = Car(brand: "Tesla", model: "Model S", releaseDate: formatted.date(from: "May 17, 2012")!)
        cars.append(teslaModelS)
        let teslaModelX = Car(brand: "Tesla", model: "Model X", releaseDate: formatted.date(from: "Jun 14, 2013")!)
        cars.append(teslaModelX)
        
        CarListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as! CarCell
        let car = cars[indexPath.row]
        let formatted = DateFormatter()
        formatted.dateStyle = .medium
        
        cell.brandLabel.text = car.brand
        cell.modelLabel.text = car.model
        cell.releaseDateLabel.text = formatted.string(from: car.releaseDate)
        
        return cell
    }
    
    func onCreatedNew(car: Car) {
        cars.append(car)
        CarListTableView.reloadData()
    }
    
    func reloadData() {
        CarListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewCarSegue" {
            let nextVC = segue.destination as! ViewController
            nextVC.delegate = self
        } else if segue.identifier == "editCarSegue" {
            if let indexPath = CarListTableView.indexPathForSelectedRow {
                let nextVC = segue.destination as! ViewController
                nextVC.delegate = self
                nextVC.carForEdit = cars[indexPath.row]
            }
        }
    }
    
}


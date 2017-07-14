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

        let testCar1 = Car(brand: "Tesla", model: "Model S", releaseDate: Date())
        cars.append(testCar1)
        let testCar2 = Car(brand: "Tesla", model: "Model X", releaseDate: Date())
        cars.append(testCar2)
        
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
        cell.brandLabel.text = car.brand
        cell.modelLabel.text = car.model
        
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


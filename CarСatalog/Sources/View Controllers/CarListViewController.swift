//
//  CarListViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CarListViewController: UIViewController {
    @IBOutlet private(set) weak var carListTableView: UITableView! {
        didSet {
            carListTableView.dataSource = self
            carListTableView.delegate = self
            carListTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    let addNewCarSegueID = "addNewCarSegueID"
    let numberOfSections = 2
    
    var carList: [Car] = []
    var brandList: [String] = []
    
    lazy var dateFormat: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        return dateFormat
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        addListSample()
        refreshBrandList()
    }
    
    private func registerCells() {
        carListTableView.register(UINib(nibName: CarCellSmall.identifier, bundle: nil),
                                  forCellReuseIdentifier: CarCellSmall.identifier)
        carListTableView.register(UINib(nibName: CarCell.identifier, bundle: nil),
                                  forCellReuseIdentifier: CarCell.identifier)
    }
    
    private func addListSample() {
        struct Info {
            let brand: String
            let model: String
            let date: String
            let description: String
        }
        
        var defaultData: [Info] = []
        defaultData.append(Info(brand: "Tesla",
                                model: "Model S",
                                date: "May 17, 2012",
                                description: "Price 49900$"))
        defaultData.append(Info(brand: "Tesla",
                                model: "Model X",
                                date: "Jun 14, 2013",
                                description: "Price 39900$. The Tesla Model S is a full-sized all-electric five-door, luxury liftback, produced by Tesla, Inc., and introduced on 22 June 2012.[14] It scored a perfect 5.0 NHTSA automobile safety rating."))
        defaultData.append(Info(brand: "Chevrolet",
                                model: "Camaro",
                                date: "Jul 21, 2005",
                                description: "Price 69900$"))
        defaultData.append(Info(brand: "Audi",
                                model: "A6",
                                date: "Feb 24, 1995",
                                description: "Price 19900$"))
        
        for element in defaultData {
            dateFormat.date(from: element.date).flatMap {
                carList.append(Car(brand: element.brand,
                                   model: element.model,
                                   releaseDate: $0,
                                   description: element.description))
            }
        }
    }
    
    func refreshBrandList() {
        for item in carList {
            if !brandList.contains(item.brand) {
                brandList.append(item.brand)
            }
        }
        brandList.sort(by: <)
    }
    
    @IBAction func onTouchAddNewCar(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: addNewCarSegueID, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! AddNewCarViewController
        nextViewController.delegate = self
        if let indexPath = carListTableView.indexPathForSelectedRow {
            nextViewController.carForEdit = carList[indexPath.row]
        }
    }
}

extension CarListViewController: AddNewCarDelegate {
    func onCreatedNew(car: Car) {
        carList.append(car)
        refreshBrandList()
        carListTableView.reloadData()
    }
    
    func refreshList() {
        carListTableView.reloadData()
    }
}

extension CarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
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
}

extension CarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return brandList.count
        }
        return carList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CarCellSmall.identifier,
                                                     for: indexPath) as! CarCellSmall
            let brand = brandList[indexPath.row]
            
            cell.selectionStyle = .none
            cell.brandLabel.text = brand
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.identifier,
                                                 for: indexPath) as! CarCell
        let car = carList[indexPath.row]
        
        cell.selectionStyle = .none
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
        if indexPath.section != 0 {
            performSegue(withIdentifier: addNewCarSegueID, sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}





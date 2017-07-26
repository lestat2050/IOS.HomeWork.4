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
    let estimatedHeightRow = 80
    let headerHeight = 30
    
    struct SectionsInfo {
        let title: String
        let cellIdentifier: String
        let isFullList: Bool
        let dataArray: [Any]
    }
    var sections: [SectionsInfo] = []
    
    var carList: [Car] = []
    var brandList: [String] = []
    
    private(set) lazy var dateFormat: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        return dateFormat
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        addListSample()
        refreshList()
        refreshInfoStruct()
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
                                   description: element.description,
                                   image: nil))
            }
        }
    }
    
    func refreshBrandList() {
        //do not working after add new car
        //brandList = carList.map { !brandList.contains($0.brand) }
        //    .carList.filter { $0.brand }.sorted(by: <)
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
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = carListTableView.indexPathForSelectedRow {
            self.carListTableView.deselectRow(at: row, animated: true)
        }
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
        refreshList()
    }
    
    func refreshList() {
        refreshBrandList()
        refreshInfoStruct()
        carListTableView.reloadData()
    }
    
    func refreshInfoStruct() {
        sections.removeAll()
        sections.append(SectionsInfo(title: "Brands",
                                     cellIdentifier: CarCellSmall.identifier,
                                     isFullList: false,
                                     dataArray: brandList))
        sections.append(SectionsInfo(title: "Full list",
                                     cellIdentifier: CarCell.identifier,
                                     isFullList: true,
                                     dataArray: carList))
    }
    
}

extension CarListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        
        view.backgroundColor = UIColor.yellow

        label.text = sections[section].title
        label.frame = CGRect(x: 5, y: 5, width: 100, height: 20)
        
        view.addSubview(label)
        
        return view
    }
    
}

extension CarListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sections[section].dataArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier,
                                                 for: indexPath) as! CarCellBranded
        
        if !section.isFullList {
            let car = section.dataArray[indexPath.row] as! String
            let _ = CarCellSmallConfigurator(view: cell as! CarCellSmall, model: car)
        } else {
            let car = section.dataArray[indexPath.row] as! Car
            let _ = CarCellConfigurator(view: cell as! CarCell, model: car)
        }
        
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sections[indexPath.section].isFullList {
            performSegue(withIdentifier: addNewCarSegueID, sender: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(estimatedHeightRow)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(headerHeight)
    }
    
}





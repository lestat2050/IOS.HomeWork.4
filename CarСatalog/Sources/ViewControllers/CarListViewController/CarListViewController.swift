//
//  CarListViewController.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CarListViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private(set) weak var carListTableView: UITableView! {
        didSet {
            configurateCarListTableView()
        }
    }
    
    //MARK: - Properties
    
    let model = CarListModel()
    
    var dataSource: CarListDataSource?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeOnModelChanges()
        configureDataSources()
        addListSample()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let row = carListTableView.indexPathForSelectedRow {
            self.carListTableView.deselectRow(at: row, animated: true)
        }
        model.selectedCar = nil
    }
    
    //MARK: - Methods
    
    private func configurateCarListTableView() {
        carListTableView.dataSource = self
        carListTableView.delegate = self
        carListTableView.rowHeight = UITableViewAutomaticDimension
        carListTableView.register(UINib(nibName: CarCellBrand.identifier, bundle: nil),
                                  forCellReuseIdentifier: CarCellBrand.identifier)
        carListTableView.register(UINib(nibName: CarCellFullList.identifier, bundle: nil),
                                  forCellReuseIdentifier: CarCellFullList.identifier)
    }
    
    private func subscribeOnModelChanges() {
        NotificationCenter.default.addObserver(forName: CarListModel.onChangeCarsNotification,
                                               object: nil, queue: nil) {[weak self] _ in
                                                self?.configureDataSources()
                                                self?.carListTableView.reloadData()
        }
    }
    
    private func configureDataSources() {
        let firstSection = Section(title: "Brands",
                                   configurator: BrandCellConfigurator(),
                                   rows: model.brands, segueID: nil)
        
        let secondSection = Section(title: "Full list",
                                    configurator: CarCellFullListConfigurator(),
                                    rows: model.cars, segueID: addNewCarSegueID)
        
        
        
        let dataSource = CarListDataSource(sections: [firstSection, secondSection])
        self.dataSource = dataSource
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
                                description: "Price 39900$. The Tesla Model S" +
            " is a full-sized all-electric five-door, luxury liftback, produced" +
            " by Tesla, Inc., and introduced on 22 June 2012.[14] It scored a" +
            " perfect 5.0 NHTSA automobile safety rating."))
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
                model.addNew(car: Car(brand: element.brand,
                                      model: element.model,
                                      releaseDate: $0,
                                      description: element.description))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextViewController = segue.destination as! AddNewCarViewController
        nextViewController.delegate = self
        nextViewController.editedCar = model.selectedCar as? Car
    }
    
    //MARK: - Actions
    
    @IBAction func onTouchAddNewCar(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: addNewCarSegueID, sender: nil)
    }
    
    //MARK: -
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension CarListViewController: AddNewCarDelegate {
    
    func onCreatedNew(car: Car) {
        model.addNew(car: car)
    }
    
    func refreshList() {
        carListTableView.reloadData()
    }
    
}

extension CarListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource,
            let segueID = dataSource.sections[indexPath.section].segueID else {
                return
        }
        let rowData = dataSource.sections[indexPath.section].rows[indexPath.row]
        model.selectedCar = rowData
        performSegue(withIdentifier: segueID, sender: nil)
    }

}

extension CarListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSource?.sections[section].rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return dataSource?.sections[section].title
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let dataSource = dataSource else {
            fatalError("Not implemented dataSource")
        }
        let section = dataSource.sections[indexPath.section]
        let rowModel = section.rows[indexPath.row]
        let configurator = section.configurator
        let cell = tableView.dequeueReusableCell(withIdentifier: section.configurator.cellIdentifier,
                                                 for: indexPath)
        configurator.configure(with: cell as! ConfigurableCell, model: rowModel)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.sections.count ?? 0
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





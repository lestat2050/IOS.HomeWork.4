//
//  CarListModel.swift
//  CarCatalog
//
//  Created by Yaroslav Surovtsev on 8/6/17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import Foundation

protocol CarListProtocol {
    var cars: [Car] { get }
    var brands: [Brand] { get }
    var selectedCar: Branded? { get set }
    
    func addNew(car: Car) -> Void
}


class CarListModel {
    
    static let onChangeCarsNotification = NSNotification.Name(rawValue: onChangeCarsNotificationName)
    
    private(set) var cars: [Car] = []
    private(set) var brands: [Brand] = []
    var selectedCar: Branded?
    
    func addNew(car: Car) -> Void {
        cars.append(car)
        recalculateBrands()
        NotificationCenter.default.post(name: CarListModel.onChangeCarsNotification,
                                        object: nil)
    }
    
    private func recalculateBrands() -> Void {
        let brandsTitles: [String] = cars.map{$0.brand}.sorted(by: <)
        var brands: [String] = []
        brandsTitles.forEach({ (title: String) in
            if !brands.contains(title) {
                brands.append(title)
            }
        })
        self.brands = brands.map{ Brand(brand: $0) }
    }
    
}

extension CarListModel: CarListProtocol { }

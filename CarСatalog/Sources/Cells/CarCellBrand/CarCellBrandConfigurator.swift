//
//  CarCellBrandConfigurator.swift
//  CarCatalog
//
//  Created by Yaroslav Surovtsev on 8/6/17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import Foundation

class BrandCellConfigurator: ConfiguratorProtocol {
    
    let cellIdentifier = CarCellBrand.identifier
    
    func configure(with cell: ConfigurableCell, model: Branded) {
        guard let cell = cell as? CarCellBrand else {
            fatalError("Not right view")
        }
        cell.brandLabel.text = model.brand
    }
    
}

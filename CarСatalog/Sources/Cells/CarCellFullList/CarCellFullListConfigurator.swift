//
//  CarCellFullListConfigurator.swift
//  CarCatalog
//
//  Created by Yaroslav Surovtsev on 8/6/17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import Foundation

class CarCellFullListConfigurator: ConfiguratorProtocol {
    
    let cellIdentifier = CarCellFullList.identifier
    
    func configure(with cell: ConfigurableCell, model: Branded) {
        guard let cell = cell as? CarCellFullList else {
            fatalError("Not right view")
        }
        guard let model = model as? Car else {
            fatalError("Not right model")
        }
        cell.brandLabel.text = model.brand
        cell.modelLabel.text = model.model
        cell.releaseDateLabel.text = dateFormat.string(from: model.releaseDate)
        cell.descriptionLabel.text = model.description
        cell.carImage.image = model.image
        
    }
    
}

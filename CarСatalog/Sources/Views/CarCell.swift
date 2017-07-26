//
//  CarCell.swift
//  Car catalog
//
//  Created by Yaroslav Surovtsev on 23.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CarCell: UITableViewCell {
    
    @IBOutlet private(set) weak var carImage: UIImageView!
    @IBOutlet private(set) weak var brandLabel: UILabel!
    @IBOutlet private(set) weak var modelLabel: UILabel!
    @IBOutlet private(set) weak var releaseDateLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    
    static let identifier: String = String(describing: CarCell.self)

}

extension CarCell: CarCellBranded { }

class CarCellConfigurator {
    
    private(set) lazy var dateFormat: DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        return dateFormat
    }()
    
    init(view: CarCell, model: Car) {
        view.brandLabel.text = model.brand
        view.modelLabel.text = model.model
        view.releaseDateLabel.text = dateFormat.string(from: model.releaseDate)
        view.descriptionLabel.text = model.description
        if let image = model.image {
            view.carImage.image = image
        }
    }
    
}




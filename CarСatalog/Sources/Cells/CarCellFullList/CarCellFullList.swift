//
//  CarCellFullList.swift
//  Car catalog
//
//  Created by Yaroslav Surovtsev on 23.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CarCellFullList: UITableViewCell {
    
    @IBOutlet private(set) weak var carImage: UIImageView!
    @IBOutlet private(set) weak var brandLabel: UILabel!
    @IBOutlet private(set) weak var modelLabel: UILabel!
    @IBOutlet private(set) weak var releaseDateLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    
    static let identifier: String = String(describing: CarCellFullList.self)

}

extension CarCellFullList: ConfigurableCell { }



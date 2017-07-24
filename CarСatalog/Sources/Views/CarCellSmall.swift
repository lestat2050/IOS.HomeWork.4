//
//  CarCellSmall.swift
//  Car catalog
//
//  Created by Yaroslav Surovtsev on 23.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CarCellSmall: UITableViewCell {
    @IBOutlet private(set) weak var brandLabel: UILabel!
    
    static let identifier: String = String(describing: CarCellSmall.self)
}

//
//  CarCell.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 11.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

class CarCell: UITableViewCell {
    
    @IBOutlet private(set) weak var carImage: UIImageView!
    @IBOutlet private(set) weak var brandLabel: UILabel!
    @IBOutlet private(set) weak var modelLabel: UILabel!
    @IBOutlet private(set) weak var releaseDateLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    
    static let identifier = "CarCell"
    
    
}


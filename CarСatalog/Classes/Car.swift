//
//  Car.swift
//  CarСatalog
//
//  Created by Yaroslav Surovtsev on 16.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import Foundation
import UIKit

class Car {
    
    var brand: String
    var model: String
    var releaseDate: Date
    var description: String?
    var image: UIImage?

    
    init(brand: String, model: String, releaseDate: Date, description: String? = nil, image: UIImage? = nil) {
        self.brand = brand
        self.model = model
        self.releaseDate = releaseDate
        self.description = description
        self.image = image
    }
    
}

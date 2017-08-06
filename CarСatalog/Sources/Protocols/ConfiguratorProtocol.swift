//
//  CarCellBranded.swift
//  CarCatalog
//
//  Created by Yaroslav Surovtsev on 26.07.17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import UIKit

protocol Branded {
    var brand: String { get }
}

protocol ConfiguratorProtocol {
    var cellIdentifier: String { get }
    
    func configure(with cell: ConfigurableCell, model: Branded)
}

protocol ConfigurableCell  {
    static var identifier: String { get }
}

extension ConfigurableCell where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

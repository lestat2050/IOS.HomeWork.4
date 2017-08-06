//
//  CarListDataSource.swift
//  CarCatalog
//
//  Created by Yaroslav Surovtsev on 8/6/17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import Foundation

struct Section {
    
    let title: String
    let configurator: ConfiguratorProtocol
    let rows: [Branded]
    var segueID: String?
    
}

class CarListDataSource {
    
    var sections: [Section] = []
    
    init(sections: [Section] = []) {
        self.sections = sections
    }
    
}

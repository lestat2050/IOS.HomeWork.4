//
//  Constants.swift
//  CarCatalog
//
//  Created by Yaroslav Surovtsev on 8/2/17.
//  Copyright © 2017 Yaroslav Surovtsev. All rights reserved.
//

import Foundation

let addNewCarSegueID = "addNewCarSegueID"
let onChangeCarsNotificationName = "onChangeCarsNotification"
let estimatedHeightRow = 80
let headerHeight = 30
let imagePreview = "imagePreview"

let dateFormat: DateFormatter = {
    let dateFormat = DateFormatter()
    dateFormat.dateStyle = .medium
    return dateFormat
}()

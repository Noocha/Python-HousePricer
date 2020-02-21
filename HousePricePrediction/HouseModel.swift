//
//  HouseModel.swift
//  HousePricePrediction
//
//  Created by Nattagan Ananpech on 24/11/19.
//  Copyright © 2019 nooch. All rights reserved.
//

import Foundation

class HouseModel {

    var date: Double = 0
    var bedroom: Double = 0.0
    var bathroom: Double = 0.0
    var living: Double = 0.0
    var landspace: Double = 0.0
    var floor: Double = 0.0
    var waterfront: Double = 0.0
    var view: Double = 0.0
    var condition: Double = 0.0
    var grade: Double = 0.0
    var above: Double = 0.0
    var basement: Double = 0.0
    var yrsBuilt: Double = 0.0
    var renovate: Double = 0.0
    
    func getDate()  {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: Date())
        date = (dateString as NSString).doubleValue
    }
}





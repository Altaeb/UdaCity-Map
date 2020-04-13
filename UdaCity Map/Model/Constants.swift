//
//  Constants.swift
//  UdaCity Map
//
//  Created by Abdalfattah Altaeb on 4/13/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import Foundation

struct MapConstant {
    static let locationTableCell = "cell"
    static let mapViewReuseId = "pin"
    static let displayMapSegueId = "displayMap"
    static let locationSegueId = "locationsSegue"

    struct Network {
        static let queryStudentLocationsURL = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
        static let addLocationURL = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let sessionURL = "https://onthemap-api.udacity.com/v1/session"
    }
}

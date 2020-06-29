//
//  Reachability.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 29.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import SystemConfiguration

struct Reachability {
    
    // MARK: - Properties
    
    static let shared = Reachability()
    private let networkReachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    
    // MARK: - Functions
    
    func checkConnection() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.networkReachability!, &flags)
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
    
}

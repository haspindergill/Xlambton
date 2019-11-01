//
//  Agent.swift
//  xlambton
//
//  Copyright © 2018 jagdeep. All rights reserved.
//

import Foundation

class Agent: NSObject {
    var name : String?
    var mission : String?
    var country : String?
    var date : String?
    
    
    override init() {
        super.init()
    }
    
    init(name:String?,mission:String?,country:String?,date:String?) {
        super.init()
        self.name = name
        self.mission = mission
        self.country = country
        self.date = date
    }
}

//
//  UserSettings.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var capacity: Int
    
    init(name: String, capacity: Int) {
        self.name = name
        self.capacity = capacity
    }
}

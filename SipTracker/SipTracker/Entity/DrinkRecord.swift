//
//  DrinkRecord.swift
//  SipTracker
//
//  Created by 이건우 on 11/26/24.
//

import Foundation
import SwiftData

@Model
class DrinkRecord: ObservableObject {
    @Attribute(.unique) var id: UUID = UUID()
    var date: Date
    var duration: Int // 초 단위
    var glasses: Int

    init(date: Date, duration: Int, glasses: Int) {
        self.id = UUID()
        self.date = date
        self.duration = duration
        self.glasses = glasses
    }
}

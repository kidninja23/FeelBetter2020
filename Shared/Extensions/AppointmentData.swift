//
//  AppointmentData.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/10/20.
//

import Foundation
import CareKitStore

class AppointmentData: Equatable, Comparable, Hashable {
    static func < (lhs: AppointmentData, rhs: AppointmentData) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: AppointmentData, rhs: AppointmentData) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            
        }
    
    var title: String
    var date: Date
    var notes: String?
    var id: UUID
    var child: OCKPatient
    
    init(title: String, date: Date, notes: String?, child: OCKPatient) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.notes = notes
        self.child = child
    }
}

//
//  OCKPatientExtension.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/10/20.
//

import CareKit
import CareKitUI
import CareKitStore

extension OCKPatient: Hashable {
    static func == (lhs: OCKPatient, rhs: OCKPatient) -> Bool {
            return lhs.uuid == rhs.uuid
        }

    public func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
            
        }
}

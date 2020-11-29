//
//  OCKContactExtension.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/18/20.
//

import CareKit
import CareKitUI
import CareKitStore

extension OCKContact: Hashable {
    static func == (lhs: OCKContact, rhs: OCKContact) -> Bool {
            return lhs.uuid == rhs.uuid
        }

    public func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
            
        }
}

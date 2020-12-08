//
//  OCKContactExtension.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/18/20.
//

import CareKit
import CareKitUI
import CareKitStore

extension OCKContact: Hashable, Comparable {
    public static func < (lhs: OCKContact, rhs: OCKContact) -> Bool {
        return lhs.name.familyName ?? "" < rhs.name.familyName ?? ""
    }
    
    static func == (lhs: OCKContact, rhs: OCKContact) -> Bool {
            return lhs.uuid == rhs.uuid
        }

    public func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
            
        }
}

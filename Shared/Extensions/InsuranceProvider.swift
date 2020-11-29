//
//  InsuranceProvider.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/4/20.
//

import Foundation

class InsuranceProvider: Equatable, Comparable, Hashable {
    static func < (lhs: InsuranceProvider, rhs: InsuranceProvider) -> Bool {
        return lhs.InsuranceType < rhs.InsuranceType
    }
    
    static func == (lhs: InsuranceProvider, rhs: InsuranceProvider) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            
        }
    
    var id: UUID
    var ProviderName: String
    var HealthPlan: String
    var PlanTitle: String?
    var MemberID: String?
    var GroupNumber: String?
    var ProviderContact: String
    var MemberContact: String
    var ClaimsAddress: String
    var AccountHolder: String
    var Dependents: [String]?
    var InsuranceType: String
    var RXnumber: String
    var Copay: [Int]
    
    init(
        id: UUID,
        ProviderName: String,
        HealthPlan: String,
        PlanTitle: String?,
        MemberID: String?,
        GroupNumber: String?,
        ProviderContact: String,
        MemberContact: String,
        ClaimsAddress: String,
        AccountHolder: String,
        Dependents: [String]?,
        InsuranceType: String,
        RXnumber: String = "",
        Copay: [Int] = [Int]()
    ) {
        self.id = UUID()
        self.ProviderName = ProviderName
        self.HealthPlan = HealthPlan
        self.PlanTitle = PlanTitle
        self.MemberID = MemberID
        self.GroupNumber = GroupNumber
        self.ProviderContact = ProviderContact
        self.MemberContact = MemberContact
        self.ClaimsAddress = ClaimsAddress
        self.AccountHolder = AccountHolder
        self.Dependents = Dependents
        self.InsuranceType = InsuranceType
        self.RXnumber = RXnumber
        self.Copay = Copay
    }
    
}

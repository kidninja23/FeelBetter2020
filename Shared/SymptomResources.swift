//
//  SymptomResources.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/15/20.
//

import Foundation

enum BodyZone {
    case all
    case head
    case torso
    case arm
    case leg
    case whole
    case illness
}

class SymptomResources: Equatable, Comparable, Hashable {
    static func < (lhs: SymptomResources, rhs: SymptomResources) -> Bool {
        return lhs.title < rhs.title
    }
    
    static func == (lhs: SymptomResources, rhs: SymptomResources) -> Bool {
        return (lhs.id == rhs.id) && (lhs.title == rhs.title)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        }
    
    var id: UUID
    var bodyZone: BodyZone
    var title: String
    var description: String
    var causes: [String]
    var source: [String]
    var symptoms:[String]
    var medicalNeed: [String]
    var relief: [String]
    var showDescription: Bool
    var showCauses: Bool
    var showSource: Bool
    var showSymptoms: Bool
    var showMedicalNeed: Bool
    var showRelief: Bool
    
    init(bodyZone: BodyZone = .whole,
         title: String,
         description: String,
         causes: [String],
         source: [String],
         symptoms:[String],
         medicalNeed: [String],
         relief: [String],
         showDescription: Bool,
         showCauses: Bool,
         showSource: Bool,
         showSymptoms: Bool,
         showMedicalNeed: Bool,
         showRelief: Bool
         ) {
        self.id = UUID()
        self.bodyZone = bodyZone
        self.title = title
        self.description = description
        self.causes = causes
        self.source = source
        self.symptoms = symptoms
        self.medicalNeed = medicalNeed
        self.relief = relief
        self.showDescription = showDescription
        self.showCauses = showCauses
        self.showSource = showSource
        self.showSymptoms = showSymptoms
        self.showMedicalNeed = showMedicalNeed
        self.showRelief = showRelief
    }
}

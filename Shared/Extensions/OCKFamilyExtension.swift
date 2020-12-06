//
//  OCKFamilyExtension.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/10/20.
//

import SwiftUI
import CareKit
import CareKitStore
import Contacts
import UIKit
import HealthKit
import ContactsUI

internal extension OCKStore {
    
    func populateFamilyData() {
        
        var guardian1 = OCKContact(id: "amy-bice", givenName: "Amy", familyName: "Bice", carePlanUUID: nil)
        guardian1.role = "Mother"
                guardian1.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "lbice@icloud.com")]
                guardian1.phoneNumbers = [OCKLabeledValue(label: CNLabelHome, value: "(324) 555-7415")]
        
        var guardian2 = OCKContact(id: "jackson-bice", givenName: "Jackson", familyName: "Bice", carePlanUUID: nil)
        guardian2.role = "Father"
        guardian2.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "jbice@icloud.com")]
        guardian2.phoneNumbers = [OCKLabeledValue(label: CNLabelHome, value: "(324) 555-7415")]
        
        var specialist1 = OCKContact(id: "Specialist1-Julie", givenName: "Robert", familyName: "Zemekis", carePlanUUID: nil)
        specialist1.category = .careProvider
        specialist1.title = "Pediatric Cardiologist"
        specialist1.address = {
            let address = OCKPostalAddress()
            address.street = "9303 Lyon Drive"
            address.city = "Hill Valley"
            address.state = "GA"
            address.postalCode = "30038"
            return address
        }()
        specialist1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(555) 555-2389")]
        
        var dateComponents = DateComponents()
        dateComponents.year = 2016
        dateComponents.month = 4
        dateComponents.day = 29
        let calendar = Calendar.current
        let birthDate1 = calendar.date(from: dateComponents)
        
        dateComponents.year = 2019
        dateComponents.month = 9
        dateComponents.day = 13
        let birthDate2 = calendar.date(from: dateComponents)
        
        dateComponents.year = 2020
        dateComponents.month = 12
        dateComponents.day = 17
        //let appointment1 = calendar.date(from: dateComponents)
        
        var child3 = OCKPatient(id: "julie-bice", givenName: "Julie", familyName: "Bice")
        child3.allergies = ["Tree nuts"]
        child3.birthday = birthDate1
        
        var child4 = OCKPatient(id: "allister-bice", givenName: "Allister", familyName: "Bice")
        child4.allergies = ["No allergies"]
        child4.birthday = birthDate2
        
        var doctor1 = OCKContact(id: "Primary-Julie", givenName: "Shalii", familyName: "Shah", carePlanUUID: nil)
        doctor1.category = .careProvider
        doctor1.title = "Pediatrician"
        doctor1.address = {
            let address = OCKPostalAddress()
            address.street = "7165 Colfax Avenue"
            address.city = "Cumming"
            address.state = "GA"
            address.postalCode = "30040"
            return address
        }()
        doctor1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        
        //ClericStore.shared.appendChildDetails(Child: child3, FirstName: "Julie", FamilyName: "Bice", Gender: .female, Birthdate: birthDate1!, Weight: 44, Height: 46, MedicalConditions: ["Mild Heart Murmur"], Allergies: ["Tree nuts, Cat Dander"], PrimaryPhysician: [doctor1], Specialist: ["Pediatric Cardiologist" : specialist1], ProfileImage: "Julie", UpcomingAppointment: ["Heart Murmur Checkup" : appointment1!], Other: ["Custom Example Field" : "Custom Example Text"])
        
        //ClericStore.shared.appendChildDetails(Child: child4, FirstName: "Allister", FamilyName: "Bice", Gender: .male, Birthdate: birthDate2!, Weight: 31, Height: 29, PrimaryPhysician: [doctor1], ProfileImage: "Allister")
        
        addContacts([guardian1, guardian2, doctor1, specialist1])
        addPatients([child3, child4])
    }
    /*
    func populateFamilyData() {

            
            ClericStore.shared.appendChildDetails(Child: child1, FirstName: "Julie", FamilyName: "Bice", Gender: .female, Birthdate: birthDate1!, Weight: 44, Height: 46, MedicalConditions: ["Mild Heart Murmur"], Allergies: ["Tree nuts, Cat Dander"], PrimaryPhysician: [doctor1], Specialist: ["Pediatric Cardiologist" : specialist1], ProfileImage: "Julie", UpcomingAppointment: ["Heart Murmur Checkup" : appointment1!], Other: ["Custom Example Field" : "Custom Example Text"])
            
            ClericStore.shared.appendChildDetails(Child: child2, FirstName: "Allister", FamilyName: "Bice", Gender: .male, Birthdate: birthDate2!, Weight: 31, Height: 29, PrimaryPhysician: [doctor1], ProfileImage: "Allister")
            
            ClericStore.shared.appendGuardianDetails(Guardian: guardian1, FirstName: guardian1.name.givenName!, FamilyName: guardian1.name.familyName!, GuardianAvatar: "Avatar08", Primary: true)
            
            ClericStore.shared.appendGuardianDetails(Guardian: guardian2, FirstName: guardian2.name.givenName!, FamilyName: guardian2.name.familyName!, GuardianAvatar: "Avatar02", Primary: false)
            
            ClericStore.shared.appendInsuranceProvider(PrimaryHealth: primaryProvider, AdditionalCoverage: ["Vision" : additionalProvider])
            //self.activePatient = child1
            
            ClericStore.shared.appendFamilyDetails(FamilyName: guardian1.name.familyName!, PrimaryGuardian: guardian1, AdditionalGuardian: [guardian2], ActiveGuardian: guardian1, Children: [child1, child2])
            
            addContacts([guardian1, guardian2, doctor1, specialist1])
            addPatients([child1, child2])
        }*/
    
    func populateFeverCarePlan(_ patient: OCKPatient) {
        
        let today = Calendar.current.startOfDay(for: Date())
        let finalDay = Calendar.current.date(byAdding: .day, value: 14, to: today)!
        let earlyMorning = Calendar.current.date(byAdding: .hour, value: 6, to: today)!
        let midMorning = Calendar.current.date(byAdding: .hour, value: 9, to: today)!
        let midDay = Calendar.current.date(byAdding: .hour, value: 12, to: today)!
        let earlyAfternoon = Calendar.current.date(byAdding: .hour, value: 15, to: today)!
        let evening = Calendar.current.date(byAdding: .hour, value: 18, to: today)!
        let lateEvening = Calendar.current.date(byAdding: .hour, value: 21, to: today)!
        let todayFormatter = DateFormatter()
        todayFormatter.dateStyle = .short
        let id = patient.name.givenName! + "-" + todayFormatter.string(from: today)
        
        if ClericStore.shared.activeCarePlan[patient] != nil {
            ClericStore.shared.activeCarePlan[patient]!.append(id)
        } else {
            ClericStore.shared.activeCarePlan[patient] = id 
        }
        
        
        let earlyMornSchedule = OCKSchedule(composing:[ OCKScheduleElement(start: earlyMorning, end: finalDay, interval: DateComponents(day: 1))])
            
        let midMornSchedule = OCKSchedule(composing: [OCKScheduleElement(start: midMorning, end: finalDay, interval: DateComponents(day: 1))])

        let midDaySchedule = OCKSchedule(composing: [OCKScheduleElement(start: midDay, end: finalDay, interval: DateComponents(day: 1))])

        let earlyAfternoonSchedule = OCKSchedule(composing: [OCKScheduleElement(start: earlyAfternoon, end: finalDay, interval: DateComponents(day: 1))])

        let eveningSchedule = OCKSchedule(composing: [OCKScheduleElement(start: evening, end: finalDay, interval: DateComponents(day: 1))])

        let lateEveningSchedule = OCKSchedule(composing: [OCKScheduleElement(start: lateEvening, end: finalDay, interval: DateComponents(day: 1))])
        
        var recordTemperature01 = OCKTask(id: "Temperature Check 1: \(id)", title: "Record Temperature", carePlanUUID: nil, schedule: earlyMornSchedule)
        recordTemperature01.instructions = "While your child is awake, record their temperature using a standard thermometer."
        recordTemperature01.impactsAdherence = true
        
        var recordTemperature02 = OCKTask(id: "Temperature Check 2: \(id)", title: "Record Temperature", carePlanUUID: nil, schedule: midMornSchedule)
        recordTemperature02.instructions = "While your child is awake, record their temperature using a standard thermometer."
        recordTemperature02.impactsAdherence = true
        
        var recordTemperature03 = OCKTask(id: "Temperature Check 3: \(id)", title: "Record Temperature", carePlanUUID: nil, schedule: midDaySchedule)
        recordTemperature03.instructions = "While your child is awake, record their temperature using a standard thermometer."
        recordTemperature03.impactsAdherence = true
        
        var recordTemperature04 = OCKTask(id: "Temperature Check 4: \(id)", title: "Record Temperature", carePlanUUID: nil, schedule: earlyAfternoonSchedule)
        recordTemperature04.instructions = "While your child is awake, record their temperature using a standard thermometer."
        recordTemperature04.impactsAdherence = true
        
        var recordTemperature05 = OCKTask(id: "Temperature Check 5: \(id)", title: "Record Temperature", carePlanUUID: nil, schedule: eveningSchedule)
        recordTemperature05.instructions = "While your child is awake, record their temperature using a standard thermometer."
        recordTemperature05.impactsAdherence = true
        
        var recordTemperature06 = OCKTask(id: "Temperature Check 6: \(id)", title: "Record Temperature", carePlanUUID: nil, schedule: lateEveningSchedule)
        recordTemperature06.instructions = "While your child is awake, record their temperature using a standard thermometer."
        recordTemperature06.impactsAdherence = true
        
        let intakeSchedule = OCKSchedule(composing: [OCKScheduleElement(start: earlyMorning, end: nil, interval: DateComponents(day: 1), text: "Record any food eaten.", targetValues: [], duration: .allDay)])
        
        var recordFood = OCKTask(id: "Food Log: \(id)", title: "Log Food", carePlanUUID: nil, schedule: intakeSchedule)
        recordFood.instructions = "Record any food eaten throughout the day."
        
        var recordLiquid = OCKTask(id: "Liquid Log: \(id)", title: "Log Liquids", carePlanUUID: nil, schedule: intakeSchedule)
        recordLiquid.instructions = "Record any liquids consumed throughout the day."
        
        var recordMedication = OCKTask(id: "Medication Log: \(id)", title: "Log Medication", carePlanUUID: nil, schedule: intakeSchedule)
        recordMedication.instructions = "Record any medications taken throught the day. Be sure to follow dosage instructions."
        
        var symptomLog = OCKTask(id: "Symptom Log: \(id)", title: "Log Symptoms", carePlanUUID: nil, schedule: intakeSchedule)
        symptomLog.instructions = "Record any new or changing symptoms."
        
        addTasks([recordTemperature01, recordTemperature02, recordTemperature03, recordTemperature04, recordTemperature05, recordTemperature06, recordFood, recordLiquid, recordMedication, symptomLog], callbackQueue: .main, completion: nil)
    }
}

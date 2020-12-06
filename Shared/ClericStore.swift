//
//  ClericStore.swift
//  FeelBetter
//
//  Created by Jason on 10/9/20.
//

import SwiftUI
import Foundation
import CareKit
import CareKitUI
import CareKitStore
import Contacts

enum GenderValue: String {
    case male = "Male"
    case female = "Female"
    case other = "Unspecified"
}

class ClericStore: ObservableObject {
    static let shared = ClericStore()
    @Published var familyName: String? = nil
    @Published var defaultPatient: OCKPatient? = nil
    @Published var familyImage: String? = nil
    @Published var memberIDs: [String?] = []
    @Published var childMembers: [OCKPatient?] = []
    @Published var activeGuardian: OCKContact? = nil
    @Published var guardianMembers: [OCKContact?] = []
    @Published var currentChildProfile: OCKPatient? = nil
    @Published var currentGuardianProfile: OCKContact? = nil
    @Published var guardianImages: [OCKContact: String]? = nil
    @Published var profileImages: [OCKPatient : String]? = nil
    @Published var childDetails: [OCKPatient : [String:String]]? = [OCKPatient : [String:String]]()
    @Published var guardianDetails: [OCKContact : [String:String]]? = nil
    @Published var activeCarePlan: [OCKPatient : String] = [OCKPatient : String]()
    @Published var selectedPatient: OCKPatient? = nil
    @Published var activePatient: OCKPatient? = nil
    
    
    //Replacment values and appending methods will appear here.
    @Published var childDetails2 = [OCKPatient : [String:Any]]()
    @Published var guardianDetails2: [OCKContact : [String:String]] = [OCKContact : [String:String]]()
    @Published var familyDetails: [String : Any] = [String : Any]()
    @Published var insuranceProviderDetails: [String : InsuranceProvider] = [String : InsuranceProvider]()
    @Published var redraw: Bool = false
    @Published var resources: SymptomList
    
    let childDetailLabels = [
        "FIRST" : "First Name",
        "MIDDLE" : "Middle Name",
        "OTHER_NAME" : "",
        "LAST" : "Family Name",
        "BIRTHDATE" : "Birthdate",
        "GENDER" : "Gender",
        "WEIGHT" : "Weight",
        "HEIGHT" : "Height",
        "CONDITION" : "Medical Conditions",
        "ALLERGIES" : "Allergies",
        "PRIMARY" : "Physician",
        "SPECIALIST" : "Specialist",
        "HISTORY" : "History",
        "UPCOMING_APPOINTMENT" : "Appointments",
        "OTHER" : "Notes"
    
    ]
    
    func appendChildDetails(
        Child: OCKPatient,
        FirstName : String,
        MiddleName: String = "",
        OtherName: [String] = [String](),
        FamilyName: String,
        Gender: GenderValue,
        Birthdate: Date,
        Weight: Int = 0,
        Height: Int = 0,
        MedicalConditions: [String] = [String](),
        Allergies: [String] = [String](),
        isActive: Bool = false,
        ActiveCarePlan: Bool = false,
        ActivePlanID: String = "",
        PrimaryPhysician: [OCKContact] = [OCKContact](),
        Specialist: [String:OCKContact] = [String:OCKContact](),
        ProfileImage: String = "",
        History: [String] = [String](),
        UpcomingAppointment: [AppointmentData] = [AppointmentData](),
        Other: [String:String] = [String:String]()
    ) {
        self.childDetails2[Child] =
            [
                "FIRST" : FirstName,
                "MIDDLE" : MiddleName,
                "OTHER_NAME" : OtherName,
                "LAST" : FamilyName,
                "BIRTHDATE" : Birthdate,
                "GENDER" : Gender,
                "WEIGHT" : Weight,
                "HEIGHT" : Height,
                "CONDITION" : MedicalConditions,
                "ALLERGIES" : Allergies,
                "IS_ACTIVE" : isActive,
                "ACTIVE_PLAN" : ActiveCarePlan,
                "ACTIVE_PLAN_ID" : ActivePlanID,
                "PRIMARY" : PrimaryPhysician,
                "SPECIALIST" : Specialist,
                "PROFILE_IMAGE" : ProfileImage,
                "HISTORY" : History,
                "UPCOMING_APPOINTMENT" : UpcomingAppointment,
                "OTHER" : Other
            ]
    }
    
    ///Used to append new Insurance details to the insuranceProviderDetails value.
    func appendInsuranceProvider (
        PrimaryHealth : InsuranceProvider,
        AdditionalCoverage : [String : InsuranceProvider] = [String : InsuranceProvider]()
    ){
        self.insuranceProviderDetails["MEDICAL"] = PrimaryHealth
        for key in AdditionalCoverage.keys {
            self.insuranceProviderDetails[key.uppercased()] = AdditionalCoverage[key]
        }
    }
    ///Used to append new guardian details to the GuardianDetails value.
    func appendGuardianDetails (
            Guardian: OCKContact,
            FirstName: String,
            FamilyName: String,
            GuardianAvatar: String,
            Primary: Bool
        ){
        self.guardianDetails2[Guardian] = [
                "FIRST" : FirstName,
                "LAST" : FamilyName,
                "GUARDIAN_AVATAR" : GuardianAvatar,
                "PIMARY" : String(Primary)
            ]
        }
    
    func appendFamilyDetails (
        FamilyName: String,
        FamilyImage: String = "",
        PrimaryGuardian: [OCKContact] = [OCKContact](),
        AdditionalGuardian: [OCKContact] = [OCKContact](),
        ActiveGuardian: [OCKContact] = [OCKContact](),
        Children: [OCKPatient] = [OCKPatient](),
        ActivePatient: [OCKPatient] = [OCKPatient](),
        ActiveAppointment: [AppointmentData] = [AppointmentData]()
    ) {
        self.familyDetails = [
            "LAST" : FamilyName,
            "FAMILY_PROFILE_IMAGE" : FamilyImage,
            "PRIMARY_GUARDIAN" : PrimaryGuardian,
            "ADDITIONAL_GUARDIAN" : AdditionalGuardian,
            "ACTIVE_GUARDIAN" : ActiveGuardian,
            "CHILDREN" : Children,
            "ACTIVE_PATIENT" : ActivePatient,
            "ACTIVE_APPOINTMENT" : ActiveAppointment
        ]
    }
    ///Add a plan ID to a childs history of events
    //Untested
    func addToHistory(child: OCKPatient, planID : String) {
        if self.childDetails2[child] == nil {
            return
        }
        var theHistory = self.childDetails2[child]!["HISTORY"] as! Array<String>
        theHistory.append(planID)
    }
    
    ///Add an appointment to a childs info.
    func addAppointment(child: OCKPatient, title: String, date: Date, notes: String?) {
        if self.childDetails2[child] != nil {
            let appointment = AppointmentData(title: title, date: date, notes: notes, child: child)
            var currentData = (self.childDetails2[child]!["UPCOMING_APPOINTMENT"] as? Array<AppointmentData>)
            if currentData != nil {
                currentData!.append(appointment)
                currentData!.sort()
                self.childDetails2[child]!["UPCOMING_APPOINTMENT"] = currentData!
            }
        }
    }
    
    ///Remove an appointment from a childs info.
    func removeAppointment(appointment: AppointmentData) {
        if self.childDetails2[appointment.child] != nil {
            let currentData = self.childDetails2[appointment.child]!["UPCOMING_APPOINTMENT"] as? Array<AppointmentData>
            if currentData != nil && !currentData!.isEmpty {
                let updatedList = currentData!.filter { $0 != appointment}
                self.childDetails2[appointment.child]!["UPCOMING_APPOINTMENT"] = updatedList
            }
        }
    }
    
    ///Function adds a child to the database in the app.
    func addChild(first: String,
                  middle: String = "",
                  otherName: [String] = [String](),
                  last: String,
                  gender: GenderValue,
                  birthdate: Date,
                  weight: Int = 0,
                  height: Int = 0,
                  conditions: [String] = [String](),
                  allergies: [String] = [String](),
                  isActive: Bool = false,
                  activeCarePlan: Bool = false,
                  activePlanID: String = "",
                  primary: [OCKContact] = [OCKContact](),
                  specialist: [String: OCKContact] = [String: OCKContact](),
                  profileImage: String = "",
                  history: [String] = [String](),
                  upcoming: [AppointmentData] = [AppointmentData](),
                  other: [String: String] = [String: String]()
    ) {
        //Use Date for a unique patientID
        let creationDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let creationString = formatter.string(from: creationDate)
        //Create an OCKPatient and an ID for that patient.
        let patientID = "\(first)-\(last)-\(creationString)"
        let newChild = OCKPatient(id: patientID, givenName: first, familyName: last)
        
        var currentData = self.childDetails2
        currentData[newChild] =
            [
                "FIRST" : first,
                "MIDDLE" : middle,
                "OTHER_NAME" : otherName,
                "LAST" : last,
                "BIRTHDATE" : birthdate,
                "GENDER" : gender,
                "WEIGHT" : weight,
                "HEIGHT" : height,
                "CONDITION" : conditions,
                "ALLERGIES" : allergies,
                "IS_ACTIVE" : isActive,
                "ACTIVE_PLAN" : activeCarePlan,
                "ACTIVE_PLAN_ID" : activePlanID,
                "PRIMARY" : primary,
                "SPECIALIST" : specialist,
                "PROFILE_IMAGE" : profileImage,
                "HISTORY" : history,
                "UPCOMING_APPOINTMENT" : upcoming,
                "OTHER" : other
            ]
        
        self.childDetails2 = currentData
        
        var childList = self.familyDetails["CHILDREN"] as? Array<OCKPatient>
        if childList != nil {
            childList!.append(newChild)
        } else {
            childList = [OCKPatient]()
            childList!.append(newChild)
        }
        self.familyDetails["CHILDREN"] = childList
    }
    
    ///Functions for fetching data
    
    ///Return True if the detail field has a non empty array or non zero-equivalent value
    func childDetailExists(child: OCKPatient, detail: String) -> Bool {
        if self.childDetails2[child] == nil {
            return false
        }
        let theDetail = self.childDetails2[child]![detail] as? Array<Any>
        if theDetail != nil && !theDetail!.isEmpty {
            return true
        }
        if theDetail == nil {
            let theDetail = self.childDetails2[child]![detail] as? Int
            if theDetail != nil && theDetail! != 0 {
                return true
            }
        }
        return false
    }
    
    ///Fetch detail labels for child details.
    func fetchChildDetailLabel(field: String) -> String {
        return self.childDetailLabels[field]!
    }
    
    ///Return the current Active Patient as OCKPatient
    func fetchActivePatient() -> OCKPatient {
        let patient = self.familyDetails["ACTIVE_PATIENT"] as? Array<OCKPatient>
        if patient != nil && !patient!.isEmpty {
            return patient![0]
        }
        else {
            let noPatient = OCKPatient(id: "appDefault", givenName: "Jan3", familyName: "C1eric")
            self.defaultPatient = noPatient
            return self.defaultPatient!
        }
    }
    
    ///Returns childs birthdate as a String
    func fetchChildBirthdate(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        let birthdate = self.childDetails2[child]!["BIRTHDATE"] as? Date
        if birthdate != nil {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let birthString = formatter.string(from: birthdate!)
            return birthString
        }
        return "Unavailable"
    }
    
    ///Returns the String value of the Profile Image Name
    func fetchProfileImage(child: OCKPatient) -> String {
        let childList = self.familyDetails["CHILDREN"] as? Array<OCKPatient>
        if childList != nil && !childList!.isEmpty {
            let image = self.childDetails2[child]!["PROFILE_IMAGE"] as! String
            return image
        }
        return "default_profile"
    }
    
    ///Returns a String of the Childs Allergies.
    func fetchAllergies(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        let allergyArray = (self.childDetails2[child]!["ALLERGIES"] as? Array<String>)
        if allergyArray != nil && !allergyArray!.isEmpty {
            let allergyString = allergyArray!.joined(separator: ",\n")
            return allergyString
        }
        return "None"
    }
    
    ///Returns a String of the childs First name.
    func fetchChildFirstName(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        guard let firstName = (self.childDetails2[child]!["FIRST"] as? String) else {
            return "Unspecified."
        }
        return firstName
    }
    ///Returns a String of the Childs last name
    func fetchChildLastName(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        guard let lastName = (childDetails2[child]!["LAST"] as? String) else {
            return "Unspecified"
        }
        return lastName
    }
    ///Returns a String of the childs full name.
    func fetchChildFullName(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        var nameArray = [String]()
        nameArray.append(self.fetchChildFirstName(child: child))
        let middleName = self.childDetails2[child]!["MIDDLE"] as? String
        if middleName != nil && middleName != ""{
            nameArray.append(middleName!)
        }
        let otherNames = (self.childDetails2[child]!["OTHER_NAME"] as? Array<String>)
        if otherNames != nil && !otherNames!.isEmpty {
            nameArray.append(otherNames!.joined(separator: " "))
        }
        nameArray.append(self.fetchChildLastName(child: child))
        let finalString = nameArray.joined(separator: " ")
        return finalString
    }
    
    ///Returns a String of the childs Gender
    func fetchChildGender(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        guard let gender = (self.childDetails2[child]!["GENDER"] as? GenderValue?) else {
            return "Unspecified"
        }
        if gender == .female {
            return "Female"
        } else {
            return "Male"
        }
    }
    
    ///Returns a string of the childs weight in lbs
    func fetchChildWeight(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        guard let weight = (self.childDetails2[child]!["WEIGHT"] as? Int) else {
            return "Weight not specified"
        }
        return "\(weight) lbs"
    }
    
    ///Returns a string of the childs height in inches or feet depending on size.
    func fetchChildHeight(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        guard let height = (self.childDetails2[child]!["HEIGHT"] as? Int) else {
            return "Unspecified"
        }
        if height > 24 {
            let feet = String(height / 12)
            let inches = String(height % 12)
            return "\(feet) feet \(inches) inches"
        }
        return "\(height) inches"
    }
    
    ///Returns a string of the childs known medical conditions.
    func fetchChildMedicalConditions(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        let conditionArray = (self.childDetails2[child]!["CONDITION"] as? Array<String>)
        if conditionArray != nil && !conditionArray!.isEmpty {
            let conditionString = conditionArray!.joined(separator: ",\n")
            return conditionString
        }
        return "None"
    }
    
    ///Returns a string of the childs Primary Physician
    func fetchPrimaryPhysicianName(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        let primary = (self.childDetails2[child]!["PRIMARY"] as? Array<OCKContact>)
        if primary != nil && !primary!.isEmpty {
            let physician = primary![0]
            let physicianFirstName = physician.name.givenName
            let physicianLastName = physician.name.familyName
            return "Dr. \(physicianFirstName!) \(physicianLastName!)"
        }
        return "Unspecified"
    }
    
    ///Returns a string of all known medical specialist associated with the child.
    func fetchSpecialistList(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        let specialistDict = (self.childDetails2[child]!["SPECIALIST"] as? Dictionary<String, OCKContact>)
        if specialistDict != nil && !specialistDict!.isEmpty {
            var formattedArray = [String]()
            let titles = Array(specialistDict!.keys)
            for item in titles {
                let specialistFirstName = specialistDict![item]!.name.givenName!
                let specialistLastName = specialistDict![item]!.name.familyName!
                formattedArray.append("Dr. \(specialistFirstName) \(specialistLastName)\n- \(item)")
            }
            return formattedArray.joined(separator: ",\n")
        }
        return "None"
    }
    
    ///Returns a string of the childs previous events and issues
    func fetchHistory(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        let history = (self.childDetails2[child]!["HISTORY"] as? Array<String>)
        if history != nil && !history!.isEmpty {
            return history!.joined(separator: ",\n")
        }
        return "No History Yet"
    }
    
    ///Returns a string of childs next upcoming appointment info.
    func fetchChildAppointment(child: OCKPatient) -> String {
        if self.childDetails2[child] == nil {
            return "No Such Child"
        }
        let data = self.childDetails2[child]!["UPCOMING_APPOINTMENT"] as? Array<AppointmentData>
        if data != nil && !data!.isEmpty {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let appointmentDate = formatter.string(from: (data![0].date))
            let appointmentTitle = data![0].title
            return "\(appointmentTitle)\n\(appointmentDate)"
        }
        return "No Scheduled Appointments"
    }
    
    ///Returns an array with each element formatted as "Title \n Date" of the appointments
    func fetchAllChildAppointmentsString(child: OCKPatient) -> [String] {
        if self.childDetails2[child] == nil {
            return ["No Such Child"]
        }
        let data = self.childDetails2[child]!["UPCOMING_APPOINTMENT"] as? Array<AppointmentData>
        if data != nil && !data!.isEmpty {
            var appointmentStringArray = [String]()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            for appointment in data! {
                let appointmentDate = formatter.string(from: appointment.date)
                let appointmentTitle = appointment.title
                let thisAppointment = "\(appointmentTitle)\n\(appointmentDate)"
                appointmentStringArray.append(thisAppointment)
            }
            return appointmentStringArray
        }
        return ["No Scheduled Appointments"]
    }
    
    ///Returns all appointments for all children in the "Title \n Date" format.
    func fetchAllAppointmentsString() -> [String] {
        let childList = self.familyDetails["CHILDREN"] as? Array<OCKPatient>
        if childList == nil {
            return ["Error: No Children have been added to the family."]
        }
        var fullAppointmentList = [String]()
        for child in childList! {
            let childName = child.name.givenName
            let sublist = self.fetchAllChildAppointmentsString(child: child)
            for items in sublist {
                let details = "\(childName!):\n \(items)"
                fullAppointmentList.append(details)
            }
        }
        return fullAppointmentList
    }
    
    ///Returns a list of all Children as [OCKPatient]
    func fetchAllChildren() -> [OCKPatient] {
        let children = self.familyDetails["CHILDREN"] as? [OCKPatient]
        if children != nil {
            return children!
        } else {
            return [OCKPatient]()
        }
    }
    ///Returns a list of all children as a string
    func fetchAllChildrenString() -> String {
        let childList = self.familyDetails["CHILDREN"] as? Array<OCKPatient>
        if childList != nil && !childList!.isEmpty {
            var nameArray = [String]()
            for child in childList! {
                let name = (child.name.givenName! + " " + child.name.familyName!)
                nameArray.append(name)
            }
            return nameArray.joined(separator: "\n")
        }
        return "No Children Specified."
    }
    
    ///Returns the Medical Insurance Provider name as a string
    func fetchBasicInsuranceInfo() -> String {
        let provider = self.insuranceProviderDetails["MEDICAL"]
        if provider != nil {
            return provider!.ProviderName
        }
        return "No Provider Listed"
    }
    
    ///Returns the Medical Insurance Provider object as InsuranceProvider type
    func fetchMedicalInsurance() -> InsuranceProvider {
        let provider = self.insuranceProviderDetails["MEDICAL"]
        if provider != nil {
            return provider!
        }
        let defaultProvider = InsuranceProvider(id: UUID(), ProviderName: "", HealthPlan: "", PlanTitle: "", MemberID: "", GroupNumber: "", ProviderContact: "", MemberContact: "", ClaimsAddress: "", AccountHolder: "", Dependents: [String](), InsuranceType: "", RXnumber: "", Copay: [Int]())
        return defaultProvider
    }
    
    ///Returns an Array of all appointments sorted by date as [AppointmentData]
    func fetchAllAppointments() -> [AppointmentData] {
        let childList = self.familyDetails["CHILDREN"] as? Array<OCKPatient>
        var sortedAppointments = [AppointmentData]()
        if childList != nil && !childList!.isEmpty {
            for child in childList! {
                let thisChildData = self.childDetails2[child]
                if thisChildData != nil {
                    let appointmentList = thisChildData!["UPCOMING_APPOINTMENT"] as? Array<AppointmentData>
                        if appointmentList != nil && !appointmentList!.isEmpty {
                            for item in appointmentList! {
                                sortedAppointments.append(item)
                            }
                        }
                }
            }
        }
        let final = sortedAppointments.sorted()
        return final
    }
    
    ///Returns an Array of all upcoming appointments for a specific child as [AppointmentData]
    func fetchAllChildAppointments(child: OCKPatient) -> [AppointmentData] {
        if self.childDetails2[child] == nil {
            return [AppointmentData]()
        }
        let data = self.childDetails2[child]!["UPCOMING_APPOINTMENT"] as? Array<AppointmentData>
        if data != nil && !data!.isEmpty {
            return data!.sorted()
        }
        else {
            return [AppointmentData]()
        }
        
    }
    
    ///Returns the next appointment for a specific child as AppointmentData
    func fetchNextChildAppointment(child: OCKPatient) -> AppointmentData? {
        let sortedList = self.fetchAllChildAppointments(child: child)
        if !sortedList.isEmpty {
            return sortedList[0]
        }
        return nil
    }
    
    ///Return the next appointment from all appointment dates as AppointmentData
    func fetchNextAppointment() -> AppointmentData? {
        let sortedList = self.fetchAllAppointments()
        if !sortedList.isEmpty {
            return sortedList[0]
        }
        return nil
    }
    
    func fetchNextChildAppointmentString(child: OCKPatient) -> String {
        let nextAppointment = self.fetchNextChildAppointment(child: child)
        if nextAppointment != nil {
            let title = nextAppointment!.title
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let date = formatter.string(from: nextAppointment!.date)
            return "\(title)\n\(date)"
        }
        return "No Upcoming Appointments"
    }
    
    ///Returns a String describing the Name and Date of the next upcoming appointment.
    func fetchNextAppointmentString() -> String {
        let nextAppointment = self.fetchNextAppointment()
        if nextAppointment != nil {
            let title = nextAppointment!.title
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let date = formatter.string(from: nextAppointment!.date)
            return "\(title)\n\(date)"
        }
        return "No Upcoming Appointments"
    }
    ///Returns a string array of the Name, title, address, and phone number of a given OCKContact if they are a .careProvider
    func fetchMedicalProviderDetails(provider: OCKContact) -> [String]? {
        if provider.category != .careProvider {
            return nil
        }
        let name = "Dr. \(provider.name.givenName ?? "Unknown") \(provider.name.familyName ?? "Unknown")"
        let title = provider.title ?? "Unknown"
        let street = provider.address?.street ?? "Unknown"
        let city = provider.address?.city ?? "Unknown"
        let state = provider.address?.state ?? "Unknown"
        let zip = provider.address?.postalCode ?? "Unknown"
        let address = "\(street)\n\(city), \(state) \(zip)"
        let phoneNumber = provider.phoneNumbers?[0].value
        
        return [name, title, address, phoneNumber ?? "Unknown"]
    }
    
    ///Returns a list of OCKContacts comprised of all medical providers associated with children
    func fetchAllMedicalProviders() -> [OCKContact] {
        let children = self.fetchAllChildren()
        var providerList = [OCKContact]()
        if !children.isEmpty {
            for child in children {
                if self.childDetails2[child] != nil {
                    let primaryList = self.childDetails2[child]!["PRIMARY"] as? Array<OCKContact>
                        if primaryList != nil && !primaryList!.isEmpty {
                            for physician in primaryList! {
                                if physician.category == .careProvider {
                                    providerList.append(physician)
                                }
                            }
                        }
                    let specialistDict = self.childDetails2[child]!["SPECIALIST"] as? Dictionary<String,OCKContact>
                    if specialistDict != nil && !specialistDict!.isEmpty {
                        let specialistList = Array(specialistDict!.values)
                        if !specialistList.isEmpty {
                            for specialist in specialistList {
                                if specialist.category == .careProvider {
                                    providerList.append(specialist)
                                }
                            }
                        }
                    }
                }
            }
            
        }
        return providerList.removingDuplicates()
    }
    
    
    
    //activeCarePlan identifies any current care plan associated with a patient
    #if targetEnvironment(simulator)
    let clericStore = OCKStore(name: "ClericStore", type: .inMemory)
    let clericHealthKitStore = OCKHealthKitPassthroughStore(name: "ClericHealthKitStore", type: .inMemory)
    #else
    let clericStore = OCKStore(name: "ClericStore", type: .onDisk)
    let clericHealthKitStore = OCKHealthKitPassthroughStore(name: "ClericHealthKitStore", type: .onDisk)
    #endif
    let coordinator = OCKStoreCoordinator()
    
    lazy private(set) var storeManager: OCKSynchronizedStoreManager = {
        coordinator.attach(store: clericStore)
        coordinator.attach(eventStore: clericHealthKitStore)
        let manager = OCKSynchronizedStoreManager(wrapping: coordinator)
        return manager
    }()
    
    
    private init() {
        self.resources = SymptomList()
        loadDemoFamily()
        
    }
    
    private func loadDemoFamily() {
        clericStore.populateFamilyData()
        
        let guardian1 = OCKContact(id: "lauren-bice", givenName: "Lauren", familyName: "Bice", carePlanUUID: nil)
        
        let guardian2 = OCKContact(id: "jason-bice", givenName: "Jason", familyName: "Bice", carePlanUUID: nil)
        
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
        dateComponents.hour = 13
        dateComponents.minute = 45
        let appointment1 = calendar.date(from: dateComponents)
        
        dateComponents.year = 2020
        dateComponents.month = 12
        dateComponents.day = 12
        dateComponents.hour = 11
        dateComponents.minute = 15
        let appointment0 = calendar.date(from: dateComponents)
        
        var child1 = OCKPatient(id: "julie-bice", givenName: "Julie", familyName: "Bice")
        child1.allergies = ["Tree nuts"]
        child1.birthday = birthDate1
        
        
        var child2 = OCKPatient(id: "allister-bice", givenName: "Allister", familyName: "Bice")
        child2.allergies = ["No allergies"]
        child2.birthday = birthDate2
        
        self.defaultPatient = OCKPatient(id: "default_patient", givenName: "Rodrick", familyName: "Bigface")
        
        self.childMembers = [child1, child2]
        self.guardianMembers = [guardian1, guardian2]
        self.guardianImages = [guardian1: "Avatar08", guardian2: "Avatar03" ]
        self.activeGuardian = guardian1
        self.guardianDetails = [guardian1: ["Name": "Lauren", "Children": "Julie, Allister", "Provider": "Village Pediatrics", "Insurance" : "UHC", "Appointments":"Julie - November 11"], guardian2: ["Name": "Jason", "Children": "Julie, Allister", "Provider": "Village Pediatrics"]]
        
        self.profileImages = [child1: "Julie", child2 : "Allister", defaultPatient!: "default_profile"]
        self.familyName = "Bice"
        self.childDetails = [child1 : ["Name" : "Julie", "Age" : "4", "Weight" : "42 LBS", "Height": "41 Inches", "Medical Conditions" : "Mild Heart Murmur", "Allergies" : "Tree nuts, Cat Dander"], child2 : ["Name" : "Allister", "Age" : "Infant", "Weight": "22 LBS", "Height": "33 Inches", "Medical Conditions" : "None"]]
        
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
        doctor1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(470) 578-3402")]
        
        var specialist1 = OCKContact(id: "Specialist1-Julie", givenName: "Robert", familyName: "Zemekis", carePlanUUID: nil)
        specialist1.category = .careProvider
        specialist1.title = "Cardiologist"
        specialist1.address = {
            let address = OCKPostalAddress()
            address.street = "9303 Lyon Drive"
            address.city = "Hill Valley"
            address.state = "GA"
            address.postalCode = "30038"
            return address
        }()
        specialist1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(770) 555-4823")]
        
        var specialist2 = OCKContact(id: "Specialist2-Allister", givenName: "Emmet", familyName: "Brown", carePlanUUID: nil)
        specialist2.category = .careProvider
        specialist2.title = "Dermatologist"
        specialist2.address = {
            let address = OCKPostalAddress()
            address.street = "9303 Lyon Drive"
            address.city = "Hill Valley"
            address.state = "GA"
            address.postalCode = "30038"
            return address
        }()
        specialist2.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(540) 525-7498")]
        
        let appointmentDemo = AppointmentData(title: "Heart Murmur Checkup", date: appointment1!, notes: "Routine check on the heart murmur. Should get details on if playing in preschool soccer is going to be okay.", child: child1)
        
        let appointmentDemo2 = AppointmentData(title: "Well Check", date: appointment0!, notes: "Regular Well Check with imunizations.", child: child1)
        
        self.appendChildDetails(Child: child1, FirstName: "Julie", MiddleName: "Nancy", FamilyName: "Bice", Gender: .female, Birthdate: birthDate1!, Weight: 44, Height: 46, MedicalConditions: ["Mild Heart Murmur"], Allergies: ["Tree nuts", "Cat Dander"], PrimaryPhysician: [doctor1], Specialist: ["Pediatric Cardiologist" : specialist1], ProfileImage: "Julie", UpcomingAppointment: [appointmentDemo, appointmentDemo2], Other: ["Custom Example Field" : "Custom Example Text"])
        
        self.appendChildDetails(Child: child2, FirstName: "Allister", MiddleName: "Gregory", FamilyName: "Bice", Gender: .male, Birthdate: birthDate2!, Weight: 27, Height: 23, MedicalConditions: ["None"], Allergies: ["Shellfish", "Cat Dander"], PrimaryPhysician: [doctor1],  Specialist: ["Dermatologist" : specialist2], ProfileImage: "Allister", Other: ["Custom Example Field 2" : "Custom Example Text 2"])
        
        let primaryProvider = InsuranceProvider(id: UUID(), ProviderName: "United Health Care", HealthPlan: "911-87726-09", PlanTitle: "Saver Plus PPO", MemberID: "859173444", GroupNumber: "700408", ProviderContact: "877-842-3210", MemberContact: "866-348-1286", ClaimsAddress: "PO Box 30555\nSalt Lake City, UT 84130-0555", AccountHolder: "Jackson Bice", Dependents: ["Amy Bice", "Julie Bice", "Allister Bice"], InsuranceType: "Medical", RXnumber: "993766GM", Copay: [10, 15, 30])
        
        let additionalProvider = InsuranceProvider(id: UUID(), ProviderName: "Vision Pro Plus", HealthPlan: "553-081-889", PlanTitle: "Diamond Member", MemberID: "00143-5A", GroupNumber: "523-EBC", ProviderContact: "555-831-5293", MemberContact: "555-239-9987", ClaimsAddress: "POBox 5538\nMetropolis NY 10038-5537", AccountHolder: "Jackson Bice", Dependents: ["Amy Bice", "Julie Bice", "Allister Bice"], InsuranceType: "Vision")
        
        self.activePatient = child1
        
        self.appendGuardianDetails(Guardian: guardian1, FirstName: guardian1.name.givenName!, FamilyName: guardian1.name.familyName!, GuardianAvatar: "Avatar08", Primary: true)
        
        self.appendGuardianDetails(Guardian: guardian2, FirstName: guardian2.name.givenName!, FamilyName: guardian2.name.familyName!, GuardianAvatar: "Avatar02", Primary: false)
        
        self.appendInsuranceProvider(PrimaryHealth: primaryProvider, AdditionalCoverage: ["Vision" : additionalProvider])
        
        self.appendFamilyDetails(FamilyName: guardian1.name.familyName!, FamilyImage: "FamilyStockImage", PrimaryGuardian: [guardian1], AdditionalGuardian: [guardian2], ActiveGuardian: [guardian1], Children: [child1,child2], ActivePatient: [child1])
        
        
        
    }

}

/*
class ClericStore: ObservableObject {
    static let shared = ClericStore()
    static let defaultContact = OCKContact(id: "defaultContact", givenName: "Default", familyName: "C1eric", carePlanUUID: nil)
    static let defaultChild = OCKPatient(id: "defaultChild", givenName: "DefaultChild", familyName: "C1eric")
    @Published var familyName: String? = nil
    @Published var defaultPatient: OCKPatient? = nil
    @Published var familyImage: String? = nil
    @Published var memberIDs: [String?] = []
    @Published var childMembers: [OCKPatient?] = []
    @Published var activeGuardian: OCKContact? = nil
    @Published var activePatient: OCKPatient? = nil
    @Published var guardianMembers: [OCKContact?] = []
    @Published var currentChildProfile: OCKPatient? = nil
    @Published var currentGuardianProfile: OCKContact? = nil
    @Published var guardianImages: [OCKContact: String]? = nil
    @Published var activeCarePlan = [OCKPatient : String]()
    @Published var selectedPatient: OCKPatient? = nil
    @Published var profileImages: [OCKPatient : String]? = nil
    @Published var childDetails: [OCKPatient : [String:String]]? = nil
    @Published var guardianDetails: [OCKContact : [String:String]]? = nil
    
    @Published var childDetails2 = [OCKPatient : [String:Any]]()
    @Published var guardianDetails2: [OCKContact : [String:String]] = [OCKContact : [String:String]]()
    @Published var familyDetails: [String : Any] = [String : Any]()
    @Published var insuranceProviderDetails: [String : InsuranceProvider] = [String : InsuranceProvider]()
    
    
    enum GenderValue {
        case male, female
    }
    /*childDetails2 - [OCKPatient : [String : Any]]
    Parameters:
     FirstName : String (Required)
     MiddleName: String (Optional) default ""
     FamilyName: String (Required)
     Birthdate: Date (Required) default Jan 01 2020
     Gender: GenderValue (Required)
     Weight: Double (Optional) default 0.0
     Height: Double (Optional) default 0.0
     Medical Conditions: [String] (Optional) default [""]
     Allergies: [String] (Optional) default [""]
     isActive: Bool (Required)
     ActiveCarePlan: Bool (Required)
     ActivePlanID: String (Optional) default ""
     Primary Physician: OCKContact (Optional) default defaultContact
     Specialist: [String:OCKContact] (Optional) default ["":defaultContact]
     ProfileImage: String (Optional) default ""
     History: [String] (Optional) default [""]
     UpcomingAppointment: [String : Date] (Optional) default empty
     Other: [String:String] (Optional) default empty
     
     
     familyDetails - [String : Any]
     Parameters:
     FamilyName: String (Required)
     FamilyImage: String (Optional) default defaultImageName
     PrimaryGuardian: OCKContact (Required)
     AdditionalGuardian: [OCKContact] (Optional) default []
     ActiveGuardian: OCKContact (Required) defaultf PrimaryGuardian value
     Children: [OCKPatient] (Required)
     
     guardianDetails2 - [OCKContact : [String : Any]]
     Parameters:
     FirstName : String (Required)
     FamilyName: String (Required)
     
     
     insuranceProviderDetails - [String: Any]
     Parameters:
     Providers : [String : InsuranceProvider] (Required)
    */
    
    //TODO - add methods for updating these values.
    ///Used to add
    func appendChildDetails(
        Child: OCKPatient,
        FirstName : String,
        MiddleName: String = "",
        OtherName: [String] = [String](),
        FamilyName: String,
        Gender: GenderValue,
        Birthdate: Date,
        Weight: Double = 0.0,
        Height: Double = 0.0,
        MedicalConditions: [String] = [String](),
        Allergies: [String] = [String](),
        isActive: Bool = false,
        ActiveCarePlan: Bool = false,
        ActivePlanID: String = "",
        PrimaryPhysician: [OCKContact] = [OCKContact](),
        Specialist: [String:OCKContact] = [String:OCKContact](),
        ProfileImage: String = "",
        History: [String] = [String](),
        UpcomingAppointment: [String:Date] = [String:Date](),
        Other: [String:String] = [String:String]()
    ) {
        self.childDetails2[Child] =
            [
                "FIRST" : FirstName,
                "MIDDLE" : MiddleName,
                "OTHER NAME" : OtherName,
                "LAST" : FamilyName,
                "BIRTHDATE" : Birthdate,
                "GENDER" : Gender,
                "WEIGHT" : Weight,
                "HEIGHT" : Height,
                "CONDITION" : MedicalConditions,
                "ALLERGIES" : Allergies,
                "IS_ACTIVE" : isActive,
                "ACTIVE_PLAN" : ActiveCarePlan,
                "ACTIVE_PLAN_ID" : ActivePlanID,
                "PRIMARY" : PrimaryPhysician,
                "SPECIALIST" : Specialist,
                "PROFILE_IMAGE" : ProfileImage,
                "HISTORY" : History,
                "UPCOMING_APPOINTMENT" : UpcomingAppointment,
                "OTHER" : Other
            ]
    }
    ///Used to append new Insurance details to the insuranceProviderDetails value.
    func appendInsuranceProvider (
        PrimaryHealth : InsuranceProvider,
        AdditionalCoverage : [String : InsuranceProvider] = [String : InsuranceProvider]()
    ){
        self.insuranceProviderDetails["MEDICAL"] = PrimaryHealth
        for key in AdditionalCoverage.keys {
            self.insuranceProviderDetails[key.uppercased()] = AdditionalCoverage[key]
        }
    }
    ///Used to append new guardian details to the GuardianDetails value.
    func appendGuardianDetails (
            Guardian: OCKContact,
            FirstName: String,
            FamilyName: String,
            GuardianAvatar: String,
            Primary: Bool
        ){
        self.guardianDetails?[Guardian] = [
                "FIRST" : FirstName,
                "LAST" : FamilyName,
                "GUARDIAN_AVATAR" : GuardianAvatar,
                "PIMARY" : String(Primary)
            ]
        }
    
    func appendFamilyDetails (
        FamilyName: String,
        FamilyImage: String = "",
        PrimaryGuardian: [OCKContact] = [OCKContact](),
        AdditionalGuardian: [OCKContact] = [OCKContact](),
        ActiveGuardian: [OCKContact] = [OCKContact](),
        Children: [OCKPatient] = [OCKPatient]()
    ) {
        self.familyDetails = [
            "LAST" : FamilyName,
            "FAMILY_PROFILE_IMAGE" : FamilyImage,
            "PRIMARY_GUARDIAN" : PrimaryGuardian,
            "ADDITIONAL_GUARDIAN" : AdditionalGuardian,
            "ACTIVE_GUARDIAN" : ActiveGuardian,
            "CHILDREN" : Children,
            "ACTIVE_PATIENT" : ActivePatient ?? defaultChild
        ]
    }
    
    //activeCarePlan identifies any current care plan associated with a patient
    let clericStore = OCKStore(name: "ClericStore", type: .onDisk)
    let clericHealthKitStore = OCKHealthKitPassthroughStore(name: "ClericHealthKitStore", type: .onDisk)
    let coordinator = OCKStoreCoordinator()
    
    lazy private(set) var storeManager: OCKSynchronizedStoreManager = {
        coordinator.attach(store: clericStore)
        coordinator.attach(eventStore: clericHealthKitStore)
        let manager = OCKSynchronizedStoreManager(wrapping: coordinator)
        return manager
    }()
    
    private init() {loadDemoFamily()}
    
    private func loadDemoFamily() {
        clericStore.populateFamilyData()
        
        let guardian1 = OCKContact(id: "amy-bice", givenName: "Amy", familyName: "Bice", carePlanUUID: nil)
        
        let guardian2 = OCKContact(id: "jackson-bice", givenName: "Jackson", familyName: "Bice", carePlanUUID: nil)
        
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
        
        var child1 = OCKPatient(id: "julie-bice", givenName: "Julie", familyName: "Bice")
        child1.allergies = ["Tree nuts"]
        child1.birthday = birthDate1
        
        
        var child2 = OCKPatient(id: "allister-bice", givenName: "Allister", familyName: "Bice")
        child2.allergies = ["No allergies"]
        child2.birthday = birthDate2
        
        var doctor1 = OCKContact(id: "Primary-Julie", givenName: "Shalii", familyName: "Shah", carePlanUUID: nil)
        doctor1.category = .careProvider
        doctor1.title = "Primary Pediatrician"
        doctor1.address = {
            let address = OCKPostalAddress()
            address.street = "7165 Colfax Avenue"
            address.city = "Cumming"
            address.state = "GA"
            address.postalCode = "30040"
            return address
        }()
        
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
        
        self.defaultPatient = OCKPatient(id: "default_patient", givenName: "Rodrick", familyName: "Bigface")
        
        self.childMembers = [child1, child2]
        self.guardianMembers = [guardian1, guardian2]
        self.guardianImages = [guardian1: "Avatar08", guardian2: "Avatar03" ]
        self.activeGuardian = guardian1
        self.guardianDetails = [guardian1: ["Name": "Lauren", "Children": "Julie, Allister", "Provider": "Village Pediatrics", "Insurance" : "UHC", "Appointments":"Julie - November 11"], guardian2: ["Name": "Jason", "Children": "Julie, Allister", "Provider": "Village Pediatrics"]]
        
        self.profileImages = [child1: "Julie", child2 : "Allister", defaultPatient!: "default_profile"]
        
        self.familyName = "Bice"
        
        self.childDetails = [child1 : ["Name" : "Julie", "Age" : "4", "Weight" : "42 LBS", "Height": "41 Inches", "Medical Conditions" : "Mild Heart Murmur", "Allergies" : "Tree nuts, Cat Dander"], child2 : ["Name" : "Allister", "Age" : "Infant", "Weight": "22 LBS", "Height": "33 Inches", "Medical Conditions" : "None"]]
        
        self.activePatient = child1
        

    }
}
*/

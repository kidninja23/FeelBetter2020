//
//  ChildScreen.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/10/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore


enum SheetOptions {
    case none, diagnosis, carePlan
}

struct ChildScreen: View {
    @EnvironmentObject var store: ClericStore
    //@State var showSheet: Bool = false
    @State private var sheetSelection: SheetOptions = .diagnosis
    @Binding var showMenu: Bool
    @Environment(\.presentationMode) var presentationMode
    @State var preferImageEditor: Bool = false
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    var child: OCKPatient
    
        
    var body: some View {
        //static var child = self.store.fetchActivePatient()
        let gender = self.store.fetchChildGender(child: child)
        
            VStack {
                ChildProfileImage(child: child).environmentObject(store)
                    .padding()
                    .onLongPressGesture {
                        self.preferImageEditor = true
                        self.showingImagePicker = true
                    }
                Text(self.store.fetchChildFirstName(child: child)).bold()
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                ScrollView {
                    InformationFieldWithDetail(label: "Next Appointment", info: self.store.fetchNextChildAppointmentString(child: child), detailView: AppointmentsScreen().environmentObject(store))
                    InformationField(label: "Birthdate", info: self.store.fetchChildBirthdate(child: child))
                    InformationField(label: "Gender", info: self.store.fetchChildGender(child: child))
                    if self.store.childDetailExists(child: child, detail: "HEIGHT") {
                        InformationField(label: "Height", info: self.store.fetchChildHeight(child: child))
                    }
                    if self.store.childDetailExists(child: child, detail: "WEIGHT") {
                        InformationField(label: "Weight", info: self.store.fetchChildWeight(child: child))
                    }
                    if self.store.childDetailExists(child: child, detail: "ALLERGIES") {
                        InformationField(label: "Allergies", info: self.store.fetchAllergies(child: child))
                    }
                    //TODO - Add feature to link conditions to those conditions in the resource guide.
                    if self.store.childDetailExists(child: child, detail: "CONDITION") {
                        InformationField(label: "Conditions", info: self.store.fetchChildMedicalConditions(child: child))
                    }
                    //TODO - Replace Doctor views with link to contact page.
                    if self.store.childDetailExists(child: child, detail: "PRIMARY") {
                        InformationField(label: "Physician", info: self.store.fetchPrimaryPhysicianName(child: child))
                    }
                    if self.store.childDetailExists(child: child, detail: "SPECIALIST") {
                        InformationField(label: "Specialist(s)", info: self.store.fetchSpecialistList(child: child))
                    }
                    if self.store.childDetailExists(child: child, detail: "HISTORY") {
                        InformationField(label: "History", info: self.store.fetchHistory(child: child))
                    }
                    
                }//End ScrollView
                    switch gender {
                    case "Male":
                        ChildProfileSheetButton("New Event") {
                            MaleBodySectionSelector(child: child).environmentObject(store)
                        }
                        
                    case "Female":
                        ChildProfileSheetButton("New Event") {
                            FemaleBodySectionSelector(child: child).environmentObject(store)
                        }
                    
                    default:
                        ChildProfileSheetButton("New Event") {
                            MaleBodySectionSelector(child: child).environmentObject(store)
                        }
                    }
                
                Spacer()
            }.if(preferImageEditor) { $0.sheet(isPresented: $showingImagePicker, onDismiss: {
                loadImage()
                if store.childDetails2[child] != nil {
                    store.childDetails2[child]!["PROFILE_IMAGE"] = image
                }
            }, content: {
                ImagePicker(selectedImage: self.$inputImage)
            })}
            .background(Color(UIColor.systemTeal)).frame(width: .infinity, height: .infinity, alignment: .center)
            .navigationBarTitle("",displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(
                        action: {self.showMenu.toggle()},
                        label: { Image(systemName: "line.horizontal.3")})
                            .buttonStyle(PlainButtonStyle())
            )
        
    }
    
    func getChildDetailsMap(_ patient: OCKPatient) -> [String:String] {
        return (ClericStore.shared.childDetails?[patient]!)!
    }
    func loadImage() {
        self.preferImageEditor = false
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct ChildProfileImage: View {
    @EnvironmentObject var store: ClericStore
    var child: OCKPatient
    var body: some View {
        if store.childDetails2[child] != nil {
            let theImage = store.childDetails2[child]!["PROFILE_IMAGE"]
            if let theImage = theImage as? String {
                Image(theImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .frame(width: 250, height: 250, alignment: .center)
            } else {
                (theImage as! Image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .frame(width: 250, height: 250, alignment: .center)
            }
        }
    }
}

struct ChildProfileSheetButton<Content>: View where Content: View {
    var text: String
    var content: Content
    @State var isPresented = false
    
    init(_ text: String, @ViewBuilder content: () -> Content) {
        self.text = text
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }, label: {
            Text(text)
                .bold()
                .font(.system(size: 24, weight: .bold, design: .rounded))
        }).buttonStyle(CarePlanStyle())
        .sheet(isPresented: $isPresented) {
            self.content
        }
    }
}

struct ProfileDetailView: View {
    @EnvironmentObject var store: ClericStore
    var item: String
    
    var body: some View {
        let patient = store.activePatient
        let detailMap = store.childDetails![patient!]
        //TODO - Update for longer text strings
        if detailMap?[item] != nil {
            HStack {
                Text("\(item): ").bold()
                    .font(.system(size: 18, weight: .bold, design: .rounded)).padding()
                Spacer()
                Text((detailMap?[item]!)!).bold()
                    .font(.system(size: 18, weight: .bold, design: .rounded)).padding()
            }
            .frame(width: .infinity, height: .infinity, alignment: .center )
            .background(Color.white)
            .cornerRadius(5)
            .shadow(radius: 3)
            .padding(.leading)
            .padding(.trailing)
            
            
        }
        
    }
}
struct ChildScreen_Previews: PreviewProvider {
    static var store = ClericStore.shared
    static var child = store.fetchActivePatient()
    static var previews: some View {
        ChildScreen(showMenu: .constant(false), child: child).environmentObject(ClericStore.shared)
    }
}

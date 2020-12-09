//
//  AddAppointment.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/7/20.
//

import SwiftUI
import CareKitStore

struct AddAppointment: View {
    private let now = Date()
    @EnvironmentObject var store: ClericStore
    @State private var date = Date()
    @State private var title: String = ""
    @State private var notes: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State var childSelected: Bool = false
    @State var selected: Bool = false
    @State var choice: OCKPatient? = nil
    @State var highlighted: Bool = false
    

    var body: some View {
        //TODO - Replace active patient with selector menu of all children.
        let children = self.store.fetchAllChildren()
        VStack {
            HStack {
                
            }
            Text("New Appointment")
                .bold()
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Form {
                ScrollView (.horizontal){
                    HStack {
                        ForEach(children, id:\.self) { child in
                            ChildSelector(childImage: child, selected: $selected, choice: $choice, highlighted: $highlighted)
                        }
                    }
                }
                HStack {
                    Text("Reason:")
                        .bold()
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                TextField("Reason", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                DatePicker("Date:", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    .padding()
                MultilineTextField("Notes", text: $notes, onCommit: {})
                
            }
            HStack {
                if !title.isEmpty && date != now && selected {
                    Button(action: {
                        if choice != nil {
                            self.store.addAppointment(child: choice!, title: title, date: date, notes: notes)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Save")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }).buttonStyle(CarePlanStyle()).padding(.leading)
                }
                Spacer()
                Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                    Text("Cancel")
                        .bold()
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                }).buttonStyle(CancelStyle()).padding(.trailing)
            }

        }.frame(width: .infinity, height: .infinity, alignment: .center)
    }
}

struct ChildSelector: View {
    @EnvironmentObject var store: ClericStore
    var childImage: OCKPatient
    @State var shadow: Bool = false
    @Binding var selected: Bool
    @Binding var choice: OCKPatient?
    @Binding var highlighted: Bool
    
    var body: some View {
        let image = self.store.fetchProfileImage(child: childImage)
        Button(action: {
            if highlighted && shadow {
                self.highlighted = false
                self.shadow = false
                self.selected = false
                self.choice = nil
            }
            else if highlighted {
                //self.shadow = true
                //self.selected = true
                //self.choice = childImage
            }
            else {
                self.highlighted = true
                self.shadow = true
                self.selected = true
                self.choice = childImage
            }
            
        }, label: {
            if let image = image as? String {
                if !image.isEmpty {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .frame(width: 80, height: 80, alignment: .center)
                } else {
                    Image("default_profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .frame(width: 80, height: 80, alignment: .center)
                }
            } else {
                (image as! Image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .frame(width: 80, height: 80, alignment: .center)
            }
        })
        .frame(width: 110, height: 110, alignment: .center)
        .if(shadow) { $0.shadow(color: Color.blue, radius: 8) }
    }
}
#if DEBUG
struct AddAppointment_Previews: PreviewProvider {
    static var previews: some View {
        AddAppointment().environmentObject(ClericStore.shared)
    }
}
#endif

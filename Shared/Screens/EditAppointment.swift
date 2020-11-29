//
//  EditAppointment.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/10/20.
//

import SwiftUI

struct EditAppointment: View {
    private let now = Date()
    @EnvironmentObject var store: ClericStore
    @State private var date: Date = Date()
    @State private var title: String = ""
    @State private var notes: String = ""
    var appointment: AppointmentData
    @Binding var showEditor: Bool
    @State var confirmDelete: Bool = false

    var body: some View {
        ZStack {
            VStack {
                Form {
                    HStack {
                        Text("Reason:")
                            .bold()
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    TextField("\(title)", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    }
                    DatePicker("Date:", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .padding()
                    MultilineTextField((notes == "" ? "Notes" : ""), text: $notes, onCommit: {})
                    HStack {
                        Spacer()
                        Button(action: {self.confirmDelete = true}, label: {
                            Image("Delete")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                        })
                    }
                    
                }
                .frame(width: .infinity, height: 325, alignment: .center)
                HStack {
                    Button(action: {
                        self.appointment.date = date
                        self.appointment.title = title
                        self.appointment.notes = notes
                        self.store.redraw.toggle()
                        self.showEditor.toggle()
                        
                    }, label: {
                        Text("Save")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }).buttonStyle(CarePlanStyle())
                    Spacer()
                    Button(action: {
                        self.showEditor.toggle()
                    }, label: {
                        Text("Cancel")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }).buttonStyle(CancelStyle())
                }
            }
            .onAppear(perform: {loadValues()})
            .padding()
            .if(confirmDelete) { $0.blur(radius: 10)}
            
            if confirmDelete {
                ConfirmDelete(confirmDelete: $confirmDelete, showEditor: $showEditor, appointment: appointment)
                }
            }
        
    }

        func loadValues() {
            self.date = appointment.date
            self.title = appointment.title
            self.notes = appointment.notes ?? "Notes"
        }
}

struct ConfirmDelete: View {
    @EnvironmentObject var store: ClericStore
    @Binding var confirmDelete: Bool
    @Binding var showEditor: Bool
    var appointment: AppointmentData
    
    var body: some View {
        VStack {
            Text("Are you sure you want to delete this appointment? This action can not be undone.")
                .font(.body)
                .frame(width: 300, height: 100, alignment: .center)
                .background(Color.white)
                .border(Color.red)
                .shadow(radius: 5)
                
                
            HStack {
                Button(action: {
                    self.store.removeAppointment(appointment: appointment)
                    self.confirmDelete = false
                    self.showEditor = false
                }, label: {
                    Text("Confirm")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                }).buttonStyle(CarePlanStyle()).padding(.leading)
                Spacer()
                Button(action: {self.confirmDelete = false}, label: {
                    Text("Cancel")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                }).buttonStyle(CancelStyle()).padding(.trailing)
            }
        }
        .frame(width: .infinity, height: 400, alignment: .center)
    }
}

#if DEBUG
struct EditAppointment_Previews: PreviewProvider {
    static var myDate: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 12
        dateComponents.day = 12
        dateComponents.hour = 13
        let calendar = Calendar.current
        let theDate = calendar.date(from: dateComponents)!
        return theDate
    }
    static var myAppointment = AppointmentData(title: "Test Appointment", date: myDate, notes: "Let's make some notes for fun.", child: ClericStore.shared.activePatient!)
    static var previews: some View {
        EditAppointment(appointment: myAppointment, showEditor: .constant(false)).environmentObject(ClericStore.shared)
    }
}
#endif

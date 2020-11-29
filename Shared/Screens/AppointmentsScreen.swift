//
//  AppointmentsScreen.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/4/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

struct AppointmentsScreen: View {
    @EnvironmentObject var store: ClericStore
    @State var upcomingSelected: Bool = true
    @State var completedSelected: Bool = false
    @State var showEditor: Bool = false
    @State var selectedAppointment: AppointmentData? = nil
    
    
    var body: some View {
        let children = self.store.fetchAllChildren()
        ZStack {
            VStack {
                Spacer()
                Text("Appointments")
                    .bold()
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding()
                    .padding(.top)
                    .padding(.top)
                HStack {
                    Spacer()
                    Button(action: {
                        upcomingSelected = true
                        completedSelected = false
                    }, label: {
                        Text("Upcoming")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }).buttonStyle(CancelStyleThin())
                    .if(upcomingSelected) { $0.shadow(color: Color.blue.opacity(0.9), radius: 10, x: 0, y: 10)}
                    
                    Spacer()
                    Button(action: {
                        upcomingSelected = false
                        completedSelected = true
                    }, label: {
                        Text("Completed")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            
                    }).buttonStyle(CancelStyleThin())
                    .if(completedSelected) { $0.shadow(color: Color.blue.opacity(0.9), radius: 10, x: 0, y: 10)}
                    Spacer()
                }.padding(.bottom).padding(.bottom).padding(.bottom).padding(.bottom)
                VStack {
                    ScrollView {
                        ForEach(children, id: \.self) { child in
                            let appointmentList = self.store.fetchAllChildAppointments(child: child)
                            Text(child.name.givenName!)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            ForEach(appointmentList, id: \.self) { appointment in
                                AppointmentFieldViw(showEditor: $showEditor, appointment: appointment)
                            }
                            if appointmentList.isEmpty {
                                HStack {
                                    Text("No Scheduled Appointments")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .padding()
                                        
                                }
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(5)
                                .shadow(radius: 3)
                                    
                            }
                        }
                    }
                }
                HStack {
                    Spacer()
                    AppointmentSheetButton(imageName: "AddAppointment") {
                        AddAppointment()
                    }
                    .padding(.trailing)
                }
                Spacer()
                
            }.if(showEditor){ $0.blur(radius: 3.0) }
            if showEditor {
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color(UIColor.systemGray6))
                        .opacity(0.3)
                    EditAppointment(appointment: store.familyDetails["ACTIVE_APPOINTMENT"]! as! AppointmentData, showEditor: $showEditor)
                }
            }

        }
    }
}

struct CancelStyleThin: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 160, height: 40, alignment: .center)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(5.0).shadow(radius: 3)
            .scaleEffect(configuration.isPressed ? 1.08 : 1.0)
            
    }
}

struct FullAcrossThin: View {
    
    var body: some View {
        HStack {
            Text("Child Name")
                .bold()
                .font(.system(size: 18, weight: .bold, design: .rounded))
            Spacer()
            Text("Appointment Date")
                .bold()
                .font(.system(size: 18, weight: .bold, design: .rounded))
        }
        .padding()
        .frame(width: 380, height: 50, alignment: .center)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(5.0).shadow(radius: 3)
        //.scaleEffect(configuration.isPressed ? 1.08 : 1.0)
            
    }
}

struct AppointmentSheetButton<Content>: View where Content: View {
    @EnvironmentObject var store: ClericStore
    var imageName: String
    var content: Content
    @State var isPresented = false
    
    init(imageName: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.imageName = imageName
    }
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }, label: {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
        })
        .sheet(isPresented: $isPresented) {
            self.content.environmentObject(store)
        }
    }
}


struct AppointmentsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsScreen().environmentObject(ClericStore.shared)
    }
}

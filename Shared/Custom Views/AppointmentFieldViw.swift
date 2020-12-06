//
//  AppointmentFieldViw.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/10/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

struct AppointmentFieldViw: View {
    @EnvironmentObject var store: ClericStore
    @State var showDetails: Bool = false
    @State var editDetails: Bool = false
    @Binding var showEditor: Bool
    
    static let appointmentDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
        }()
    @State var appointment: AppointmentData
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(appointment.title)
                        .bold()
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding()
                    Spacer()
                    Text("\(appointment.date, formatter: AppointmentFieldViw.appointmentDateFormat)")
                        .bold()
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding()
                }
                .frame(width: .infinity, height: .infinity, alignment: .center)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding(.leading)
                .padding(.trailing)
                .onTapGesture(count: 2, perform: {
                    self.showDetails.toggle()
                })
                
            }.padding(.bottom, 3)
            if showDetails {
                VStack {
                    HStack {
                        Spacer()
                        ScrollView {
                            Text(appointment.notes ?? "No additional notes")
                                .bold()
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .padding(.bottom)
                        }.frame(width: .infinity, height: 125, alignment: .center)
                        Spacer()
                    }
                    .gesture(DragGesture().onEnded(){_ in self.showDetails = false})
                    HStack {
                        Spacer()
                        Button(action: {
                            store.familyDetails["ACTIVE_APPOINTMENT"] = appointment
                            self.showEditor.toggle()
                        }, label: {
                            Image("EditPencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24, alignment: .center)
                                .padding(.trailing)
                                .padding(.bottom)
                        }).buttonStyle(ScaleStyle())
                    }
                }
                .background(Color(UIColor.systemGray5))
                .cornerRadius(5)
                .shadow(radius: 3)
                .padding(.leading)
                .padding(.leading)
                .padding(.trailing)
                .padding(.trailing)
            }
            
        }
        
    }
}
#if DEBUG
struct AppointmentFieldViw_Previews: PreviewProvider {
    static var myAppointment = AppointmentData(title: "Code Well Check Today", date: Date(), notes: "Let's write notes. This note is going to be so extremly long that we should have to have several lines of text. ", child: ClericStore.shared.activePatient!)
    static var previews: some View {
        AppointmentFieldViw(showEditor: .constant(false), appointment: myAppointment).environmentObject(ClericStore.shared)
    }
}
#endif

//
//  ProfileScreen.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/17/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

struct ProfileScreen: View {
    @EnvironmentObject var store: ClericStore
    @State var showAvatarChooser: Bool = false
    @State var sheetsOn: Bool = false
    var guardian: OCKContact = ClericStore.shared.activeGuardian!
    var appointmentData: String {
        return self.store.fetchNextAppointmentString()
    }

    var body: some View {
        VStack {
            Spacer()
            AvatarCellView(imageName: makeAvatarView(guardian: guardian))
                .scaleEffect(3)
                .onLongPressGesture {
                    self.sheetsOn = true
                    self.showAvatarChooser.toggle()
                }
            Spacer()
            Text(store.guardianDetails![guardian]!["Name"] ?? "default_profile").bold()
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            ScrollView {
                InformationFieldWithDetail(label: "Children", info: store.fetchAllChildrenString(), detailView: ChildListScreen())
                InformationFieldWithDetail(label: "Next Appointment", info: appointmentData, detailView: AppointmentsScreen())
                InformationFieldWithDetail(label: "Provider Details", info: store.fetchBasicInsuranceInfo(), detailView: ProviderScreen())
                
                
            }.frame(width: .infinity, height: 300, alignment: .center)
            Spacer()
        }
        .if(sheetsOn) { $0.sheet(isPresented: $showAvatarChooser, onDismiss: {self.sheetsOn = false} , content: {GuardianAvatarSelectionScreen(guardian: guardian, showAvatarChooser: $showAvatarChooser)})
        }
        .background(Color(UIColor.systemTeal))
    }
    func makeAvatarView(guardian: OCKContact) -> String {
        let avatar = store.guardianImages![guardian]!
        return avatar
    }
}

struct GuardianDetailView: View {
    var item: String
    var guardian: OCKContact
    
    var body: some View {
        //TODO - Update for longer text strings
        if ClericStore.shared.guardianDetails![guardian]![item] != nil {
            HStack {
                Text("\(item): ").bold()
                    .font(.system(size: 18, weight: .bold, design: .rounded)).padding()
                Spacer()
                Text(ClericStore.shared.guardianDetails![guardian]![item]!).bold()
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



struct ProfileScreen_Previews: PreviewProvider {
    static var guardian1 = ClericStore.shared.guardianMembers[0]
    static var previews: some View {
        ProfileScreen(guardian: guardian1!).environmentObject(ClericStore.shared)
    }
}

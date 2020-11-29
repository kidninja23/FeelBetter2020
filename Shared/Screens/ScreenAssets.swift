//
//  ScreenAssets.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 10/29/20.
//

import Foundation
import SwiftUI
import CareKit
import CareKitStore

struct ScreenAssets: View {
    var guardian = ClericStore.shared.activeGuardian!
    
    var body: some View {
        VStack {
            Spacer()
            Text("Buttons")
            HStack {
                Spacer()
                Button(action: {}, label: {
                    Text("              ")
                }).buttonStyle(CancelStyle())
                Spacer()
                Button(action: {}, label: {
                    Text("                                 ")
                }).buttonStyle(CancelStyle())
                Spacer()
            }.padding(.bottom)
            
            HStack {
                Spacer()
                Button(action: {}, label: {
                    Text("")
                }).buttonStyle(CarePlanStyle())
                Spacer()
            }
            Spacer()
            Text("Details")
            GuardianDetailView(item: "Appointments", guardian: guardian)
            Spacer()
        }
    }
}

struct ScreenAssets_Previews: PreviewProvider {
    static var previews: some View {
        ScreenAssets()
    }
}

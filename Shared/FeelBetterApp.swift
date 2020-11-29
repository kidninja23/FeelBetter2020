//
//  FeelBetterApp.swift
//  Shared
//
//  Created by Jason on 9/28/20.
//

import SwiftUI

@main
struct FeelBetterApp: App {
    @EnvironmentObject var store: ClericStore
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ClericStore.shared)
        }
    }
}

struct FeelBetterApp_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ClericStore.shared)
    }
}


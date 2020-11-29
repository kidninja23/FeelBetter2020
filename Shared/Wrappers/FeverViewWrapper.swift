//
//  FeverViewWrapper.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/19/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

struct FeverViewWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var store: ClericStore
    typealias UIViewControllerType = FeverDailyViewController

    func makeUIViewController(context: Context) -> FeverDailyViewController {
        let storeManager = store.storeManager
        let controller = FeverDailyViewController(storeManager: storeManager)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: FeverDailyViewController, context: Context) {
        
    }
    
}

struct FeverViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        FeverViewWrapper()
    }
}

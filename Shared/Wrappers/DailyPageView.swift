//
//  DailyPageView.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/19/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

struct DailyPageView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> OCKDailyPageViewController {
        let controller = OCKDailyPageViewController(storeManager: ClericStore.shared.storeManager)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: OCKDailyPageViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = OCKDailyPageViewController
    
    

}

struct DailyPageView_Previews: PreviewProvider {
    static var previews: some View {
        DailyPageView()
    }
}

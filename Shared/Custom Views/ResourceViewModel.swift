//
//  ResourceViewModel.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/16/20.
//

import Foundation
import SwiftUI
import Combine

class ResourceViewModel: ObservableObject {
    @Published var searchText: String = ""
    
    let allData: SymptomList
    var filteredData: [SymptomResources] = [SymptomResources]()
    var publisher: AnyCancellable?
    
    init() {
        self.allData = ClericStore.shared.resources
        self.filteredData = allData.symptomList
        self.publisher = $searchText
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (str) in
                if !self.searchText.isEmpty {
                    self.filteredData = self.allData.symptomList.filter { $0.title.contains(str) }
                } else {
                    self.filteredData = self.allData.symptomList
                }
            })
    }
    
    func fetchSymptomByCategory(category: BodyZone) -> [SymptomResources] {
        let availableList = self.filteredData.filter { $0.bodyZone == category }
        return availableList
    }
}

/*
 //
 //  ResourceViewModel.swift
 //  FeelBetter (iOS)
 //
 //  Created by Jason Bice on 11/16/20.
 //

 import Foundation
 import SwiftUI
 import Combine

 class ResourceViewModel: ObservableObject {
     @Published var searchText: String = ""
     var filter: BodyZone
     
     let allData: [SymptomResources]
     var filteredData: [SymptomResources] = [SymptomResources]()
     var publisher: AnyCancellable?
     
     init(filter: BodyZone) {
         self.filter = filter
         if filter == .all {
             self.allData = ClericStore.shared.resources.symptomList
         } else {
             self.allData = ClericStore.shared.resources.fetchSymptomByCategory(category: filter)
         }
         self.filteredData = allData
         self.publisher = $searchText
             .receive(on: RunLoop.main)
             .sink(receiveValue: { (str) in
                 if !self.searchText.isEmpty {
                     self.filteredData = self.allData.filter { $0.title.contains(str) }
                 } else {
                     self.filteredData = self.allData
                 }
             })
     }
 }


 
 */

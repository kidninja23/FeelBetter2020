//
//  ProviderScreen.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/18/20.
//

import SwiftUI
import CareKitStore

struct ProviderScreen: View {
    @EnvironmentObject var store: ClericStore
    @State var zipcode: String = ""
    @State var provider: String = "Villiage Pediatrics\n7165 Colfax Avenue\nCumming, Georgia 30040\n(678) 990-3362"
    @State var availableProviders: [OCKContact] = [OCKContact]()
    @State var populateList: Bool = false
    @State var showNewProvider: Bool = false
    @State var makePrimary: Bool = false
    @State var primaryExists: Bool = false
    @State var makeSecondary: Bool = false
    @State var finalSelection: OCKContact? = nil
    
    //Computed property to separate providers into a 2 column grid
    @State var orderedProviders: [[OCKContact]] = [[OCKContact]]()
    
    var body: some View {
        VStack {
            VStack {
                Text("Insurance Details").bold()
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding(.top)
                //Spacer()
                InsuranceCard()
                Spacer()
            }
            Text("Medical Providers")
                .bold()
                .font(.system(size: 32, weight: .bold, design: .rounded))

            VStack (alignment: .leading){
                ForEach(orderedProviders, id:\.self) { pair in
                    HStack {
                        ForEach(pair, id: \.self) { contact in
                            MedicalProvider(provider: contact)
                        }
                    }
                }
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            Spacer()
            Button(action: {
                self.availableProviders = self.store.fetchAllMedicalProviders()
                self.showNewProvider.toggle()
                
            }, label: {
                HStack {
                    Spacer()
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 44, height: 44, alignment: .center)
                        .padding(5)
                }
            }).buttonStyle(PlainButtonStyle()).hidden()
        }.background(Color(UIColor.systemGray6))
        .onAppear(perform: {
            self.orderedProviders = OrderProviders()
        })
        .sheet(isPresented: $showNewProvider, onDismiss: {self.orderedProviders = OrderProviders()} ,content: {
            
        })
    }
    
    func OrderProviders() -> [[OCKContact]] {
        let allProviders = self.store.fetchAllMedicalProviders()
        let length = allProviders.count
        var pairs = [[OCKContact]]()
        var i = 0
        var j = 1
        if length > 1 {
            while j < length {
                let temp = Array(allProviders[i...j])
                pairs.append(temp)
                i += 2
                j += 2
                if j == length {
                    let last = Array(arrayLiteral: allProviders[i])
                    pairs.append(last)
                }
            }
            return pairs
        }
        if length == 1 {
            pairs.append(allProviders)
            return pairs
        }
        return pairs
    }
}

struct MedicalProvider: View {
    var provider: OCKContact
    
    var body: some View {
        let providerDetails = ClericStore.shared.fetchMedicalProviderDetails(provider: provider)
        Group {
            if providerDetails != nil {
                Button(action: {
                    let number = providerDetails![3].filter("0123456789".contains)
                    let urlString = "tel://\(number)"
                    let url: NSURL = URL(string: urlString)! as NSURL
                    
                    UIApplication.shared.open(url as URL)
                    
                }, label: {
                    VStack (alignment: .leading){
                        Text(providerDetails![1]).font(.title2)
                        Spacer()
                        Text(providerDetails![0])
                        Text(providerDetails![2])
                        HStack {
                            Text(providerDetails![3])
                            Image(systemName: "phone.arrow.up.right")
                        }
                        Spacer()
                    }
                }).buttonStyle(PlainButtonStyle())
            } else {
                Text("No Provider details available")
            }
        }.frame(width: 155, height: 155, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ProviderScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProviderScreen().environmentObject(ClericStore.shared)
    }
}

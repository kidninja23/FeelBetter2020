//
//  InsuranceCard.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/22/20.
//

import SwiftUI
//TODO - Update all non required fields with conditionals
struct InsuranceCard: View {
    @EnvironmentObject var store: ClericStore
    @State var showEdit: Bool = false
    
    var body: some View {
        let provider = store.fetchMedicalInsurance()
        
        Button(action: {self.showEdit = true}, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.white)
                    .frame(width: 400, height: 225, alignment: .center)
                    .shadow(radius: 3)
                VStack (alignment: .leading, spacing: 1) {
                    Group {
                        HStack {
                            Image("FeelBetterLogo - 60")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .padding(.leading)
                            Spacer()
                            Text("\(provider.PlanTitle ?? "")")
                                .padding(.trailing, 8)
                        }
                        HStack {
                            Text("\(provider.ProviderName)")
                                .padding(.leading, 8)
                            Spacer()
                            
                        }
                        HStack {
                            Text("Group Number: \(provider.GroupNumber ?? "")")
                                .padding(.leading, 8)
                                .font(.footnote)
                            Spacer()
                            Text("Member ID: \(provider.MemberID ?? "")")
                                .padding(.trailing, 8)
                                .font(.footnote)
                        }
                    }
                    Divider()
                    InsuranceCardBottom(provider: provider)
                }.padding(.leading,5)
                .padding(.trailing, 5)
            }
        })
        .buttonStyle(ScaleStyle())
        .sheet(isPresented: $showEdit, content: {
            InsuranceDetails(insurance: provider)
        })
    }
}

struct InsuranceCardBottom: View {
    @EnvironmentObject var store: ClericStore
    var provider: InsuranceProvider
    
    var body: some View {
        
            let dependents = provider.Dependents ?? [String]()
            HStack {
                VStack (alignment: .leading) {
                    Text("Member Name")
                        .font(.footnote)
                        .bold()
                        .padding(.leading, 8)
                        .padding(.top, 2)
                    HStack {
                        Text("\(provider.AccountHolder)")
                            .font(.body)
                            .padding(.leading, 8)
                    }
                    VStack {
                        Text("DEPENDENTS")
                            .font(.footnote)
                            .bold()
                            .padding(.leading, 8)
                            .padding(.top, 3)
                        VStack (alignment: .leading) {
                            ForEach(dependents, id: \.self) { dependent in
                                Text("\(dependent)")
                            }
                        }.padding(.leading, 8)
                    }
                }
                Spacer()
                VStack (alignment: .leading, spacing: 3) {
                    if provider.RXnumber != "" {
                        HStack {
                            Text("RX Number: ")
                                .font(.footnote)
                            Spacer()
                            Text("\(provider.RXnumber)")
                                .font(.footnote)
                        }.frame(width: 225, height: 10)
                    }
                    if provider.ProviderContact != "" {
                        HStack {
                            Text("Provider Contact: ")
                                .font(.footnote)
                            Spacer()
                            Text("\(provider.ProviderContact)")
                                .font(.footnote)
                        }.frame(width: 225, height: 10)
                    }
                    if provider.MemberContact != "" {
                        HStack {
                            Text("Member Contact: ")
                                .font(.footnote)
                            Spacer()
                            Text("\(provider.MemberContact)")
                                .font(.footnote)
                        }.frame(width: 225, height: 10)
                    }
                    if provider.ClaimsAddress != "" {
                        HStack (alignment: .top){
                            Text("Claims Address: ")
                                .font(.footnote)
                            Spacer()
                            Text("\(provider.ClaimsAddress)")
                                .font(.footnote)
                        }.frame(width: 225, height: 52)
                        .padding(.top, 5)
                    }
                    HStack {
                        Spacer()
                        Image(systemName: "pencil")
                            
                    }.frame(width: 225, height: 10)
                }.padding(.trailing, 12)
                .padding(.top, 5)
            }.frame(width: 400, height: .infinity, alignment: .center)
        
    }
    
}

struct InsuranceCard_Previews: PreviewProvider {
    static var previews: some View {
        InsuranceCard().environmentObject(ClericStore.shared)
    }
}

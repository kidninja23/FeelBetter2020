//
//  ResourceList.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/16/20.
//

import SwiftUI

struct ResourceList: View {
    @ObservedObject var viewModel = ResourceViewModel()
    @State var filter: BodyZone = .all
    @State var expandFilter: Bool = false
    
    
    var body: some View {
        var titles: [String] {
            var theTitles = [String]()
            var resourceList = [SymptomResources]()
            if filter == .all {
                resourceList = viewModel.filteredData
            } else {
                resourceList = viewModel.fetchSymptomByCategory(category: filter)
            }
            for resource in resourceList {
                theTitles.append(resource.title)
            }
            return theTitles.sorted()
        }
        return NavigationView {
            ZStack (alignment: .topTrailing){
                VStack {
                    HStack(spacing: 8) {
                        TextField("Search...", text: $viewModel.searchText)
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                            .offset(x: -25)
                    }
                    .padding(.top, 10)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                                
                    List {
                        ForEach(
                            titles,
                            id: \.self) { title in
                            let resource = viewModel.filteredData.first(where: { $0.title == title})!
                            NavigationLink(
                                destination: ResourcePage(details: resource),
                                label: {
                                    Text(title)
                                })
                                
                        }
                    }
                }
                .navigationBarTitle("Resources",displayMode: .large)
                FilterMenu(expand: $expandFilter, filter: $filter)
                    .offset(y: 11)
            }
        }
    }
}

struct FilterMenu: View {
    @Binding var expand: Bool
    @Binding var filter: BodyZone
    
    var body: some View {
            Button(action: {self.expand.toggle()}, label: {
                if !expand {
                    if filter == .all {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .offset(x: -19)
                    } else {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            .offset(x: -19)
                    }
                } else {
                    VStack {
                        if filter == .all {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .padding(.bottom, 10)
                                .offset(x: 30)
                        } else {
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .padding(.bottom, 10)
                                .offset(x: 30)
                        }
                        VStack (alignment: .trailing) {
                            Button(action: {
                                self.filter = .all
                                self.expand.toggle()
                            }, label: {
                                Text("All")
                            })
                            Button(action: {
                                self.filter = .head
                                self.expand.toggle()
                            }, label: {
                                Text("Head")
                            })
                            Button(action: {
                                self.filter = .torso
                                self.expand.toggle()
                            }, label: {
                                Text("Torso")
                            })
                            Button(action: {
                                self.filter = .arm
                                self.expand.toggle()
                            }, label: {
                                Text("Arms")
                            })
                            Button(action: {
                                self.filter = .leg
                                self.expand.toggle()
                            }, label: {
                                Text("Legs")
                            })
                            Button(action: {
                                self.filter = .whole
                                self.expand.toggle()
                            }, label: {
                                Text("Whole Body")
                            })
                            Button(action: {
                                self.filter = .illness
                                self.expand.toggle()
                            }, label: {
                                Text("Illness")
                            })
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 100, height: .infinity, alignment: .center)
                        .padding(.trailing,5)
                        .background(Color(UIColor.systemGray6).opacity(0.5))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }.offset(x: -5)
                    
                }
            }).buttonStyle(PlainButtonStyle())
        
        
    }
}

struct ResourceList_Previews: PreviewProvider {
    static var myViewModel = ResourceViewModel()
    static var previews: some View {
        ResourceList(viewModel: myViewModel)
    }
}

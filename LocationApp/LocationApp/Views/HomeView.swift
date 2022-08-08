//
//  HomeView.swift
//  LocationApp
//
//  Created by MacBook on 2022-08-08.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel = LocationViewModel()
    @State private var showingPopover = false
    @State private var showingAlert = false
    @State private var searchText = ""
    @State private var imageURL = ""
    
    
    var body: some View {
        
        ZStack(alignment: .top) {
            LoadingView(isShowing:.constant(viewModel.postDetail == nil)) {
                VStack {
                    NavigationView {
                        Text("Searching \(searchText)")
                            .searchable(text: $searchText)
                            .navigationTitle("Employer Locations")
                    }.frame(height: 180.0)
                    
                    if viewModel.userLists != nil && viewModel.postDetail != nil {
                        MapView(postDetail: viewModel.postDetail ?? [], userLists: viewModel.userLists ?? [])
                    }
                    Spacer()
                }
            }
        }.popover(isPresented: $showingPopover) {
            DetailsView()
        }.onReceive(NotificationCenter.default.publisher(for: NSNotification.QrClick))
        { obj in
            
            if let userInfo = obj.userInfo, let info = userInfo["info"] {
                
                if info as! String != "" {
                    self.imageURL = info as! String
                    showingPopover = true
                    
                } else {
                    self.showingAlert = true
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Waring"), message: Text("Distance between two users should not be less than 10 meters"), dismissButton: .default(Text("Got it!")))
        }
        .onAppear{
            viewModel.getUsers()
        }
    }
}



extension NSNotification {
    static let QrClick = Notification.Name.init("QrClick")
}
extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}

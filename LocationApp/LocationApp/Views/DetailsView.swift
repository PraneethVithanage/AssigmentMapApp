//
//  DetailsView.swift
//  LocationApp
//
//  Created by MacBook on 2022-08-08.
//

import SwiftUI

struct DetailsView: View {
    private let items = Range(0...15).map { "Item " + String($0) }
    var body: some View {
        VStack {
            List {
                Image(systemName: "mihcm-logo").data(url: URL(string:"https://3c5.com/liKe9")!)
                    .resizable()
                    .scaledToFit()
                Text(" Comments")
                    .font(.system(size: 15))
                ForEach(items, id: \.self) { item in
                    VStack(alignment: .leading, spacing: 0) {
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 300.0, height: 50.0)
                            .overlay(Text(" need which person make my rabbit website.All team take 1% is your. That a best deal.1.30% i give all team").padding(10))
                            .font(.system(size: 10))
                            .transition(AnyTransition.scale)
                            .listRowSeparator(.hidden)
                        Text("    Like    Reply    1h")
                            .font(.system(size: 9))
                    }.listRowSeparator(.hidden)
                }
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}

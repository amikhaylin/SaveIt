//
//  PictureView.swift
//  SaveIt
//
//  Created by Andrey Mikhaylin on 18.05.2021.
//

import SwiftUI

struct PictureView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var image = UIImage()
    @State private var description = ""
    @ObservedObject var records: Records
    var index: Int
    var locationFetcher: LocationFetcher
    
    var body: some View {
        ZStack {
            Image(uiImage: records.items[index].image!)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text(records.items[index].description)
//                        .padding()
                    .foregroundColor(.white)
                    .font(.title)
                    .padding([.bottom, .trailing])
            }
            .navigationBarItems(trailing: NavigationLink(destination: MapView(latitude: records.items[index].latitude, longitude: records.items[index].longitude, title: records.items[index].description, showingPlaceDetails: true)
                                                            .edgesIgnoringSafeArea(.all)) {
                Image(systemName: "map")
                    .foregroundColor(.white)
            })
        }
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView(records: Records(), index: 0, locationFetcher: LocationFetcher())
    }
}

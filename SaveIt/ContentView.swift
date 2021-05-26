//
//  ContentView.swift
//  SaveIt
//
//  Created by Andrey Mikhaylin on 11.05.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var records = Records()
    @State private var showingEditScreen = false
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentRecordIndex = 0
    @State private var imageSource = UIImagePickerController.SourceType.photoLibrary
    @State private var locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach (records.items.sorted()) { record in
                        NavigationLink(
                            destination: PictureView(records: records, index: records.items.lastIndex(of: record)!, locationFetcher: self.locationFetcher)) {
                            HStack {
                                Image(uiImage: record.image!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                
                                Text(record.description)
                            }
                        }
                    }
                    .onDelete(perform: removeRecord)
                }
                .navigationBarTitle("SaveIt")
             
                VStack {

                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            self.showingImagePicker = true
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding([.bottom, .trailing])
                        }
                        .contextMenu {
                            Button(action: {
                                self.imageSource = UIImagePickerController.SourceType.camera
                                self.showingImagePicker = true
                            }, label: {
                                Text("Camera")
                                Image(systemName: "camera")
                            })
                            
                            Button(action: {
                                self.imageSource = UIImagePickerController.SourceType.photoLibrary
                                self.showingImagePicker = true
                            }, label: {
                                Text("Photo library")
                                Image(systemName: "photo.on.rectangle")
                            })
                        }
                    }

                }
            }
        }
        .onAppear(perform: startUp)
        .sheet(isPresented: $showingEditScreen) {
            EditView(records: self.records, index: self.currentRecordIndex)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: createRecord) {
            ImagePicker(image: self.$inputImage, imageSource: self.imageSource)
        }
    }
    
    func createRecord() {
        if let image = self.inputImage {
            var newRecord = Record(id: UUID(), date: Date(), description: "", imageName: nil, image: image)
            
            if let location = locationFetcher.lastKnownLocation {
                newRecord.latitude = location.latitude
                newRecord.longitude = location.longitude
            }

            records.items.append(newRecord)
            currentRecordIndex = records.items.lastIndex(of: newRecord)!
            
            self.showingEditScreen = true
        }
    }
    
    func removeRecord(at offset: IndexSet) {
        records.remove(at: offset)
    }
    
    func startUp() {
        self.locationFetcher.start()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

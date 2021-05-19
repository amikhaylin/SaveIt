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
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach (records.items.sorted()) { record in
                        NavigationLink(
                            destination: PictureView(records: records, index: records.items.lastIndex(of: record)!)) {
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
        .onAppear(perform: loadData)
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            EditView(records: self.records, index: self.currentRecordIndex)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: createRecord) {
            ImagePicker(image: self.$inputImage, imageSource: self.imageSource)
        }
    }
    
    func createRecord() {
        if let image = self.inputImage {
            let newRecord = Record(id: UUID(), date: Date(), description: "", imageName: nil, image: image)
            records.items.append(newRecord)
            currentRecordIndex = records.items.lastIndex(of: newRecord)!
            
            self.showingEditScreen = true
        }
    }
    
    func removeRecord(at offset: IndexSet) {
        records.items.remove(atOffsets: offset)
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let filename = getDocumentDirectory().appendingPathComponent("SavedData")

        do {
            let data = try Data(contentsOf: filename)
            records.items = try JSONDecoder().decode([Record].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
        
        for index in 0..<records.items.count {
            do {
                let imageData = try Data(contentsOf: getDocumentDirectory().appendingPathComponent(records.items[index].imageName!))
                records.items[index].image = UIImage(data: imageData)
            } catch {
                print("Error loading image for \(index)")
            }
        }
    }

    func saveData() {
        //Saving photos
        for index in 0..<records.items.count {
            if records.items[index].imageName == nil {
                let imageName = UUID().uuidString
                
                if let image =  records.items[index].image {
                    if let jpegData = image.jpegData(compressionQuality: 0.8) {
                        try? jpegData.write(to: getDocumentDirectory().appendingPathComponent(imageName), options: [.atomicWrite, .completeFileProtection])
                        records.items[index].imageName = imageName
                    }
                }
            }
        }
        
        do {
            let filename = getDocumentDirectory().appendingPathComponent("SavedData")
            let data = try JSONEncoder().encode(self.records.items)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])

        } catch {
            print("Unable to save data.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

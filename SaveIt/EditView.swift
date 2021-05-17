//
//  EditView.swift
//  SaveIt
//
//  Created by Andrey Mikhaylin on 12.05.2021.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var image = UIImage()
    @State private var description = ""
    @ObservedObject var records: Records

    var body: some View {
        NavigationView {
            Form {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300, alignment: .center)
                TextField("Description", text: $description)
                    .multilineTextAlignment(.leading)
                    
            }
            .navigationBarTitle("Edit record", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {

                records.items[records.items.count - 1].description = self.description
                        
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear(perform: unpackLastRecord)
    }
    
    func unpackLastRecord() {
        if let record = records.items.last {
            if let image = record.image {
                self.image = image
            }
            description = record.description
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(records: Records())
    }
}

//
//  Record.swift
//  SaveIt
//
//  Created by Andrey Mikhaylin on 12.05.2021.
//

import UIKit

struct Record: Comparable, Identifiable {
    var id: UUID = UUID()
    var date: Date = Date()
    var description: String
    var imageName: String?
    var image: UIImage?
    
    static func < (lhs: Record, rhs: Record) -> Bool {
        lhs.date < rhs.date
    }
    
    static func == (lhs: Record, rhs: Record) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID, date: Date, description: String, imageName: String?, image: UIImage?) {
        self.id = id
        self.date = date
        self.description = description
        self.imageName = imageName
        self.image = image
    }
}

class Records: ObservableObject {
    @Published var items = [Record]()
}

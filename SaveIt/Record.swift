//
//  Record.swift
//  SaveIt
//
//  Created by Andrey Mikhaylin on 12.05.2021.
//

import UIKit

struct Record: Comparable, Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date = Date()
    var description: String
    var imageName: String?
    var image: UIImage?
    
    enum CodingKeys: CodingKey {
        case id, date, description, imageName
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        description = try container.decode(String.self, forKey: .description)
        imageName = try container.decode(String?.self, forKey: .imageName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(description, forKey: .description)
        try container.encode(imageName, forKey: .imageName)
    }
    
    static func < (lhs: Record, rhs: Record) -> Bool {
        lhs.description < rhs.description
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

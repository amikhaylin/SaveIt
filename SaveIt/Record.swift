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
    var latitude: Double?
    var longitude: Double?
    
    enum CodingKeys: CodingKey {
        case id, date, description, imageName, latitude, longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        description = try container.decode(String.self, forKey: .description)
        imageName = try container.decode(String?.self, forKey: .imageName)
        latitude = try container.decode(Double?.self, forKey: .latitude)
        longitude = try container.decode(Double?.self, forKey: .longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(description, forKey: .description)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
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
    
    static let saveKey = "SavedData"
    
    init() {
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(Self.saveKey)

        do {
            let data = try Data(contentsOf: filename)
            items = try JSONDecoder().decode([Record].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
        
        for index in 0..<items.count {
            do {
                let imageData = try Data(contentsOf: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(items[index].imageName!))
                items[index].image = UIImage(data: imageData)
            } catch {
                print("Error loading image for \(index)")
            }
        }
    }
    
    func remove(at offset: IndexSet) {
        for index in offset {
            do {
                try FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(items[index].imageName!))
            } catch {
                print("Unable to delete image file")
            }
        }
        
        items.remove(atOffsets: offset)
        
        save()
    }

    func save() {
        for index in 0..<items.count {
            if items[index].imageName == nil {
                let imageName = UUID().uuidString
                
                if let image =  items[index].image {
                    if let jpegData = image.jpegData(compressionQuality: 0.8) {
                        try? jpegData.write(to: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(imageName), options: [.atomicWrite, .completeFileProtection])
                        items[index].imageName = imageName
                    }
                }
            }
        }
        
        do {
            let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("SavedData")
            let data = try JSONEncoder().encode(self.items)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])

        } catch {
            print("Unable to save data.")
        }
    }
}

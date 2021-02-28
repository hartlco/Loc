import Foundation

struct ExportModel: Codable {
    let items: [ExportModel.ExportItem]

    struct ExportItem: Codable {
        struct Place: Codable {
            let name: String?
            let isoCountryCode: String?
            let country: String?
            let administrativeArea: String?
        }

        let date: Date
        let longitude: Double
        let latitude: Double
        let place: Place?
    }
}

extension ExportModel {
    init(items: [Item]) {
        self.items = items.compactMap { item in
            ExportItem(item: item)
        }
    }
}

extension ExportModel.ExportItem {
    init?(item: Item) {
        guard let timestamp = item.timestamp else {
            return nil
        }

        self.date = timestamp
        self.latitude = item.latitude
        self.longitude = item.longitude
        self.place = item.place.flatMap { place in
            return ExportModel.ExportItem.Place(place: place)
        }
    }
}

extension ExportModel.ExportItem.Place {
    init(place: Place) {
        if let name = place.name,
           !name.isEmpty {
            self.name = name
        } else {
            self.name = nil
        }

        if let isoCountryCode = place.isoCountryCode,
           !isoCountryCode.isEmpty {
            self.isoCountryCode = isoCountryCode
        } else {
            self.isoCountryCode = nil
        }

        if let country = place.country,
           !country.isEmpty {
            self.country = country
        } else {
            self.country = nil
        }

        if let administrativeArea = place.administrativeArea,
           !administrativeArea.isEmpty {
            self.administrativeArea = administrativeArea
        } else {
            self.administrativeArea =  nil
        }
    }
}

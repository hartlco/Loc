import XCTest
import Model
@testable import Loc

class ExportModelTests: XCTestCase {
    func test_exportModel_fromItems() {
        let date = Date()

        let exportModel = ExportModel(items: [makeItem(date: date)])
        
        XCTAssert(exportModel.items.count == 1)
        XCTAssert(exportModel.items.first?.date == date)
        XCTAssert(exportModel.items.first?.place?.name == "Prenzlauer Berg")
        XCTAssert(exportModel.items.first?.place?.isoCountryCode == "DE")
        XCTAssert(exportModel.items.first?.place?.country == "Germany")
        XCTAssert(exportModel.items.first?.latitude == 0.2)
        XCTAssert(exportModel.items.first?.longitude == 0.1)
    }

    // MARK: - Private

    private func makeItem(date: Date) -> MockItem {
        let day = MockDay(simplifiedDate: date)

        let place = MockPlace(name: "Prenzlauer Berg",
                              isoCountryCode: "DE",
                              country: "Germany",
                              administrativeArea: "Berlin")

        return MockItem(timestamp: date,
                        longitude: 0.1,
                        latitude: 0.2,
                        day: day,
                        place: place)
    }
}

import UIKit
import Photos

final class PhotoService {
    private let imageManager = PHCachingImageManager()
    private let calendar = Calendar.current

    func requestAccess() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                print("not determined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                print("authed")
            case .limited:
                print("limited")
            @unknown default:
                fatalError()
            }
        }
    }

    func cacheImagesForLastMonth() {
//        let fetchOptions = PHFetchOptions()
//        let date = Date().addingTimeInterval(-30*24*60*60) as NSDate
//        fetchOptions.predicate = NSPredicate(format: "creationDate > %@", date)
//
//
//
//        imageManager.startCachingImages(for: <#T##[PHAsset]#>,
//                                           targetSize: <#T##CGSize#>,
//                                           contentMode: <#T##PHImageContentMode#>,
//                                           options: <#T##PHImageRequestOptions?#>)
    }

    func photos(for date: Date) {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let newDate = calendar.date(from: dateComponents)! as NSDate

        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "creationDate > %@", newDate)

        let result = PHAsset.fetchAssets(with: fetchOptions)

        if let firstImage = result.firstObject {
            imageManager.requestImage(for: firstImage,
                                         targetSize: .init(width: 320, height: 320),
                                         contentMode: .aspectFill,
                                         options: nil) { image, _ in
                print(image)
            }
        }
    }
}

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

    func photos(for date: Date) -> PHFetchResult<PHAsset> {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let newDate = calendar.date(from: dateComponents) ?? Date()

        let endDate = calendar.date(byAdding: .day, value: 1, to: newDate) ?? Date()

        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(
            format: "creationDate > %@ AND creationDate < %@",
            newDate as NSDate,
            endDate as NSDate
        )

        let result = PHAsset.fetchAssets(with: fetchOptions)

        return result
    }

    func photos(from date: Date, back days: Int) -> PHFetchResult<PHAsset> {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        var newDate = calendar.date(from: dateComponents) ?? Date()
        newDate = calendar.date(byAdding: .day, value: 1, to: newDate) ?? newDate

        let endDate = calendar.date(byAdding: .day, value: -days, to: newDate) ?? Date()

        print(newDate)
        print(endDate)
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(
            format: "creationDate > %@ AND creationDate < %@",
            endDate as NSDate,
            newDate as NSDate
        )

        let result = PHAsset.fetchAssets(with: fetchOptions)

        return result
    }
}

extension PHAsset {
    var image: UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self,
                                     targetSize: CGSize(width: 100, height: 100),
                                     contentMode: .aspectFit,
                                     options: nil,
                                     resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
}

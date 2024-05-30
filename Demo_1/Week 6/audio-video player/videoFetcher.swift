//
//  videoFetcher.swift
//  Demo_1
//
//  Created by iMac on 28/05/24.
//

import Foundation
import UIKit
import Photos

class VideoFetcher {

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                completion(true)
            case .denied, .restricted, .notDetermined:
                completion(false)
            case .limited:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }

    func fetchAllVideos(completion: @escaping ([URL]) -> Void) {
        var videoURLs: [URL] = []

        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)

        let videoAssets = PHAsset.fetchAssets(with: fetchOptions)

        let dispatchGroup = DispatchGroup()

        videoAssets.enumerateObjects { (asset, _, _) in
            dispatchGroup.enter()

            let options = PHVideoRequestOptions()
            options.version = .original

            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, _, _) in
                if let urlAsset = avAsset as? AVURLAsset {
                    videoURLs.append(urlAsset.url)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(videoURLs)
        }
    }
}

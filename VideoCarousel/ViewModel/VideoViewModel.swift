//
//  VideoViewModel.swift
//  VideoCarousel
//
//  Created by Koushal, KumarAjitesh on 2019/09/25.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

class VideoViewModel {
    
    private var videos: [Video]? {
        didSet {
            guard let obj = videos else { return }
            self.setupVideosDataSource(with: obj)
            self.didFinishFetch?()
        }
    }
    var error: String? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    private var manager: NetworkManager?
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var videosList: [Video] = [Video]()
    
    // MARK: - Constructor
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    // MARK: - Network call
    func fetchVideos() {
        self.manager?.getVideos(completion: { (videos, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.videos = videos
        })
    }
    
    // MARK: - UI Logic
    private func setupVideosDataSource(with videos: [Video]) {
        //Update ViewModel
        self.videosList = videos
    }
}

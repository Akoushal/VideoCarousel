//
//  VideoCarouselTests.swift
//  VideoCarousel
//
//  Created by Koushal, KumarAjitesh on 2019/09/25.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import XCTest
@testable import VideoCarousel

class VideoCarouselTests: XCTestCase {

    var nwManager: NetworkManager?
    let videoMockedJSON: [String: Any] = ["titleDefault": "Coach Stories: Durch die Blinds mit Michael Patrick Kelly", "imageUrl": "http://i5-img.7tv.de/is/a26dUrmvuMLNEJCC4sqF__y3mGLQI5dHEo3vrCerSOtBMlWINqEA4Pnjrn6KsuOwrKmlDM4JnSR1pcseDYCfDUHb5d--83v0svHpx1Fh",
      "tvShow": ["channelId": 111, "titleDefault": "The Voice of Germany"]]
    
    override func setUp() {
        nwManager = NetworkManager()
    }

    override func tearDown() {
        nwManager = nil
    }

    /*
     // Test: For checking CollectionView Existence
     */
    func test_ControllerHasCollectionView() {
        let controller = ViewController()
        controller.loadViewIfNeeded()
        
        XCTAssertNotNil(controller.collectionView,
                        "Controller should have a collectionView")
    }
    
    /*
     // Test: For checking CollectionView conforms to CollectionViewDatasource
     */
    func test_tableViewConformsToCollectionViewDataSourceProtocol() {
        let controller = ViewController()
        XCTAssertTrue(controller.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(controller.responds(to: #selector(controller.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(controller.responds(to: #selector(controller.collectionView(_:cellForItemAt:))))
    }
    
    /*
     // Test: For fetching Videos API
     */
    func test_fetchVideoList() {
        // Given Apiservice
        let manager = self.nwManager!

        // When fetch data
        let expect = XCTestExpectation(description: "callback")

        manager.getVideos { (videos, error) in
            expect.fulfill()
            XCTAssertTrue(videos?.count ?? 0 > 0, "Videos Exist")
        }
        wait(for: [expect], timeout: 10.0)
    }
    
    /*
    // Test: For URL Encoding
    */
    func testURLEncoding() {
        guard let url = URL(string: "https:www.google.com/") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
        var urlRequest = URLRequest(url: url)
        let parameters: Parameters = [
            "UserID": 1,
            "Name": "John",
            "Email": "john@apple.com",
            "IsCool": true
        ]
        
        do {
            let encoder = URLParameterEncoder()
            try encoder.encode(urlRequest: &urlRequest, with: parameters)
            guard let fullURL = urlRequest.url else {
                XCTAssertTrue(false, "urlRequest url is nil.")
                return
            }

            let expectedURL = "https:www.google.com/?Name=John&Email=john%2540apple.com&UserID=1&IsCool=true"
            XCTAssertEqual(fullURL.absoluteString.sorted(), expectedURL.sorted())
        }catch {
            
        }
    }

}

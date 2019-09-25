//
//  Video.swift
//  VideoCarousel
//
//  Created by Koushal, KumarAjitesh on 2019/09/25.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

struct Video: Codable {
    let imageURL : String?
    let titleDefault : String?
    let tvShow : TvShow?
}

struct TvShow: Codable {
    let channelId : Int?
    let titleDefault : String?
}

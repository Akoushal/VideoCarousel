//
//  EndPoint.swift
//  VideoCarousel
//
//  Created by Koushal, KumarAjitesh on 2019/09/25.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}


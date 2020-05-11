//
//  Article.swift
//  RxMVVM
//
//  Created by Lightport Developer on 2020. 01. 21..
//  Copyright © 2020. Lightport Developer. All rights reserved.
//

import Foundation

struct ArticleResponse : Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String?
}

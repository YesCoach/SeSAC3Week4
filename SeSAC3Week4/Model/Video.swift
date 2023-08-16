//
//  Video.swift
//  SeSAC3Week4
//
//  Created by 박태현 on 2023/08/16.
//

import Foundation

// MARK: - VideoResult

struct VideoResult: Codable {
    let documents: [Video]
    let meta: Meta
}

// MARK: - Meta

struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}

struct Video: Codable {
    let author: String
    let datetime: String
    let playtime: Int
    let thumbnail: String
    let title: String
    let url: String
}

extension Video {

    enum CodingKeys: String, CodingKey {
        case author, datetime, thumbnail, title, url
        case playtime = "play_time"
    }

    var contents: String {
        return "\(author) | \(playtime)회\n\(datetime)"
    }

}

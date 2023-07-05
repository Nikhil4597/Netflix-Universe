//
//  TrandingMoviesResponse.swift
//  Netflix-Universe
//
//  Created by ROHIT MISHRA on 06/07/23.
//

import Foundation

struct MotionPictureResponse: Codable {
    let results: [MotionPicture]
}

struct MotionPicture: Codable {
    let id: Int
    let media_type: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let release_date: String?
    let vote_average: Double
    let vote_count: Int
}

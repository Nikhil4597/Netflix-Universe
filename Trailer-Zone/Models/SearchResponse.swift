import Foundation

struct SearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: VideoElementID
}


struct VideoElementID: Codable {
    let kind: String
    let videoID: String
    
    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

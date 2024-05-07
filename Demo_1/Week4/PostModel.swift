//
//  PostModel.swift
//  Webservices
//
//  Created by iMac on 01/04/24.
//

import Foundation

struct PostModel: Codable {
    let status: Bool
    let responsecode, notiCount, currentPage, currentPageItemCount: Int
    let message: String
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case status, responsecode
        case notiCount = "noti_count"
        case currentPage = "current_page"
        case currentPageItemCount = "current_page_item_count"
        case message, data
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let postDataArray: [PostDataArray]

    enum CodingKeys: String, CodingKey {
        case postDataArray = "post_data_array"
    }
}

// MARK: - PostDataArray
struct PostDataArray: Codable {
    let postID: Int
    let postDesc: String
    let postUserName: String
    let postUserProfilePic: String
    let imageData: [ImageDatum]

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case postDesc = "post_desc"
        case postUserName = "post_user_name"
        case postUserProfilePic = "post_user_profile_pic"
        case imageData = "image_data"
    }
}

// MARK: - ImageDatum
struct ImageDatum: Codable {
    let postImageID: Int
    let uploadType: String
    let postImage: String
    let videoThumb: String

    enum CodingKeys: String, CodingKey {
        case postImageID = "post_image_id"
        case uploadType = "upload_type"
        case postImage = "post_image"
        case videoThumb = "video_thumb"
    }
}


//
//  ChatHistoryModel.swift
//  TA
//
//  Created by global on 03/04/22.
//

import UIKit

// MARK: - Chat History Response Model
struct ChatHistoryResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: ChatHistoryListing?
}

struct ChatHistoryListing: Codable {
    var listing: [ChatListing]?
}

struct ChatListing: Codable {
    var attachmentUrl: String?
    var chatDialogid: String?
    var firebaseMessageTime: String?
    var id: Int?
    var isDeleted: Int?
    var message: String?
    var messageId: String?
    var messageStatus: String?
    var messageTime: String?
    var messageType: Int?
    var receiverId: String?
    var senderId: String?
}

// MARK: - Chat History
class ChatHistoryModel: NSObject {
  
    class func fetchChatHistory() {
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        let parameters = ["skip": "0"]
        ApiManager<ChatHistoryResponseModel>.makeApiCall(APIUrl.UserApis.chatHistoryAPI, params:parameters , headers: headers, method: .get) { (response, resultModel) in
            
            if let chats = (((response as NSDictionary?)?.value(forKey: "data") as? NSDictionary)?.value(forKey: "listing")) as? NSArray {
                for index in 0 ..< chats.count {
                    if let chat = chats[index] as? NSDictionary {
                        fireBaseChatMessages().didReceiveSnapshot(dict: chat, isChatHistory: true)
                    }
                }
            }
       }
    }
}

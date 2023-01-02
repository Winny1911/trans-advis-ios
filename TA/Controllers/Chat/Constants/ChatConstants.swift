//
//  ChatConstants.swift
//  TA
//
//  Created by global on 19/03/22.
//

import Foundation
import FirebaseDatabase

let firbaseUrl  =   "https://trans-advis-334610-default-rtdb.firebaseio.com/"
let FirebaseStorageURL  =   "gs://trans-advis-334610.appspot.com"
let FirRef = Database.database().reference(fromURL: firbaseUrl) // Firbase url path for reference //



// MARK: - Firebase Message Type
struct FirebaseMessageType {
    static let Text = 1
    static let Image = 2
    static let Document = 3
}


// MARK: - Firebase User Table Keys
struct FirebaseUsersTable {
    static let tableName = "Users"
    static let user_id   = "user_id"
    static let chat_dialog_ids = "chat_dialog_ids"
    static let user_name    = "user_name"
    static let user_pic   = "user_pic"
    static let user_type  = "user_type"
}


// MARK: - Firebase Chats Table Keys
struct FirebaseChatsTable {
    static let tableName = "Chats"
    static let chat_dialog_id   = "chat_dialog_id"
    static let last_message = "last_message"
    static let last_message_time    = "last_message_time"
    static let last_message_sender_id   = "last_message_sender_id"
    static let participant_ids  = "participant_ids"
    static let unread_count = "unread_count"
    static let profile_pic  = "profile_pic"
    static let name = "name"
    static let last_message_id  = "last_message_id"
    static let last_message_type    = "last_message_type"
    static let dialog_type  = "dialog_type"
}

// MARK: - Firebase Messages Table Keys
struct FirebaseMessagesTable {
    static let tableName = "Messages"
    static let message_id   = "message_id"
    static let message = "message"
    static let message_type    = "message_type"
    static let message_time   = "message_time"
    static let firebase_message_time  = "firebase_message_time"
    static let chat_dialog_id = "chat_dialog_id"
    static let sender_id  = "sender_id"
    static let attachment_url = "attachment_url"
    static let message_read_status  = "message_read_status"
    static let receiver_id    = "receiver_id"
}

// MARK: - Chat History Table Keys
struct ChatMessagesHistoryTable {
    static let message_id   = "messageId"
    static let message = "message"
    static let message_type    = "messageType"
    static let message_time   = "messageTime"
    static let firebase_message_time  = "firebaseMessageTime"
    static let chat_dialog_id = "chatDialogid"
    static let sender_id  = "senderId"
    static let attachment_url = "attachmentUrl"
    static let message_read_status  = "messageStatus"
    static let receiver_id    = "receiverId"
}


// MARK: - Firebase Messages Table Keys
struct FirebaseNotificationTable {
    static let tableName = "Notifications"
}


// MARK: - Firebase Chat Keys
struct FirebaseStorgeTable {
    static let table_name = "CHAT_MEDIA"
}

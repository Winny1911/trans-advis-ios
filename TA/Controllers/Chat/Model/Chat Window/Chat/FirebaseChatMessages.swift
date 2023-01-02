//
//  FirebaseChat.swift
//  Oryxre
//
//  Created by Ankit Goyal on 2019/12/3.
//  Copyright © 2019 Applify. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseStorage
import FirebaseDatabase

protocol FirebaseChatDelegate {
    func didReceiveNewMessage(chat_message: ChatMessages)
    func didUpdateProgress(message_id:String, progress:Double)
}

// MARK: - Set Chat Table Observer
class FirebaseChatMessages: NSObject {
    static let sharedInstance = FirebaseChatMessages()
    var delegate: FirebaseChatDelegate?
    
    func removeFireBaseChatObserver(other_user_id: String) {
        let observer_id = UIFunction.getChatDialogueId(for: other_user_id)
        if !observer_id.isEmpty {
            FirRef.child(FirebaseMessagesTable.tableName).child(observer_id).removeAllObservers()
            FirRef.child(FirebaseMessagesTable.tableName).removeAllObservers()
        }
    }
    
    func setObserverForChatTable(other_user_id:String) {
        let observer_id = UIFunction.getChatDialogueId(for: other_user_id)
        let firebaseReference = FirRef.child((FirebaseMessagesTable.tableName)).child(observer_id)
       
        firebaseReference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    if let dict = snap.value as? NSDictionary {
                        self.didReceiveSnapshot(dict: dict)
                    }
                }
            }
        }
        
        firebaseReference.observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                if let dict = snapshot.value as? NSDictionary {
                    self.didReceiveSnapshot(dict: dict)
                }
            }
        })
        
        firebaseReference.observe(.childChanged, with: { (snapshot) in
            if snapshot.exists() {
                if let dict = snapshot.value as? NSDictionary {
                    self.didReceiveSnapshot(dict: dict)
                }
            }
        })
    }
    
    func didReceiveSnapshot(dict: NSDictionary, isChatHistory: Bool = false) {
        if isChatHistory {
            
            let message_id = dict.objectForKeyAsString(key: ChatMessagesHistoryTable.message_id)
            let message = dict.objectForKeyAsString(key: ChatMessagesHistoryTable.message)
            let message_type = dict.objectForKeyAsInt(key: ChatMessagesHistoryTable.message_type)
            let message_time = dict.objectForKeyAsString(key: ChatMessagesHistoryTable.message_time)
            let firebase_message_time = dict.objectForKeyAsString(key: ChatMessagesHistoryTable.firebase_message_time)
            let chat_dialog_id = dict.objectForKeyAsString(key: ChatMessagesHistoryTable.chat_dialog_id)
            let sender_id = dict.objectForKeyAsString(key: ChatMessagesHistoryTable.sender_id)
            let attachment_url = dict.objectForKeyAsString(key: ChatMessagesHistoryTable.attachment_url)
            let message_read_status = dict.value(forKey: ChatMessagesHistoryTable.message_read_status) as? NSDictionary
            let receiver_id =  dict.objectForKeyAsString(key: ChatMessagesHistoryTable.receiver_id)
            
            self.didReceiveMessage(message_id: message_id, message: message, message_type: message_type, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: sender_id, attachment_url: attachment_url, message_read_status: message_read_status, receiver_id: receiver_id)
        } else {
            let message_id = dict.objectForKeyAsString(key: FirebaseMessagesTable.message_id)
            let message = dict.objectForKeyAsString(key: FirebaseMessagesTable.message)
            let message_type = dict.objectForKeyAsInt(key: FirebaseMessagesTable.message_type)
            let message_time = dict.objectForKeyAsString(key: FirebaseMessagesTable.message_time)
            let firebase_message_time = dict.objectForKeyAsString(key: FirebaseMessagesTable.firebase_message_time)
            let chat_dialog_id = dict.objectForKeyAsString(key: FirebaseMessagesTable.chat_dialog_id)
            let sender_id = dict.objectForKeyAsString(key: FirebaseMessagesTable.sender_id)
            let attachment_url = dict.objectForKeyAsString(key: FirebaseMessagesTable.attachment_url)
            let message_read_status = dict.value(forKey: FirebaseMessagesTable.message_read_status) as? NSDictionary
            let receiver_id =  dict.objectForKeyAsString(key: FirebaseMessagesTable.receiver_id)

            self.didReceiveMessage(message_id: message_id, message: message, message_type: message_type, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: sender_id, attachment_url: attachment_url, message_read_status: message_read_status, receiver_id: receiver_id)
        }
    }
}

// MARK: - Mark Message as Read
extension FirebaseChatMessages {
    
    func markAllUnReadMessgesAsRead(other_user_id: String) {
        if let messages = self.getAllUnReadMessages(other_user_id: other_user_id) {
            for chatMessage in messages {
                let message_id = chatMessage.message_id ?? ""
                let user_id = UIFunction.getCurrentUserId()
                let chat_dialogue_id = chatMessage.chat_dialog_id ?? ""

                if let read_status = chatMessage.message_read_status?.asDictionary() {
                    let allKeys = read_status.allKeys as? NSArray ?? NSArray()
                    if allKeys.contains(user_id) {
                        self.markMessageAsRead(for: message_id, and: chat_dialogue_id)
                    }
                }
            }
        }
    }
    
    func markMessageAsRead(for message_id: String, and chat_dialogue_id: String) {
        let user_id = UIFunction.getCurrentUserId()
        if !user_id.isEmpty && !message_id.isEmpty && !chat_dialogue_id.isEmpty {
            FirRef.child(FirebaseMessagesTable.tableName).child(chat_dialogue_id).child(message_id).child(FirebaseMessagesTable.message_read_status).child(user_id).setValue(nil)
            self.markMessageAsReadInLocalDatabase(for: message_id)
        }
    }
}

// MARK: - Delete Message
extension FirebaseChatMessages {
    func deleteMessageOnFirebase(for message_id: String, chat_dialogue_id: String, sender_id: String?) {
        if let sender_id = sender_id, !sender_id.isEmpty, UIFunction.getCurrentUserId() != sender_id {
            FirRef.child(FirebaseMessagesTable.tableName).child(chat_dialogue_id).child(message_id).removeValue()
        }
    }
}

func fireBaseChatMessages() -> FirebaseChatMessages {
    return FirebaseChatMessages.sharedInstance
}

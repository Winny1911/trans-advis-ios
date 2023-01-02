//
//  FirebaseChatInbox.swift
//  Business App
//
//  Created by Ankit Goyal on 20/09/20.
//  Copyright © 2020 Ankit Goyal. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseStorage
import FirebaseDatabase


protocol FirebaseInboxMessageDelegate {
    func didRefreshChatInboxTable()
}

// MARK: - Set Inbox Message Table Observer
class FirebaseChatInbox: NSObject {
    static let sharedInstance = FirebaseChatInbox()
    var delegate: FirebaseInboxMessageDelegate?
    
    func setFirebaseInboxObserver(for chat_dialog_id: String) {
        let firebaseReference = FirRef.child(FirebaseChatsTable.tableName).child(chat_dialog_id)
        
        self.observeFirebaseSingleEvent(for: chat_dialog_id)
        
        firebaseReference.observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                self.observeFirebaseSingleEvent(for: chat_dialog_id)
            }
        })
        
        firebaseReference.observe(.childChanged, with: { (snapshot) in
            if snapshot.exists() {
                self.observeFirebaseSingleEvent(for: chat_dialog_id)
            }
        })
    }
    
    func observeFirebaseSingleEvent(for chat_dialog_id: String) {
        let firebaseReference = FirRef.child(FirebaseChatsTable.tableName).child(chat_dialog_id)
        firebaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                if let dict = snapshot.value as? NSDictionary {
                    let chat_dialog_id = dict.objectForKeyAsString(key: FirebaseChatsTable.chat_dialog_id)
                    let last_message = dict.objectForKeyAsString(key: FirebaseChatsTable.last_message)
                    let last_message_time = dict.objectForKeyAsString(key: FirebaseChatsTable.last_message_time)
                    let last_message_sender_id = dict.objectForKeyAsString(key: FirebaseChatsTable.last_message_sender_id)
                    let participant_ids = dict.objectForKeyAsString(key: FirebaseChatsTable.participant_ids)
                    let unread_count = dict.value(forKey: FirebaseChatsTable.unread_count) as? NSDictionary
                    let profile_pic = dict.value(forKey: FirebaseChatsTable.profile_pic) as? NSDictionary
                    let name = dict.value(forKey: FirebaseChatsTable.name) as? NSDictionary
                    let last_message_id = dict.objectForKeyAsString(key: FirebaseChatsTable.last_message_id)
                    let last_message_type = dict.objectForKeyAsInt(key: FirebaseChatsTable.last_message_type)
                    let dialog_type = dict.objectForKeyAsInt(key: FirebaseChatsTable.dialog_type)
                    
                    if !chat_dialog_id.isEmpty {
                        self.didReceiveMessage(chat_dialog_id: chat_dialog_id, last_message: last_message, last_message_time: last_message_time, last_message_sender_id: last_message_sender_id, participant_ids: participant_ids, unread_count: unread_count, profile_pic: profile_pic, name: name, last_message_id: last_message_id, last_message_type: last_message_type, dialog_type: dialog_type)
                    }
                }
            }
        })
    }
    
    func updateReadCountInOtherUserInbox(for chat_dialogue_id: String, other_user_id: String) {
        FirRef.child(FirebaseChatsTable.tableName).child(chat_dialogue_id).child(FirebaseChatsTable.unread_count).child(other_user_id).setValue(1)
        self.updateReadCountInOtherUserInboxLocalDB(for: chat_dialogue_id, other_user_id: other_user_id)
    }
    
    func updateReadCountInOwnInbox(for chat_dialogue_id: String) {
        let user_id = UIFunction.getCurrentUserId()
        FirRef.child(FirebaseChatsTable.tableName).child(chat_dialogue_id).child(FirebaseChatsTable.unread_count).child(user_id).setValue(0)
        self.updateReadCountInOwnInboxLocalDB(for: chat_dialogue_id)
    }
    
    func removeAllFirebaseInboxObservers() {
        let chat_dialogue_ids = appDelegate().chatObserverArray
        for chat_dialogue_id in chat_dialogue_ids {
            let chat_dialogue_id = chat_dialogue_id as? String ?? ""
            removeFireBaseInboxObserver(for: chat_dialogue_id)
        }
    }
    
    private func removeFireBaseInboxObserver(for chat_dialog_id: String) {
        FirRef.child(FirebaseChatsTable.tableName).child(chat_dialog_id).removeAllObservers()
        FirRef.child(FirebaseChatsTable.tableName).removeAllObservers()
    }
}

func fireBaseChatInbox() -> FirebaseChatInbox {
    return FirebaseChatInbox.sharedInstance
}

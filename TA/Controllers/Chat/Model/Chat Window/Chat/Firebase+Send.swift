//
//  ExtensionFirebaseSendMessage.swift
//  Business App
//
//  Created by Ankit Goyal on 21/09/20.
//  Copyright © 2020 Ankit Goyal. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseStorage
import FirebaseDatabase


// MARK: - Send Text Message
extension FirebaseChatMessages {
    
    func insertMessageToFirebaseChatTable(message_id: String,
                                          message: String,
                                          message_type: Int,
                                          message_time: String,
                                          firebase_message_time: Any,
                                          chat_dialog_id: String,
                                          sender_id: String,
                                          attachment_url: String,
                                          receiver_id: String,
                                          other_user_profile_pic: String,
                                          other_user_name: String,
                                          dialog_type: Int,
                                          thumbnail:String) {
        
        let chat_dialog_id = UIFunction.getChatDialogueId(for: receiver_id)
        let user_id = UIFunction.getCurrentUserId()
        
        if message_type == FirebaseMessageType.Text {
            
            self.sendMessageToFirebaseChatTable(message_id: message_id, message: message, message_type: FirebaseMessageType.Text, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: user_id, attachment_url: "", receiver_id: receiver_id)
         
            self.updateLastMessageInInboxTable(other_user_id: receiver_id, last_message: message, last_message_time: message_time, sender_id: user_id, other_user_profile_pic: other_user_profile_pic, other_user_name: other_user_name, last_message_id: message_id, last_message_type: FirebaseMessageType.Text, dialog_type: dialog_type)
            
            self.updateChatDialogueIdInUserTable(chat_dialogue_id: chat_dialog_id, other_user_id: receiver_id)
            
            self.sendMessageToFirebaseNotificationTable(message_id: message_id, message: message, message_type: FirebaseMessageType.Text, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: user_id, attachment_url: "", receiver_id: receiver_id)
            
        } else if message_type == FirebaseMessageType.Image {
            
            self.uploadAttachment(chat_dialogue_id: chat_dialog_id, message_id: message_id, attachment_path: message) { attachmentUrl in
               
                if let attachement_url = attachmentUrl {
                    let last_message = self.getTextForLastMessage(message: message, message_type: message_type)

                    self.sendMessageToFirebaseChatTable(message_id: message_id, message: last_message, message_type: FirebaseMessageType.Image, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: user_id, attachment_url: attachement_url, receiver_id: receiver_id)

                    self.updateLastMessageInInboxTable(other_user_id: receiver_id, last_message: last_message, last_message_time: message_time, sender_id: user_id, other_user_profile_pic: other_user_profile_pic, other_user_name: other_user_name, last_message_id: message_id, last_message_type: FirebaseMessageType.Text, dialog_type: dialog_type)
                    
                    self.updateChatDialogueIdInUserTable(chat_dialogue_id: chat_dialog_id, other_user_id: receiver_id)
                    
                    self.sendMessageToFirebaseNotificationTable(message_id: message_id, message: last_message, message_type: FirebaseMessageType.Image, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: user_id, attachment_url: attachement_url, receiver_id: receiver_id)
                }
            }
        } else if message_type == FirebaseMessageType.Document {
            
            self.uploadDocument(message_type: message_type, chat_dialogue_id: chat_dialog_id, message_id: message_id, attachment_path: attachment_url, file_name: message) { attachmentUrl in
                if let attachement_url = attachmentUrl {
                    let last_message = self.getTextForLastMessage(message: message, message_type: message_type)

                    self.sendMessageToFirebaseChatTable(message_id: message_id, message: message, message_type: FirebaseMessageType.Document, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: user_id, attachment_url: attachement_url, receiver_id: receiver_id)

                    self.updateLastMessageInInboxTable(other_user_id: receiver_id, last_message: last_message, last_message_time: message_time, sender_id: user_id, other_user_profile_pic: other_user_profile_pic, other_user_name: other_user_name, last_message_id: message_id, last_message_type: FirebaseMessageType.Document, dialog_type: dialog_type)
                    
                    self.updateChatDialogueIdInUserTable(chat_dialogue_id: chat_dialog_id, other_user_id: receiver_id)
                    
                    self.sendMessageToFirebaseNotificationTable(message_id: message_id, message: message, message_type: FirebaseMessageType.Document, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: user_id, attachment_url: attachement_url, receiver_id: receiver_id)
                }
            }
        }
    }
    
    func sendMessageToFirebaseChatTable(message_id: String,
                                          message: String,
                                          message_type: Int,
                                          message_time: String,
                                          firebase_message_time: Any,
                                          chat_dialog_id: String,
                                          sender_id: String,
                                          attachment_url: String,
                                          receiver_id: String) {
        
        let observer_id = UIFunction.getChatDialogueId(for: receiver_id)
        let read_status = [receiver_id : receiver_id]
        let dictionary : NSDictionary = [
            FirebaseMessagesTable.message_id : message_id,
            FirebaseMessagesTable.message : message,
            FirebaseMessagesTable.message_type : message_type,
            FirebaseMessagesTable.message_time : Int64(message_time) ?? "",
            FirebaseMessagesTable.firebase_message_time : firebase_message_time,
            FirebaseMessagesTable.chat_dialog_id : chat_dialog_id,
            FirebaseMessagesTable.sender_id : sender_id,
            FirebaseMessagesTable.attachment_url : attachment_url,
            FirebaseMessagesTable.message_read_status : read_status,
            FirebaseMessagesTable.receiver_id : receiver_id
        ]
        
        FirRef.child(FirebaseMessagesTable.tableName).child(observer_id).child(message_id).setValue(dictionary)
    }
}

// MARK: - Update Last Message in Inbox Table
extension FirebaseChatMessages
{
    func updateLastMessageInInboxTable(other_user_id: String,
                                       last_message: String,
                                       last_message_time: String,
                                       sender_id: String,
                                       other_user_profile_pic: String,
                                       other_user_name: String,
                                       last_message_id: String,
                                       last_message_type: Int,
                                       dialog_type: Int) {
        
        let chat_dialogue_id = UIFunction.getChatDialogueId(for: other_user_id)
        let user_id = UIFunction.getCurrentUserId()
        let unread_count = [user_id: 0,
                      other_user_id: 1]
        let profile_pic = [user_id : UIFunction.getCurrentUserProfilePic(),
                     other_user_id : other_user_profile_pic]
        
        let name = [user_id : UIFunction.getCurrentUserName(),
              other_user_id : other_user_name]
        
        
        let dictionary : Dictionary = [
            FirebaseChatsTable.chat_dialog_id : chat_dialogue_id,
            FirebaseChatsTable.last_message : last_message,
            FirebaseChatsTable.last_message_time : Int64(last_message_time) ?? "",
            FirebaseChatsTable.last_message_sender_id : user_id,
            FirebaseChatsTable.participant_ids : chat_dialogue_id,
            FirebaseChatsTable.unread_count : unread_count,
            FirebaseChatsTable.profile_pic : profile_pic,
            FirebaseChatsTable.name : name,
            FirebaseChatsTable.last_message_id : last_message_id,
            FirebaseChatsTable.last_message_type: last_message_type,
            FirebaseChatsTable.dialog_type: dialog_type,
            ] as [AnyHashable : Any]
        
        FirRef.child(FirebaseChatsTable.tableName).child(chat_dialogue_id).setValue(dictionary)
    }
}

// MARK: -  Send Message in Notification Table
extension FirebaseChatMessages {
   
    func sendMessageToFirebaseNotificationTable(message_id: String,
                                          message: String,
                                          message_type: Int,
                                          message_time: String,
                                          firebase_message_time: Any,
                                          chat_dialog_id: String,
                                          sender_id: String,
                                          attachment_url: String,
                                          receiver_id: String) {
        
        let read_status = [receiver_id : receiver_id]
        let dictionary : NSDictionary = [
            FirebaseMessagesTable.message_id : message_id,
            FirebaseMessagesTable.message : message,
            FirebaseMessagesTable.message_type : message_type,
            FirebaseMessagesTable.message_time : message_time,
            FirebaseMessagesTable.firebase_message_time : firebase_message_time,
            FirebaseMessagesTable.chat_dialog_id : chat_dialog_id,
            FirebaseMessagesTable.sender_id : sender_id,
            FirebaseMessagesTable.attachment_url : attachment_url,
            FirebaseMessagesTable.message_read_status : read_status,
            FirebaseMessagesTable.receiver_id : receiver_id
        ]
        
        FirRef.child(FirebaseNotificationTable.tableName).child(message_id).setValue(dictionary)
    }
}

// MARK: - Update Chat Dialogue Id in user profile
extension FirebaseChatMessages
{
    func updateChatDialogueIdInUserTable(chat_dialogue_id: String, other_user_id: String) {
        
        let user_id = UIFunction.getCurrentUserId()
        let dictionary = [chat_dialogue_id: chat_dialogue_id]
        FirRef.child(FirebaseUsersTable.tableName).child(user_id).child(FirebaseUsersTable.chat_dialog_ids).updateChildValues(dictionary)
        FirRef.child(FirebaseUsersTable.tableName).child(other_user_id).child(FirebaseUsersTable.chat_dialog_ids).updateChildValues(dictionary)
    }
}

// MARK: - Send Media Message
extension FirebaseChatMessages {
    
    func uploadAttachment(chat_dialogue_id: String, message_id : String, attachment_path:String, completion:@escaping(_ attachmentUrl:String?)->Void) {
     
        let storage = Storage.storage()
        var storageRef:StorageReference!
        let metadata = StorageMetadata()
        let fileName = "IMG\(message_id).jpg"
                   
        storageRef = storage.reference(forURL: FirebaseStorageURL).child(FirebaseStorgeTable.table_name).child(chat_dialogue_id).child(fileName)
        metadata.contentType = "image/jpeg"
        let local_image = UIFunction.getImageFromPath(path: attachment_path) ?? UIImage()
        
        if let data = local_image.jpegData(compressionQuality: 0.3) {
            _ = storageRef.putData(data, metadata: metadata) { (metaData, error) in
                if error == nil {
                    storageRef.downloadURL { url, error1 in
                        if error1 != nil {
                            completion(nil)
                        } else {
                            completion((url?.absoluteString)!)
                        }
                    }
                }
            }
        }
    }
    
    
    func uploadDocument(message_type: Int ,chat_dialogue_id: String, message_id : String, attachment_path:String, file_name:String, completion:@escaping(_ attachmentUrl:String?) -> Void) {
      
        let storage = Storage.storage()
        var storageRef:StorageReference!
        let fileName = "Document\(message_id)-\(file_name)"
                           
        storageRef = storage.reference(forURL: FirebaseStorageURL).child(FirebaseStorgeTable.table_name).child(chat_dialogue_id).child(fileName)
                
        if let file_path = URL(string: attachment_path) {
            _ = storageRef.putFile(from: file_path, metadata: nil) { metadata, error in
                if error == nil {
                    storageRef.downloadURL { url, error1 in
                        if error1 != nil {
                            completion(nil)
                        } else {
                            completion((url?.absoluteString)!)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Get Last Message
extension FirebaseChatMessages {
    
    func getTextForLastMessage(message: String, message_type: Int) -> String {
        var last_message : String! = ""
        if message_type == FirebaseMessageType.Text {
            last_message = message
        } else if message_type == FirebaseMessageType.Image {
            last_message = "📷 Photo"
        } else if (message_type == FirebaseMessageType.Document) {
            last_message = "✉️ Document"
        }
        return last_message
    }
}


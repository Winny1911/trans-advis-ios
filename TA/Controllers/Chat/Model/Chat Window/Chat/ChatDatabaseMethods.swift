//
//  ChatDatabaseMethods.swift
//  Business App
//
//  Created by Ankit Goyal on 21/09/20.
//  Copyright © 2020 Ankit Goyal. All rights reserved.
//

import UIKit
import CoreData


// MARK: -  --------------- Local Database ---------------
extension FirebaseChatMessages {
    func didReceiveMessage(message_id: String, message: String, message_type: Int, message_time: String, firebase_message_time: String, chat_dialog_id: String, sender_id: String, attachment_url: String, message_read_status: NSDictionary?, receiver_id: String) {
     
        if let messages = self.getMessageWithId(message_id: message_id), messages.count > 0, let chat_window_message = messages.first { // update message
            
            self.updateMessage(message_id: message_id, message: message, message_type: message_type, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: sender_id, attachment_url: attachment_url, message_read_status: message_read_status, receiver_id: receiver_id, chatMessage: chat_window_message)
        } else {
            // insert message
            self.saveMessage(message_id: message_id, message: message, message_type: message_type, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialog_id, sender_id: sender_id, attachment_url: attachment_url, message_read_status: message_read_status, receiver_id: receiver_id)
        }
    }
    
    func getMessageWithId(message_id:String) -> [ChatMessages]? {
        var messages = [ChatMessages]()
        do {
            let context = appDelegate().persistentContainer.viewContext
            let request = ChatMessages.fetchRequest() as NSFetchRequest<ChatMessages>
                            
            // set the filtering and sorting of the request
            let pred = NSPredicate(format: "\(FirebaseMessagesTable.message_id) == %@",message_id )
            request.predicate = pred
            messages = try context.fetch(request)
            return messages
        } catch{
            UIFunction.AGLogs(log: "Error while fetching chat window message" as AnyObject)
        }
        
        return nil
    }
    
    func saveMessage(message_id: String, message: String, message_type: Int, message_time: String, firebase_message_time: String, chat_dialog_id: String, sender_id: String, attachment_url: String, message_read_status: NSDictionary?, receiver_id: String) {
        let message_read_status_string = message_read_status?.asJSONString()

        let context = appDelegate().persistentContainer.viewContext
        let chatMessage = ChatMessages(context: context)
        chatMessage.message_id = message_id
        chatMessage.message = message
        chatMessage.message_type = Int16(message_type)
        chatMessage.message_time = message_time
        chatMessage.firebase_message_time = firebase_message_time
        chatMessage.chat_dialog_id = chat_dialog_id
        chatMessage.sender_id = sender_id
        chatMessage.attachment_url = attachment_url
        chatMessage.message_read_status = message_read_status_string
        chatMessage.receiver_id = receiver_id

        do {
            try context.save()
            if chat_dialog_id == appDelegate().chat_dialogue_id {
                self.delegate?.didReceiveNewMessage(chat_message: chatMessage)
            }
        } catch  {
            UIFunction.AGLogs(log: "Error while save data in db" as AnyObject)
        }
    }
    
    func updateMessage(message_id: String, message: String, message_type: Int, message_time: String, firebase_message_time: String, chat_dialog_id: String, sender_id: String, attachment_url: String, message_read_status: NSDictionary?, receiver_id: String, chatMessage: ChatMessages) {
       
        let message_read_status_string = message_read_status?.asJSONString()
        
        let context = appDelegate().persistentContainer.viewContext
        chatMessage.message_id = message_id
        chatMessage.message = message
        chatMessage.message_type = Int16(message_type)
        chatMessage.message_time = message_time
        chatMessage.firebase_message_time = firebase_message_time
        chatMessage.chat_dialog_id = chat_dialog_id
        chatMessage.sender_id = sender_id
        chatMessage.attachment_url = attachment_url
        chatMessage.message_read_status = message_read_status_string
        chatMessage.receiver_id = receiver_id

        do {
            try context.save()
            
            if chat_dialog_id == appDelegate().chat_dialogue_id {
                self.delegate?.didReceiveNewMessage(chat_message: chatMessage)
            }
        } catch  {
            UIFunction.AGLogs(log: "Error while update data in db" as AnyObject)
        }
    }
    
    func getAllChatMessages(other_user_id:String, completion: @escaping(_ chatWindowMessages: [ChatMessages]) -> Void) {
        
        let observer_id = UIFunction.getChatDialogueId(for: other_user_id)
        var messages = [ChatMessages]()
        do {
            let context = appDelegate().persistentContainer.viewContext
            let request =  ChatMessages.fetchRequest() as NSFetchRequest<ChatMessages>
            
            let pred = NSPredicate(format: "\(FirebaseMessagesTable.chat_dialog_id) == %@", observer_id)
            request.predicate = pred
            
            let sort = NSSortDescriptor(key: FirebaseMessagesTable.firebase_message_time, ascending: true)
            request.sortDescriptors = [sort]
            
            messages = try context.fetch(request)
            completion(messages)
        } catch {
            UIFunction.AGLogs(log: "Error while fetching chat messages" as AnyObject)
        }
    }
    
    func updateProgress(message_id: String, progress: Double) {
      
        let context = appDelegate().persistentContainer.viewContext
        let request = ChatMessages.fetchRequest() as NSFetchRequest<ChatMessages>
        var messages = [ChatMessages]()

        let pred = NSPredicate(format: "\(FirebaseMessagesTable.message_id) == %@ AND progress != %f AND \(FirebaseMessagesTable.attachment_url) != %@ AND \(FirebaseMessagesTable.attachment_url) != %@",message_id, 1.0, "http", "https")
        request.predicate = pred
        
        do {
            messages = try context.fetch(request)
            if !messages.isEmpty {
                let managedObject = messages.first
                managedObject?.progress = progress
                do {
                    try context.save()
                    self.delegate?.didUpdateProgress(message_id: message_id, progress: progress)
                } catch  {
                    UIFunction.AGLogs(log: "Error while update progress in db" as AnyObject)
                }
            }
        } catch{
            UIFunction.AGLogs(log: "Error while fetching chat window message" as AnyObject)
        }
    }
        
    func getAllUnReadMessages(other_user_id:String) -> [ChatMessages]? {
        let observer_id = UIFunction.getChatDialogueId(for: other_user_id)

        var messages = [ChatMessages]()
        do {
            let user_id = UIFunction.getCurrentUserId()
            let context = appDelegate().persistentContainer.viewContext
            let request = ChatMessages.fetchRequest() as NSFetchRequest<ChatMessages>
            
            // set the filtering and sorting of the request
            let pred = NSPredicate(format: "\(FirebaseMessagesTable.chat_dialog_id) == %@ AND \(FirebaseMessagesTable.message_read_status) contains[c] %@ AND \(FirebaseMessagesTable.sender_id) == %@",observer_id, user_id, other_user_id)
            
            request.predicate = pred
            messages = try context.fetch(request)
            return messages
        } catch {
            UIFunction.AGLogs(log: "Error while fetching chat window message" as AnyObject)
        }
        
        return nil
    }
    
    func markMessageAsReadInLocalDatabase(for message_id: String) {
        var messages = [ChatMessages]()
        do {
            let context = appDelegate().persistentContainer.viewContext
            let request = ChatMessages.fetchRequest() as NSFetchRequest<ChatMessages>
                            
            // set the filtering and sorting of the request
            let pred = NSPredicate(format: "\(FirebaseMessagesTable.message_id) == %@",message_id )
            request.predicate = pred
            messages = try context.fetch(request)
            if !messages.isEmpty {
                let managedObject = messages.first
                managedObject?.message_read_status = nil
                do {
                    try context.save()
                } catch  {
                    UIFunction.AGLogs(log: "Error while update read status of message in db" as AnyObject)
                }
            }
        } catch {
            UIFunction.AGLogs(log: "Error while fetching chat window message" as AnyObject)
        }
    }
}



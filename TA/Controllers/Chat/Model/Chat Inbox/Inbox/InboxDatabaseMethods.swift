//
//  InboxDatabaseMethods.swift
//  Business App
//
//  Created by Ankit Goyal on 03/04/22.
//  Copyright © 2020 Ankit Goyal. All rights reserved.
//

import UIKit
import CoreData

// MARK: -  --------------- Local Database ---------------
extension FirebaseChatInbox
{
    func didReceiveMessage(chat_dialog_id: String, last_message: String, last_message_time: String, last_message_sender_id: String, participant_ids: String, unread_count: NSDictionary?, profile_pic: NSDictionary?, name: NSDictionary?, last_message_id: String, last_message_type: Int, dialog_type: Int) {
      
        if let messages = self.getMessage(for: chat_dialog_id), !messages.isEmpty {
            // update message
            let message = messages.first
            self.updateMessage(chat_dialog_id: chat_dialog_id, last_message: last_message, last_message_time: last_message_time, last_message_sender_id: last_message_sender_id, participant_ids: participant_ids, unread_count: unread_count, profile_pic: profile_pic, name: name, last_message_id: last_message_id, last_message_type: last_message_type, dialog_type: dialog_type, message: message!)
        } else {
            // insert message
            self.saveMessage(chat_dialog_id: chat_dialog_id, last_message: last_message, last_message_time: last_message_time, last_message_sender_id: last_message_sender_id, participant_ids: participant_ids, unread_count: unread_count, profile_pic: profile_pic, name: name, last_message_id: last_message_id, last_message_type: last_message_type, dialog_type: dialog_type)
        }

        self.delegate?.didRefreshChatInboxTable()
    }


    func getMessage(for chat_dialogue_id: String) -> [ChatInbox]? {
        var messages = [ChatInbox]()
        do {
            let context = appDelegate().persistentContainer.viewContext
            let request = ChatInbox.fetchRequest() as NSFetchRequest<ChatInbox>

            // set the filtering and sorting of the request
            let pred = NSPredicate(format: "\(FirebaseChatsTable.chat_dialog_id) == %@",chat_dialogue_id)
            request.predicate = pred
            messages = try context.fetch(request)
            return messages
        }
        catch{
            UIFunction.AGLogs(log: "Error while fetching chat inbox" as AnyObject)
        }

        return nil
    }

    func saveMessage(chat_dialog_id: String, last_message: String, last_message_time: String, last_message_sender_id: String, participant_ids: String, unread_count: NSDictionary?, profile_pic: NSDictionary?, name: NSDictionary?, last_message_id: String, last_message_type: Int, dialog_type: Int) {
        let unread_count_string = unread_count?.asJSONString()
        let profile_pic_string = profile_pic?.asJSONString()
        let name_string = name?.asJSONString()
        
        let context = appDelegate().persistentContainer.viewContext
        let message = ChatInbox(context: context)
        message.chat_dialog_id = chat_dialog_id
        message.last_message = last_message
        message.last_message_time = last_message_time
        message.last_message_sender_id = last_message_sender_id
        message.participant_ids = participant_ids
        message.unread_count = unread_count_string
        message.profile_pic = profile_pic_string
        message.name = name_string
        message.last_message_id = last_message_id
        message.last_message_type = Int16(last_message_type)
        message.dialog_type = Int16(dialog_type)
        
        do {
            try context.save()
        } catch  {
            UIFunction.AGLogs(log: "Error while save data in db" as AnyObject)
        }
    }

    func updateMessage(chat_dialog_id: String, last_message: String, last_message_time: String, last_message_sender_id: String, participant_ids: String, unread_count: NSDictionary?, profile_pic: NSDictionary?, name: NSDictionary?, last_message_id: String, last_message_type: Int, dialog_type: Int, message:ChatInbox) {
        let unread_count_string = unread_count?.asJSONString()
        let profile_pic_string = profile_pic?.asJSONString()
        let name_string = name?.asJSONString()
        
        let context = appDelegate().persistentContainer.viewContext
        message.chat_dialog_id = chat_dialog_id
        message.last_message = last_message
        message.last_message_time = last_message_time
        message.last_message_sender_id = last_message_sender_id
        message.participant_ids = participant_ids
        message.unread_count = unread_count_string
        message.profile_pic = profile_pic_string
        message.name = name_string
        message.last_message_id = last_message_id
        message.last_message_type = Int16(last_message_type)
        message.dialog_type = Int16(dialog_type)
        
        do {
            try context.save()
        } catch  {
            UIFunction.AGLogs(log: "Error while save data in db" as AnyObject)
        }
    }
    
    func getAllInboxMessages() -> [ChatInbox] {
        var messages = [ChatInbox]()
        do {
            let context = appDelegate().persistentContainer.viewContext
            let request = ChatInbox.fetchRequest() as NSFetchRequest<ChatInbox>
            let sort = NSSortDescriptor(key: FirebaseChatsTable.last_message_time, ascending: false)
            request.sortDescriptors = [sort]
            messages = try context.fetch(request)
            return messages
        }
        catch{
            UIFunction.AGLogs(log: "Error while fetching chat inbox" as AnyObject)
        }

        return [ChatInbox]()
    }

    func updateReadCountInOtherUserInboxLocalDB(for chat_dialogue_id: String, other_user_id: String) {
        if let messages = self.getMessage(for: chat_dialogue_id), !messages.isEmpty, let unread_count = messages.first?.unread_count {
            
            if let unReadCountDictionary = unread_count.asDictionary() {
                var tempDict = NSMutableDictionary()
                tempDict = unReadCountDictionary.mutableCopy() as! NSMutableDictionary
                
                tempDict.setValue("1", forKey: other_user_id)
                let unReadCountJSONString = tempDict.asJSONString()
            
                let message = messages.first
                let context = appDelegate().persistentContainer.viewContext
                message!.unread_count = unReadCountJSONString
                do {
                    try context.save()

                } catch  {
                    UIFunction.AGLogs(log: "Error while update data in db" as AnyObject)
                }
            }
        }
    }
    
    func updateReadCountInOwnInboxLocalDB(for chat_dialogue_id: String) {
        if let messages = self.getMessage(for: chat_dialogue_id), !messages.isEmpty, let unread_count = messages.first?.unread_count {
            
            if let unReadCountDictionary = unread_count.asDictionary() {
                let user_id = UIFunction.getCurrentUserId()
                var tempDict = NSMutableDictionary()
                tempDict = unReadCountDictionary.mutableCopy() as! NSMutableDictionary
                
                tempDict.setValue("0", forKey: user_id)
                let unReadCountJSONString = tempDict.asJSONString()
            
                let message = messages.first
                let context = appDelegate().persistentContainer.viewContext
                message!.unread_count = unReadCountJSONString
                do {
                    try context.save()

                } catch  {
                    UIFunction.AGLogs(log: "Error while update data in db" as AnyObject)
                }
            }
        }
    }
}

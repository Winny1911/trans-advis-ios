//
//  FirebaseUsers+Database.swift
//  TA
//
//  Created by global on 05/04/22.
//

import UIKit
import CoreData

// MARK: -  --------------- Local Database ---------------
extension FirebaseUsers
{
    func didReceiveUsersChatDialogueIds(chat_dialog_ids: NSDictionary?) {
        
        if let chat_dialog_ids = chat_dialog_ids {
            deleteChatIdsFromLocalDatabase()
            saveChatDialogueIds(chat_dialog_ids: chat_dialog_ids)
        }
        self.delegate?.didRefreshNewChatDialogue()
    }
    
    func deleteChatIdsFromLocalDatabase() {
        let user_id = UIFunction.getCurrentUserId()
        if !user_id.isEmpty {
            do {
                let context = appDelegate().persistentContainer.viewContext
                let request = ChatUser.fetchRequest() as NSFetchRequest<ChatUser>

                // set the filtering and sorting of the request
                let chat_dialogue_ids = try context.fetch(request)
                if !chat_dialogue_ids.isEmpty {
                    context.delete(chat_dialogue_ids.first!)
                    do {
                        try context.save()
                    } catch {
                        UIFunction.AGLogs(log: "Error while deleting chat ids from user table" as AnyObject)
                    }
                }
            }
            catch{
                UIFunction.AGLogs(log: "Error while fetching chat ids from user table" as AnyObject)
            }
        }
        
    }
    
    func saveChatDialogueIds(chat_dialog_ids: NSDictionary) {
        let chatDialogueIdsString = chat_dialog_ids.asJSONString()
        let context = appDelegate().persistentContainer.viewContext
        let user = ChatUser(context: context)
        user.chat_dialog_ids = chatDialogueIdsString
        do {
            try context.save()
        } catch {
            UIFunction.AGLogs(log: "Error while save data in db" as AnyObject)
        }
    }
    
    func getAllChatDialogueIds() -> String? {
        var user = [ChatUser]()
        do {
            let context = appDelegate().persistentContainer.viewContext
            let request = ChatUser.fetchRequest() as NSFetchRequest<ChatUser>
            user = try context.fetch(request)
            if !user.isEmpty {
                return user.first?.chat_dialog_ids
            }
        }
        catch {
            UIFunction.AGLogs(log: "Error while fetching chat inbox" as AnyObject)
        }

        return nil
    }
}


//
//  ChatUser+CoreDataProperties.swift
//  
//
//  Created by global on 05/04/22.
//
//

import Foundation
import CoreData


extension ChatUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatUser> {
        return NSFetchRequest<ChatUser>(entityName: "ChatUser")
    }

    @NSManaged public var chat_dialog_ids: String?

}

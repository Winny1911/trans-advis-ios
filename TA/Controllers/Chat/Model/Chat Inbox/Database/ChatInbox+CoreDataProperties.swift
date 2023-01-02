//
//  ChatInbox+CoreDataProperties.swift
//  
//
//  Created by global on 05/04/22.
//
//

import Foundation
import CoreData


extension ChatInbox {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatInbox> {
        return NSFetchRequest<ChatInbox>(entityName: "ChatInbox")
    }

    @NSManaged public var chat_dialog_id: String?
    @NSManaged public var dialog_type: Int16
    @NSManaged public var last_message: String?
    @NSManaged public var last_message_id: String?
    @NSManaged public var last_message_sender_id: String?
    @NSManaged public var last_message_time: String?
    @NSManaged public var last_message_type: Int16
    @NSManaged public var name: String?
    @NSManaged public var participant_ids: String?
    @NSManaged public var profile_pic: String?
    @NSManaged public var unread_count: String?

}

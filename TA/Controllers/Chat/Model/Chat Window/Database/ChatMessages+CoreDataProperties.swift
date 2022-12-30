//
//  ChatMessages+CoreDataProperties.swift
//  
//
//  Created by global on 08/04/22.
//
//

import Foundation
import CoreData


extension ChatMessages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMessages> {
        return NSFetchRequest<ChatMessages>(entityName: "ChatMessages")
    }

    @NSManaged public var attachment_url: String?
    @NSManaged public var chat_dialog_id: String?
    @NSManaged public var firebase_message_time: String?
    @NSManaged public var message: String?
    @NSManaged public var message_id: String?
    @NSManaged public var message_read_status: String?
    @NSManaged public var message_time: String?
    @NSManaged public var message_type: Int16
    @NSManaged public var receiver_id: String?
    @NSManaged public var sender_id: String?
    @NSManaged public var progress: Double

}

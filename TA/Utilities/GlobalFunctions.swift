//
//  GlobalFunctions.swift
//  TA
//
//  Created by Applify  on 09/12/21.
//

import Foundation
import SwiftMessages
import SDWebImage

var isNotificationRead = true
var isInviteNotificationRead = true


func showMessage(with title: String, theme: Theme = .error) {
    SwiftMessages.show {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureContent(title: title , body: title, iconImage: Icon.info.image)
        view.button?.isHidden = true
//        view.bodyLabel?.font = UIFont.appRegularFont(with: 15)
        view.titleLabel?.isHidden = true
        view.iconLabel?.isHidden = true
        return view
    }
}

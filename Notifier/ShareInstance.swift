//
//  ShareInstance.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import Foundation

class ShareInstance {
    
    static let shared = ShareInstance()
    private init(){}
    
    var isAllowPushNotification: Bool = false
    var notiItem: NoteItemModel?
    
}

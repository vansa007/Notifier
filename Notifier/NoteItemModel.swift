//
//  NoteItemModel.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import RealmSwift

class NoteItemModel: Object {
    
    @objc private(set) dynamic var id = -1
    @objc private(set) dynamic var date_created: String = ""
    @objc private(set) dynamic var title_note: String = ""
    @objc private(set) dynamic var meaning_note: String = ""
    @objc private(set) dynamic var sts: Int = -1
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, dateCreated: String, titleNote: String, meaningNote: String, status: Int) {
        self.init()
        self.id = id
        self.date_created = dateCreated
        self.title_note = titleNote
        self.meaning_note = meaningNote
        self.sts = status
    }
    
}

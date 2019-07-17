//
//  DBManager.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import RealmSwift

class DBManager {
    
    private var database: Realm
    static let shared = DBManager()
    private init() { database = try! Realm() }
    
    //-------- SRUD function
    func getDataFromDb() -> Results<NoteItemModel> {
        let results: Results<NoteItemModel> = database.objects(NoteItemModel.self)
        return results
    }
    
    func getDataFromDb(byId id: Int) -> NoteItemModel? {
        let results: Results<NoteItemModel> = database.objects(NoteItemModel.self).filter("id == %d", id)
        return results.first
    }
    
    func addData(object: NoteItemModel) {
        try! database.write {
            database.add(object, update: Realm.UpdatePolicy.modified)
            print("Added/Updated object: ", object.title_note)
        }
    }
    
    func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
            print("Delete all")
        }
    }
    
    func deleteFromDb(object: Object) {
        try! database.write {
            database.delete(object)
            print("Delete on object")
        }
    }
    
    func incrementID() -> Int {
        return (database.objects(NoteItemModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}

//
//  ViewController.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var noteTableView: UITableView!
    private var modelArr = [NoteItemModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshDataFromDB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = .white
        
        // setup auto height tableview
        noteTableView.rowHeight = UITableView.automaticDimension
        noteTableView.estimatedRowHeight = 100.0
        
        //NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "random_lession"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(showRandomLession(notification:)), name: Notification.Name(rawValue: "random_lession"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reOpenNotiMessage), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func reOpenNotiMessage() {
        if let noti_item = ShareInstance.shared.notiItem {
            let detailVc = self.storyboard?.instantiateViewController(withIdentifier: "view_detail_sid") as! DetailNoteViewController
            detailVc.itemData = noti_item
            detailVc.isHiddenContent = true
            DispatchQueue.main.async {
                self.present(detailVc, animated: true)
            }
            ShareInstance.shared.notiItem = nil
            pushAction()
        }
    }
    
    @objc func showRandomLession(notification: Notification) {
        guard let index = notification.userInfo?["noteId"] as? Int else { return }
        guard let item = DBManager.shared.getDataFromDb(byId: index) else { return }
        
        let detailVc = self.storyboard?.instantiateViewController(withIdentifier: "view_detail_sid") as! DetailNoteViewController
        detailVc.itemData = item
        detailVc.isHiddenContent = true
        DispatchQueue.main.async {
            self.present(detailVc, animated: true)
        }
        ShareInstance.shared.notiItem = nil
        pushAction()
        
    }
    
    private func pushAction() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        if modelArr.count == 0 || !ShareInstance.shared.isAllowPushNotification { return }
        var numberRandom = 0
        var pushModel: NoteItemModel!
        var i = -1
        repeat {
            numberRandom = Int.random(in: 0 ..< modelArr.count)
            pushModel = modelArr[numberRandom]
            i += 1
            print("meme: ", (pushModel.sts == 1 && i < modelArr.count))
        } while (pushModel.sts == 1 && i < modelArr.count)
        if i >= modelArr.count { return }
        
        let content = UNMutableNotificationContent()
        content.title = pushModel.title_note
        content.body = pushModel.meaning_note
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz", "noteId": pushModel.id]
        content.sound = UNNotificationSound.default
        
        //var dateComponents = DateComponents()
        //dateComponents.hour = 10
        //dateComponents.minute = 30
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1200, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    private func refreshDataFromDB() {
        var results = DBManager.shared.getDataFromDb()
        results = results.sorted(byKeyPath: "id", ascending: false)
        modelArr.removeAll()
        for element in results {
            modelArr.append(element)
        }
        noteTableView.reloadData()
        pushAction()
    }

    @IBAction func createNewNoteAction(_ sender: UIBarButtonItem) {
        let addNewVc = self.storyboard?.instantiateViewController(withIdentifier: "add_new_note_sid") as! AddNewNoteViewController
        addNewVc.delegate = self
        DispatchQueue.main.async {
            self.present(addNewVc, animated: true)
        }
    }
    
    private func gotoReadDetailNote(index: Int) {
        let detailVc = self.storyboard?.instantiateViewController(withIdentifier: "view_detail_sid") as! DetailNoteViewController
        detailVc.itemData = modelArr[index]
        DispatchQueue.main.async {
            self.present(detailVc, animated: true)
        }
    }
    
    @objc private func changeColorKnowledge(sender: UIButton) {
        let colorVc = self.storyboard?.instantiateViewController(withIdentifier: "color_sid") as! StatusKnowledgeViewController
        let item = modelArr[sender.tag]
        colorVc.item = item
        colorVc.delegate = self
        DispatchQueue.main.async {
            self.present(colorVc, animated: true)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (modelArr.count == 0) ? 1 : modelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if modelArr.count == 0 {
            let noItemCell = tableView.dequeueReusableCell(withIdentifier: "no_item_cell", for: indexPath) as! NoItemTableViewCell
            return noItemCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "note_item_cell", for: indexPath) as! NoteItemTableViewCell
            let item = modelArr[indexPath.row]
            cell.renderCell(noteItemTBC: item)
            cell.statusBtn.tag = indexPath.row
            cell.statusBtn.addTarget(self, action: #selector(changeColorKnowledge(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if modelArr.count == 0 {
            return tableView.frame.height
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoReadDetailNote(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                DBManager.shared.deleteFromDb(object: self.modelArr[indexPath.row])
                self.refreshDataFromDB()
            }
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
    }
    
}

extension ViewController: AddNewNoteDelegate {
    func didInsertedNote() {
        refreshDataFromDB()
    }
}

extension ViewController: StatusKnowledgeDelegate {
    func didSelectedColor() {
        refreshDataFromDB()
    }
}

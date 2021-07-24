//
//  ChatlistViewController.swift
//  FeelWeather
//
//  Created by 김태욱 on 04/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var usernames = [String]()
    var useruids = [String]()
    var userfeelstatus = [String]()
    
    let db = Firestore.firestore()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userscell", for: indexPath) as! ChatlistTableViewCell
        
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("Users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.usernames.append(document.data()["username"] as! String)
                    self.useruids.append(document.data()["useruid"] as! String)
                    self.userfeelstatus.append(document.data()["feelstatus"] as! String)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ChatViewController.swift
//  FeelWeather
//
//  Created by 김태욱 on 04/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let db = Firestore.firestore()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chattext.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath) as! ChatTableViewCell
    
        //경우의수 알아서 잘 나눈다.... 하하하하하하하하ㅏ
        if(!(useruid[indexPath.row] == Auth.auth().currentUser?.uid)) {
            if(indexPath.row == 0){ cell.myText.isHidden = false}
            else { cell.myText.isHidden = true }
            
            let docRef = db.collection("Users").document(useruid[indexPath.row])
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    if(document.data()!["feelstatus"] as? String == "맑아요") {
                        cell.feelstatusImage.image = UIImage(named: "sun")
                    } else if(document.data()!["feelstatus"] as? String == "비와요") {
                        cell.feelstatusImage.image = UIImage(named: "rain")
                    } else if(document.data()!["feelstatus"] as? String == "눈와요") {
                        cell.feelstatusImage.image = UIImage(named: "snow")
                    } else if(document.data()!["feelstatus"] as? String == "안개가 껴요") {
                        cell.feelstatusImage.image = UIImage(named: "fog")
                    } else if(document.data()!["feelstatus"] as? String == "폭풍우가 쳐요") {
                        cell.feelstatusImage.image = UIImage(named: "storm")
                    } else if(document.data()!["feelstatus"] as? String == "번개가 쳐요") {
                        cell.feelstatusImage.image = UIImage(named: "thndr")
                    }
                    cell.chatText.text! = self.chattext[indexPath.row]
                    cell.userName.text! = (document.data()!["username"] as? String)!
                    print("Document data: \(dataDescription)")
                } else {
                }
            }
        } else {
            cell.feelstatusImage.isHidden = true
            cell.userName.isHidden = true
            cell.chatText.isHidden = true
            cell.myText.text! = self.chattext[indexPath.row]
        }
        return cell
    }
    
    var chattext = [String]()
    var feelstatus = [String]()
    var username = [String]()
    var useruid = [String]()
    
    var chatuseruid = ""
    var ischatexist = 0
    var isfirst = 0
    var issecond = 0
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
    
        // Do any additional setup after loading the view.
    }
    
    func getmessage() {
    
    }
    
    @objc
    func keyboardWillHideNotification(_ notification: NSNotification) {
        //print("keyboardWillHide")
        self.view.frame.origin.y = 0
    }
    
    @objc
    func keyboardWillShowNotification(_ notification: NSNotification) {
        //print("keyboardWillShow")
        self.view.frame.origin.y = -325
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

    @IBAction func send(_ sender: Any) {
    
     
    }
    
    func makenewdb () {
      
    }
    
    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

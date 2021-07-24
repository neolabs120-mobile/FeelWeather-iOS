//
//  CommentViewController.swift
//  FeelWeather
//
//  Created by 김태욱 on 02/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var feelstatus = [String]()
    var usernamestring = [String]()
    var comment = [String]()
    var useruids = [String]()
    var commentuids = [String]()
    
    var arrayfirst = [String]()
    var arraysecond = [String]()
    var arraythird = [String]()
    var arrayfourth = [String]()
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userIntroduce: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var commentText: UITextField!
    
    let db = Firestore.firestore()
    
    var useruid = ""
    
    @IBAction func SendComment(_ sender: Any) {
        //공백을 댓글로 입력할수 없다.
        if(commentText.text! == "") {
            return
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let result = formatter.string(from: date)
        
        var ref: DocumentReference? = nil
        ref = db.collection("Users").document(useruid).collection("Comments").addDocument(data: [
            "comment": commentText.text!,
            "time": result,
            "useruid": (Auth.auth().currentUser?.uid)!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.commentText.text! = ""
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayfirst.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath) as! CommentTableViewCell
        
        if(arrayfirst[indexPath.row] == "맑아요") {
            cell.feelStatus.image = UIImage(named: "sun")
        } else if(arrayfirst[indexPath.row] == "비와요") {
            cell.feelStatus.image = UIImage(named: "rain")
        } else if(arrayfirst[indexPath.row] == "눈와요") {
            cell.feelStatus.image = UIImage(named: "snow")
        } else if(arrayfirst[indexPath.row] == "안개가 껴요") {
            cell.feelStatus.image = UIImage(named: "fog")
        } else if(arrayfirst[indexPath.row] == "폭풍우가 쳐요") {
            cell.feelStatus.image = UIImage(named: "storm")
        } else if(arrayfirst[indexPath.row] == "번개가 쳐요") {
            cell.feelStatus.image = UIImage(named: "thndr")
        }
        cell.userName2.text = arraysecond[indexPath.row]
        cell.userComment.text = arrayfourth[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "삭제") { (action, indexPath) in
            // share item at indexPath
            print(self.arraythird[indexPath.row])
            if(Auth.auth().currentUser?.uid != self.arraythird[indexPath.row]) {
                let alertController = UIAlertController(title: "에러", message: "자신의 댓글이 아닌 댓글은 삭제할수 없습니다.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
            //삭제수행.
                self.db.collection("Users").document(self.useruid).collection("Comments").document(self.commentuids[indexPath.row]).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
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
    
        userprofile()
        
        getcomment1 { array1, array2, array3, array4, array5 in
            self.arrayfirst = array1
            self.arraysecond = array2
            self.arraythird = array3
            self.arrayfourth = array4
            self.commentuids = array5
            
            self.tableView.reloadData()
            
            print(self.arrayfirst)
        }
    }
    
    @objc
    func keyboardWillHideNotification(_ notification: NSNotification) {
        print("keyboardWillHide")
        self.view.frame.origin.y = 0
    }
    
    @objc
    func keyboardWillShowNotification(_ notification: NSNotification) {
        print("keyboardWillShow")
        self.view.frame.origin.y = -300
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func userprofile() {
        let docRef = db.collection("Users").document(useruid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if(document.data()!["feelstatus"] as! String == "맑아요") {
                    self.userImage.image = UIImage(named: "sun")
                } else if(document.data()!["feelstatus"] as! String == "비와요") {
                    self.userImage.image = UIImage(named: "rain")
                } else if(document.data()!["feelstatus"] as! String == "눈와요") {
                    self.userImage.image = UIImage(named: "snow")
                } else if(document.data()!["feelstatus"] as! String == "안개가 껴요") {
                    self.userImage.image = UIImage(named: "fog")
                } else if(document.data()!["feelstatus"] as! String == "폭풍우가 쳐요") {
                    self.userImage.image = UIImage(named: "storm")
                } else if(document.data()!["feelstatus"] as! String == "번개가 쳐요") {
                    self.userImage.image = UIImage(named: "thndr")
                }
                self.userName.text = (document.data()!["username"] as! String)
                self.userIntroduce.text = (document.data()!["whyfeel"] as! String)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getcomment1 (_ completion: @escaping ([String], [String], [String], [String], [String])  -> ()) {
        //Listen to document metadata.
        db.collection("Users").document(useruid).collection("Comments").order(by: "time", descending: false).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            self.feelstatus.removeAll()
            self.usernamestring.removeAll()
            self.useruids.removeAll()
            self.comment.removeAll()
            self.commentuids.removeAll()
            
            for document in documentSnapshot!.documents {
                let docRef2 = self.db.collection("Users").document(document.data()["useruid"] as! String)
                
                docRef2.getDocument { (document2, error) in
                    if let document2 = document2, document2.exists {
                        if(document2.data()!["feelstatus"] as! String == "맑아요") {
                            self.feelstatus.append("맑아요")
                        } else if(document2.data()!["feelstatus"] as! String == "비와요") {
                            self.feelstatus.append("비와요")
                        } else if(document2.data()!["feelstatus"] as! String == "눈와요") {
                            self.feelstatus.append("눈와요")
                        } else if(document2.data()!["feelstatus"] as! String == "안개가 껴요") {
                            self.feelstatus.append("안개가 껴요")
                        } else if(document2.data()!["feelstatus"] as! String == "폭풍우가 쳐요") {
                            self.feelstatus.append("폭풍우가 쳐요")
                        } else if(document2.data()!["feelstatus"] as! String == "번개가 쳐요") {
                            self.feelstatus.append("번개가 쳐요")
                        }
                        self.usernamestring.append((document2.data()!["username"] as! String))
                        self.useruids.append((document2.data()!["useruid"] as! String))
                        self.comment.append(document.data()["comment"] as! String)
                        self.commentuids.append(document.documentID)
                    } else {
                        print("Document does not exist")
                    }
                    completion(self.feelstatus, self.usernamestring, self.useruids, self.comment, self.commentuids)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainsender" {
            let viewController : MainViewController = segue.destination as! MainViewController
            viewController.delegate = self
        }
    }
}

extension CommentViewController : SendDataDelegate1{
    func sendData(data: String) {
        useruid = data
    }
}

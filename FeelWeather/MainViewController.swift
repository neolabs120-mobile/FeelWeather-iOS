//
//  MainViewController.swift
//  FeelWeather
//
//  Created by 김태욱 on 30/11/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let db = Firestore.firestore()

    var feelstatus = [String]()
    var usernamestring = [String]()
    var introduce = [String]()
    var useruid = [String]()
    
    var delegate: SendDataDelegate1?
    
    var userindex = 0
    
    //출처: https://zeddios.tistory.com/310 [ZeddiOS]
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feelstatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "maincell", for: indexPath) as! MainTableViewCell
        if(feelstatus[indexPath.row] == "맑아요") {
            cell.feelstatus.image = UIImage(named: "sun")
        } else if(feelstatus[indexPath.row] == "비와요") {
            cell.feelstatus.image = UIImage(named: "rain")
        } else if(feelstatus[indexPath.row] == "눈와요") {
            cell.feelstatus.image = UIImage(named: "snow")
        } else if(feelstatus[indexPath.row] == "안개가 껴요") {
            cell.feelstatus.image = UIImage(named: "fog")
        } else if(feelstatus[indexPath.row] == "폭풍우가 쳐요") {
            cell.feelstatus.image = UIImage(named: "storm")
        } else if(feelstatus[indexPath.row] == "번개가 쳐요") {
            cell.feelstatus.image = UIImage(named: "thndr")
        }
        cell.username.text = usernamestring[indexPath.row]
        cell.introduce.text = introduce[indexPath.row]
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let chat = UITableViewRowAction(style: .default, title: "채팅") { (action, indexPath) in
            // share item at indexPath
            /*let storyBoard = UIStoryboard(name:"Main", bundle: nil) //스토리보드 가져오기
            let vc = storyBoard.instantiateViewController(withIdentifier: "chatview") as! ChatViewController //캐스팅
            
            self.present(vc, animated: true, completion: nil) //storyboardid가 IS_B인 화면 화면 띄움*/
            
            self.userindex = indexPath.row
            self.performSegue(withIdentifier: "chatshow2", sender: self)
        }
        
        chat.backgroundColor = UIColor.orange
        
        return [chat]
    }*/
    
    func getuserlist() {
        db.collection("Users").document((Auth.auth().currentUser?.uid)!).collection("Friends").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if(document.data()["useruid"] as! String == Auth.auth().currentUser!.uid) {
                        continue
                    }
                    
                    self.db.collection("Users").document(document.data()["useruid"] as! String).getDocument { (document, error) in
                        if let document = document, document.exists {
                            //print("\(document.documentID) => \(document.data())")
                            self.feelstatus.append(document.data()!["feelstatus"] as! String)
                            self.usernamestring.append(document.data()!["username"] as! String)
                            self.introduce.append(document.data()!["whyfeel"] as! String)
                            self.useruid.append(document.data()!["useruid"] as! String)
                        } else {
                            print("Document does not exist")
                        }
                         self.tableView.reloadData()
                    }
                    /*print("\(document.documentID) => \(document.data())")
                    self.feelstatus.append(document.data()["feelstatus"] as! String)
                    self.usernamestring.append(document.data()["username"] as! String)
                    self.introduce.append(document.data()["whyfeel"] as! String)
                    self.useruid.append(document.data()["useruid"] as! String)*/
                }
            }
        }
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        getuserlist()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainsender" {
            let secondVC: CommentViewController = segue.destination as! CommentViewController
            let senderCell = sender as! MainTableViewCell
            let indexPath = tableView.indexPath(for: senderCell)
            secondVC.useruid = useruid[indexPath!.row]
        }
        if segue.identifier == "chatshow2"{
            let secondVC2: ChatViewController = segue.destination as! ChatViewController
            secondVC2.chatuseruid = useruid[userindex]
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

protocol SendDataDelegate1 {
    func sendData(data: String)
}


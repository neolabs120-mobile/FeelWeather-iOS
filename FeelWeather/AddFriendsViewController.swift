//
//  AddFriendsViewController.swift
//  FeelWeather
//
//  Created by 김태욱 on 08/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddFriendsViewController: UIViewController {

    let db = Firestore.firestore()
    var isfriend = false
    
    @IBOutlet weak var friendemail: UITextField!
    @IBAction func sendbutton(_ sender: Any) {
        print(friendemail.text!)
        if(friendemail.text! == "") {
            //????
        }
        else {
            db.collection("Users").whereField("useremail", isEqualTo: friendemail.text!).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.isfriend = true
                        print("\(document.documentID) => \(document.data())")
                        
                        //양쪽다 친구추가 해준다.... 한쪽이 이메일을 알려주면 그냥 양쪽다 추가되있기로 합의(?)한거일테니 (?) 그냥 추가해준다. 신청하고 수락하고 하는거 구현할려면 더 복잡해진다......
                        self.db.collection("Users").document((Auth.auth().currentUser?.uid)!).collection("Friends").document().setData([
                            "useruid": document.data()["useruid"] as! String
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        
                        self.db.collection("Users").document(document.data()["useruid"] as! String).collection("Friends").document().setData([
                            "useruid": (Auth.auth().currentUser?.uid)!
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    }
                    
                    if(self.isfriend) {
                        _ = self.navigationController?.popViewController(animated: true)
                    } else if(!self.isfriend) {
                        self.isfriend = false
                        let alertController = UIAlertController(title: "에러", message: "검색 결과가 없습니다.", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

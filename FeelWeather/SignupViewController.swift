//
//  SignupViewController.swift
//  FeelWeather
//
//  Created by 김태욱 on 01/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    var email = ""
    var password = ""
    var name = ""
    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    @IBAction func CancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Signup(_ sender: Any) {
        let db = Firestore.firestore()
        //회원가입 진행하고, DB에 사용자 추가.
        email = EmailText.text!
        password = PasswordText.text!
        name = NameText.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                let alertController = UIAlertController(title: "에러", message: "가입에 실패하였습니다.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            print(user.uid)
            
            // Add a second document with a generated ID.
            db.collection("Users").document(user.uid).setData([
                "feelstatus": "맑아요",
                "username": self.name,
                "useruid": user.uid,
                "whyfeel" : "",
                "useremail": self.EmailText.text!
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            self.dismiss(animated: true, completion: nil)
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
        self.view.frame.origin.y = -250
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //키보드 외 구간 터치시 키보드 내려감.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmailText.delegate = self
        NameText.delegate = self
        PasswordText.delegate = self
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        let notifier = NotificationCenter.default
        notifier.addObserver(self,
                             selector: #selector(keyboardWillShowNotification(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(keyboardWillHideNotification(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
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

//
//  ViewController.swift
//  FeelWeather
//
//  Created by 김태욱 on 29/11/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, UITextFieldDelegate {
    
    var email = ""
    var passwordstring = ""
    
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    
    @IBAction func login(_ sender: Any) {
        email = emailtext.text!
        passwordstring = passwordtext.text!
        
        if(email == "" || passwordstring == "") {
            let alertController = UIAlertController(title: "에러", message: "빈칸이 있습니다.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: passwordstring) { (user, error) in
            guard let user = user?.user else {
                let alertController = UIAlertController(title: "에러", message: "로그인에 실패하였습니다.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            print(user.email!)
            
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "mainview")
            let navi = UINavigationController(rootViewController: nextView)
            self.present(navi, animated: true, completion: nil)
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        let storyBoard = UIStoryboard(name:"Main", bundle: nil) //스토리보드 가져오기
        let vc = storyBoard.instantiateViewController(withIdentifier: "signup") as! SignupViewController //캐스팅
        
        self.present(vc, animated: true, completion: nil) //storyboardid가 IS_B인 화면 화면 띄움
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

    override func viewDidLoad() {
        super.viewDidLoad()

        emailtext.delegate = self
        passwordtext.delegate = self
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    //출처: https://zeddios.tistory.com/127 [ZeddiOS]
}


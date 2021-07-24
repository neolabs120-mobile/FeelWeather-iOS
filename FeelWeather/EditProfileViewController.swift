//
//  EditProfileViewController.swift
//  FeelWeather
//
//  Created by 김태욱 on 01/12/2018.
//  Copyright © 2018 anolabs. All rights reserved.
//

import UIKit
import Toaster
import Firebase
import FirebaseFirestore

class EditProfileViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var editintroduce: UITextField!
    
    @IBOutlet weak var thndr: UIImageView!
    @IBOutlet weak var storm: UIImageView!
    @IBOutlet weak var fog: UIImageView!
    @IBOutlet weak var snow: UIImageView!
    @IBOutlet weak var sun: UIImageView!
    @IBOutlet weak var rain: UIImageView!
    
    var introduce = ""
    
    @IBAction func savechange(_ sender: Any) {
        introduce = editintroduce.text!
        db.collection("Users").document((Auth.auth().currentUser?.uid)!).updateData([
            "whyfeel": introduce
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        performSegueToReturnBack()
    }
    
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
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

        sun.isUserInteractionEnabled = true
        let suntapGesture = UITapGestureRecognizer(target: self, action: #selector(sunbuttonTapped))
        sun.addGestureRecognizer(suntapGesture)
        
        rain.isUserInteractionEnabled = true
        let raintapGesture = UITapGestureRecognizer(target: self, action: #selector(rainbuttonTapped))
        rain.addGestureRecognizer(raintapGesture)
        
        snow.isUserInteractionEnabled = true
        let snowtapGesture = UITapGestureRecognizer(target: self, action: #selector(snowbuttonTapped))
        snow.addGestureRecognizer(snowtapGesture)
        
        storm.isUserInteractionEnabled = true
        let stormtapGesture = UITapGestureRecognizer(target: self, action: #selector(stormbuttonTapped))
        storm.addGestureRecognizer(stormtapGesture)
        
        fog.isUserInteractionEnabled = true
        let fogtapGesture = UITapGestureRecognizer(target: self, action: #selector(fogbuttonTapped))
        fog.addGestureRecognizer(fogtapGesture)
        
        thndr.isUserInteractionEnabled = true
        let thndrtapGesture = UITapGestureRecognizer(target: self, action: #selector(thndrbuttonTapped))
        thndr.addGestureRecognizer(thndrtapGesture)
        //출처: http://tom7930.tistory.com/15 [Dr.kim의 나를 위한 블로그]
        // Do any additional setup after loading the view.
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @objc func sunbuttonTapped(sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            print("터치 이벤트")
            db.collection("Users").document((Auth.auth().currentUser?.uid)!).updateData([
                "feelstatus": "맑아요"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    Toast(text: "업데이트 성공").show()
                }
            }
        }
    }
    
    @objc func rainbuttonTapped(sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            print("터치 이벤트")
            db.collection("Users").document((Auth.auth().currentUser?.uid)!).updateData([
                "feelstatus": "비와요"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    Toast(text: "업데이트 성공").show()
                }
            }
        }
    }
    
    @objc func snowbuttonTapped(sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            print("터치 이벤트")
            db.collection("Users").document((Auth.auth().currentUser?.uid)!).updateData([
                "feelstatus": "눈와요"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    Toast(text: "업데이트 성공").show()
                }
            }
        }
    }
    
    @objc func stormbuttonTapped(sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            print("터치 이벤트")
            db.collection("Users").document((Auth.auth().currentUser?.uid)!).updateData([
                "feelstatus": "폭풍우가 쳐요"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    Toast(text: "업데이트 성공").show()
                }
            }
        }
    }
    
    @objc func fogbuttonTapped(sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            print("터치 이벤트")
            db.collection("Users").document((Auth.auth().currentUser?.uid)!).updateData([
                "feelstatus": "안개가 껴요"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    Toast(text: "업데이트 성공").show()
                }
            }
        }
    }
    
    @objc func thndrbuttonTapped(sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            print("터치 이벤트")
            db.collection("Users").document((Auth.auth().currentUser?.uid)!).updateData([
                "feelstatus": "번개가 쳐요"
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    Toast(text: "업데이트 성공").show()
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

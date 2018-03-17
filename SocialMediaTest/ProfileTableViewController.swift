//
//  ProfileTableViewController.swift
//  SocialMediaTest
//
//  Created by 若林大悟 on 2018/03/15.
//  Copyright © 2018年 rakko entertainment. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseFirestore

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var signinButton: UIBarButtonItem!
    var authUI:FUIAuth?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            signinButton.title = "Sign out"
        } else {
            signinButton.title = "Sign in"
        }
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = []
        authUI?.providers = providers


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUser(firebaseUser: Auth.auth().currentUser)
        Auth.auth().addStateDidChangeListener { (auth, newUser) in
            self.setUser(firebaseUser: newUser)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signin(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                signinButton.title = "Sign in"
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        } else {
            let authViewController = authUI!.authViewController()
            present(authViewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func setUser(firebaseUser: FirebaseAuth.UserInfo?) {
        if let firebaseUser = firebaseUser {
            let user = User(user: firebaseUser)
            self.user = user
            Firestore.firestore()
                .collection("users")
                .document(user.userID)
                .setData(user.documentData) { error in
                    if let error = error {
                        print("Error writing user to Firestore: \(error)")
                    }
            }
        } else {
            user = nil
        }
    }
    
    fileprivate var user: User? = nil {
        didSet {
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileTableViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            
            
            signinButton.title = "Sign out"
        }
    }
}

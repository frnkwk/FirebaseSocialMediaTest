//
//  TimelineTableViewController.swift
//  SocialMediaTest
//
//  Created by 若林大悟 on 2018/03/15.
//  Copyright © 2018年 rakko entertainment. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TimelineTableViewController: UITableViewController {
    
    var posts:[QueryDocumentSnapshot]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let db = Firestore.firestore()
        db.collection("posts").order(by: "date", descending: true).addSnapshotListener { documentsSnapshot, error in
            guard let snapshot = documentsSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            self.posts = snapshot.documents
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func compose(_ sender: Any) {
        let alert = UIAlertController(title: "投稿", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let postAction = UIAlertAction(title: "投稿する", style: .default) { (_) in
            let text = alert.textFields![0].text
            let post = Post(text: text!)
            Firestore.firestore()
                .collection("posts")
                .document(post.postID)
                .setData(post.documentData) { error in
                    if let error = error {
                        print("Error writing user to Firestore: \(error)")
                    }
            }
            
        }
        alert.addAction(postAction)
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        let snapshot = posts![indexPath.row]
        cell.textLabel?.text = snapshot.data()["text"] as? String
        
        if let userID = snapshot.data()["userID"] as? String {
            let db = Firestore.firestore()
            db.collection("users").whereField("userID", isEqualTo: userID)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        cell.detailTextLabel?.text =  querySnapshot!.documents[0].data()["name"] as? String
                    }
            }
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postData = posts![indexPath.row].data()
        performSegue(withIdentifier: "post", sender: postData)
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "post" {
            let vc = segue.destination as! PostTableViewController
            vc.post = sender as! [String:Any]
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

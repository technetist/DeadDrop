//
//  UsersTableViewController.swift
//  Dead Drop
//
//  Created by Adrien Maranville on 7/20/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit
import Parse

class UsersTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var usernames = [String]()
    
    var recipientUsername = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBar.isHidden = false
        
        _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            print("Timer Activated")
        })
        
        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: (PFUser.current()?.username)!)
        
        do {
            let users = try query?.findObjects()
            if let users = users as? [PFUser] {
                for user in users {
                    self.usernames.append(user.username!)
                }
                tableView.reloadData()
            }
        } catch {
            print("Users not found")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            PFUser.logOut()
            
            self.navigationController?.navigationBar.isHidden = true
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = usernames[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipientUsername = usernames[indexPath.row]
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("image returned")
            let imageToSend = PFObject(className: "Image")
            imageToSend["photo"] = PFFile(name: "photo.png", data: UIImagePNGRepresentation(image)!)
            imageToSend["senderUsername"] = PFUser.current()?.username
            imageToSend["recipient"] = recipientUsername
            imageToSend.saveInBackground(block: { (success, error) in
                var title = "Sending Failed"
                var description = "Please try again later."
                
                if success {
                    title = "Message Sent"
                    description = "Your message has been sent."
                    
                }
                
                let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
}

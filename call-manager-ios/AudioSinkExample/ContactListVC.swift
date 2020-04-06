//
//  ContactListVC.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/19/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit


class ContactListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    let loggedin_username: String = UserDefaults.standard.string(forKey: "username") ?? "NULL"
    
    @IBOutlet weak var loggedin_username_label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
   
    @IBOutlet weak var contactListTable: UITableView!
    
    var contact_temp_name: String = ""
    var contact_temp_email: String = ""
    // a list of personal data
    var people_profile_lists = [PeopleProfile]()
    var current_people_profile_lists = [PeopleProfile]()

    var timer = Timer()
    var called = false
    //caller user_name
    var name = "alex17"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedin_username_label.text = "log in as \(loggedin_username )"
        
        setUpPeopleProfiles()
        setUpSearchBar()
        
//        SocketIOManager.socket.on("receive") { (caller_callee, ack) -> Void in
//            if let dict = caller_callee[0] as? [String: String] {
//                let caller = dict["caller"]
//                let callee = dict["callee"]
//                // if callee == myself, receive the call
//                if (callee == self.loggedin_username) {
//                    print("Someone is calling me! CALLER: ", caller ?? "None", ", CALLEE: ", callee ?? "None")
//                    // notification goes here
//                    self.showCallNoti(title: "Incoming call from \(caller ?? "NULL")", message: "")
//                }
//            }
//        }//SocketIOManager.socket.on
        
        self.ask_server()
    }

    func ask_server(){
        //checks with server every 3 s whether a incoming call is coming
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.askingServer), userInfo: nil, repeats: true)
    }
    @objc func askingServer(){
        print("hello")
        if (called == false){

            let requestURL = "http://167.172.255.230/logon/"
            var request = URLRequest(url: URL(string: requestURL)!)
            request.httpMethod = "POST"
            let t = try? JSONSerialization.data(withJSONObject: ["user": name])
            request.httpBody = t
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let _ = data, error == nil else {
                print("NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("HTTP STATUS: \(httpStatus.statusCode)")

                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String: Any]
                let status = json?["status"] as? String
                print(status as Any)
                if (status == "calling"){
                    self.called = true
                    DispatchQueue.main.async{
                           self.performSegue(withIdentifier: "calling", sender: self)
                        //Add notification UI Segue here
                        //self.showNotification(title: "in comming call", message: "hello")
                    }
                }
                print("incoming call")            }
            catch let error as NSError {
                print(error)

                }
            }
            task.resume()
            sleep(1)
        }

    }
    
  
    
    private func setUpPeopleProfiles() {

        // testing fake users, replace after setting up db
        if (loggedin_username != "alice") {
            people_profile_lists.append(PeopleProfile(name: "alice", email: "alice@umich.edu", image: "contact_1"))
        }
        if (loggedin_username != "bob") {
            people_profile_lists.append(PeopleProfile(name: "bob", email: "bob@gmail.com", image: "contact_2"))
        }
//        people_profile_lists.append(PeopleProfile(name: "A 17lb cat go", email: "notspicy@gmail.com", image: "contact_3"))
//        people_profile_lists.append(PeopleProfile(name: "Doggo's pet", email: "2ha@gmail.com", image: "contact_4"))
        
        current_people_profile_lists = people_profile_lists
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    // Table (Contact List)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return people_profile_lists.count
        return current_people_profile_lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell") as? ContactListTableViewCell else {
            return UITableViewCell()
        }
        cell.contact_name.text = current_people_profile_lists[indexPath.row].name
        cell.contact_email.text = current_people_profile_lists[indexPath.row].email
        cell.contact_img.image = UIImage(named: current_people_profile_lists[indexPath.row].image)
//        cell.contact_img.layer.masksToBounds = true
//        cell.contact_img.layer.cornerRadius = cell.contact_img.bounds.width / 2
        return cell
    }
    
    // execute on click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView.deselectRow(at: indexPath, animated: true)
        
        contact_temp_name = people_profile_lists[indexPath.row].name
        contact_temp_email = people_profile_lists[indexPath.row].email
        
        // performSegue(withIdentifier: "showContactProfile", sender: people_profile_lists[indexPath.row])
        performSegue(withIdentifier: "showContactProfile", sender: self)
    }
        
    // convey data between different vcs through segue, reference: https://learnappmaking.com/pass-data-between-view-controllers-swift-how-to/#forward-segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactProfile" {
            // let destinate_vc = segue.destination as? ContactProfileViewController // ViewController
            // destinate_vc?.contact_temp_name = contact_temp_name
            // destinate_vc.contact_profile = people_profile_lists[]
            if let destinate_vc = segue.destination as? ContactProfileViewController {
                destinate_vc.contact_profile = people_profile_lists[(contactListTable.indexPathForSelectedRow?.row)!]
            }
        }
    }
    
    
    // Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // if search bar is empty
        guard !searchText.isEmpty else {
            current_people_profile_lists = people_profile_lists
            contactListTable.reloadData()
            return}
        
        // search condition
        current_people_profile_lists = people_profile_lists.filter({ people_profile -> Bool in
            guard let text = searchBar.text else { return false }
            // ignored lower/uppercase difference
            return people_profile.name.lowercased().contains(text.lowercased())
        })
        
        // reload contact list
        contactListTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // search based on category, to be added
    }
    
}

class PeopleProfile {
    let name: String
    let email: String
    let image: String
    
    init(name: String, email: String, image: String) {
        self.name = name
        self.email = email
        self.image = image
    }
}


extension UIViewController {
    func showCallNoti(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // if ok, redirect to chatroom
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (_) -> Void in

            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: "ChatRoomVC") as? ChatRoomVC else {
                print("couldnt find ChatRoomVC")
                return
            }
            // destinationVC.modalTransitionStyle = .partialCurl
            self.present(destinationVC, animated: true, completion: nil)
        
        }
        alertController.addAction(acceptAction)
        let rejectAction = UIAlertAction(title: "Reject", style: .default, handler: nil)
        alertController.addAction(rejectAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showNotification(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            // self.performSegue(withIdentifier: "showTranscript", sender: self)
            self.performSegue(withIdentifier: "showTranscript", sender: self)
        }
        alertController.addAction(acceptAction)
        let rejectAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(rejectAction)
        present(alertController, animated: true, completion: nil)
    }
}

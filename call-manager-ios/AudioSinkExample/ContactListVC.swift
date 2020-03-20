//
//  ContactListVC.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/19/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

class ContactListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactListTable: UITableView!
    
    var contact_temp_name: String = ""
    var contact_temp_email: String = ""
    // a list of personal data
    var people_profile_lists = [PeopleProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPeopleProfiles()
    }
    
    private func setUpPeopleProfiles() {
        people_profile_lists.append(PeopleProfile(name: "Doggo", email: "doggo@umich.edu", image: "contact_1"))
        people_profile_lists.append(PeopleProfile(name: "Doggo's uncle", email: "whyitsacat@gmail.com", image: "contact_2"))
        people_profile_lists.append(PeopleProfile(name: "A 17lb cat", email: "notspicy@gmail.com", image: "contact_3"))
        people_profile_lists.append(PeopleProfile(name: "Doggo's pet", email: "2ha@gmail.com", image: "contact_4"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people_profile_lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell") as? ContactListTableViewCell else {
            return UITableViewCell()
        }
        cell.contact_name.text = people_profile_lists[indexPath.row].name
        cell.contact_email.text = people_profile_lists[indexPath.row].email
        cell.contact_img.image = UIImage(named: people_profile_lists[indexPath.row].image)
        return cell
    }
    
    // execute on click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // let destinationVC = ContactProfileController()
        
        print("!!!@@@@", people_profile_lists[indexPath.row].name)
        
        contact_temp_name = people_profile_lists[indexPath.row].name
        contact_temp_email = people_profile_lists[indexPath.row].email
        
        performSegue(withIdentifier: "showContactProfile", sender: people_profile_lists[indexPath.row])
    }
        
    // convey data between different vcs through segue, reference: https://learnappmaking.com/pass-data-between-view-controllers-swift-how-to/#forward-segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactProfile" {
            let destinate_vc = segue.destination as? ViewController
            destinate_vc?.temp_contact_name = contact_temp_name
        }
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




//
//  ContactListVC.swift
//  AudioSinkExample
//
//  Created by Duo Chen on 3/19/20.
//  Copyright © 2020 Twilio Inc. All rights reserved.
//

import UIKit

class ContactListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactListTable: UITableView!
    
    var contact_temp_name: String = ""
    var contact_temp_email: String = ""
    // a list of personal data
    var people_profile_lists = [PeopleProfile]()
    var current_people_profile_lists = [PeopleProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPeopleProfiles()
        setUpSearchBar()
    }
    
    private func setUpPeopleProfiles() {
        people_profile_lists.append(PeopleProfile(name: "Doggo", email: "doggo@umich.edu", image: "contact_1"))
        people_profile_lists.append(PeopleProfile(name: "doggo's uncle", email: "whyitsacat@gmail.com", image: "contact_2"))
        people_profile_lists.append(PeopleProfile(name: "A 17lb cat go", email: "notspicy@gmail.com", image: "contact_3"))
        people_profile_lists.append(PeopleProfile(name: "Doggo's pet", email: "2ha@gmail.com", image: "contact_4"))
        
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
        guard !searchText.isEmpty else { current_people_profile_lists = people_profile_lists; return}
        
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



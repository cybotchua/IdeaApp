//
//  ExploreViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 22/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 90
        }
    }
    
    var ideas : [Idea] = []
    var filteredIdeas : [Idea] = []
    
    var ref : DatabaseReference!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        observeOtherIdeas()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "Not Started", "In Progress", "Completed", "Incomplete"]
        searchController.searchBar.delegate = self

    }
    
    func filterIdeas(searchText: String, scope: String = "All") {
        filteredIdeas = ideas.filter({ (idea) -> Bool in
            let statusMatch = (scope == "All") || (idea.status.rawValue == scope)
            return statusMatch && idea.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func observeOtherIdeas() {
        if let uid = Auth.auth().currentUser?.uid {
            
            ref.child("users").observe(.value, with: { (snapshot) in
                if let userDict = snapshot.value as? [String : Any] {
                    for (k, _) in userDict {
                        if k != uid {
                            self.ref.child("users/\(k)/ideas").observe(.childAdded, with: { (snapshot) in
                                
                                guard let ideaDict = snapshot.value as? [String : Any] else {return}
                                let idea = Idea(ideaID: snapshot.key, dict: ideaDict)
                                
                                DispatchQueue.main.async {
                                    self.ideas.append(idea)
                                    let indexPath = IndexPath(row: self.ideas.count - 1, section: 0)
                                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                                    self.tableView.reloadData()
                                }
                                
                            })
                        }
                    }
                }
                
                
            })
            
            
        }
        
        
        
    }


}

extension ExploreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredIdeas.count
        }
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExploreTableViewCell else {return UITableViewCell()}
        
        let idea : Idea
        
        if searchController.isActive && searchController.searchBar.text != "" {
            idea = filteredIdeas[indexPath.row]
        } else {
            idea = ideas[indexPath.row]
        }
        
        cell.titleLabel.text = idea.title
        cell.statusLabel.text = idea.status.rawValue
        cell.dateLabel.text = idea.date
        cell.distanceLabel.text = idea.distance
        
        return cell
    }
    
}

extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "IdeaDetailViewController") as? IdeaDetailViewController else {return}
        
        let selectedIdea : Idea
        
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedIdea = filteredIdeas[indexPath.row]
        } else {
            selectedIdea = ideas[indexPath.row]
        }
        
        vc.selectedIdea = selectedIdea
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ExploreViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        guard let scopeButtonTitles = searchBar.scopeButtonTitles else {return}
        let scope = scopeButtonTitles[searchBar.selectedScopeButtonIndex]
        
        guard let searchText = searchController.searchBar.text else {return}
        filterIdeas(searchText: searchText, scope: scope)
    }
}

extension ExploreViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchText = searchBar.text,
            let scope = searchBar.scopeButtonTitles else {return}
        filterIdeas(searchText: searchText, scope: scope[selectedScope])
    }
}

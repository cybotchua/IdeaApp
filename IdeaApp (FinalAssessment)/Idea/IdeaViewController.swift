//
//  IdeaViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 22/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class IdeaViewController: UIViewController {
    
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }
    
//    @IBOutlet weak var searchBar: UISearchBar! {
//        didSet {
//            searchBar.delegate = self
//        }
//    }
    
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
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Ideas"
        
        observeIdeas()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "Not Started", "In Progress", "Completed", "Incomplete"]
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        ideas = []
//        observeIdeas()
        tableView.reloadData()
    }
    
    func filterIdeas(searchText: String, scope: String = "All") {
        filteredIdeas = ideas.filter({ (idea) -> Bool in
            let statusMatch = (scope == "All") || (idea.status.rawValue == scope)
            return statusMatch && idea.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func observeIdeas() {
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users/\(uid)/ideas").observe(.childAdded, with: { (snapshot) in
                
                guard let ideaDict = snapshot.value as? [String : Any] else {return}
                let idea = Idea(ideaID: snapshot.key, dict: ideaDict)
                
                DispatchQueue.main.async {
                    self.ideas.append(idea)
                    self.filteredIdeas.append(idea)
//                    let indexPath = IndexPath(row: self.ideas.count - 1, section: 0)
//                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.tableView.reloadData()
                }
                
            })
            
            ref.child("users/\(uid)/ideas").observe(.childChanged, with: { (snapshot) in
                guard let ideaDict = snapshot.value as? [String : Any] else {return}

                for (index, idea) in self.ideas.enumerated() {
                    if idea.ideaID == snapshot.key {

                        DispatchQueue.main.async {
                            let idea = Idea(ideaID: snapshot.key, dict: ideaDict)
                            self.ideas[index] = idea
//                            let indexPath = IndexPath(row: self.ideas.count - 1, section: 0)
//                            self.tableView.insertRows(at: [indexPath], with: .automatic)
                            self.tableView.reloadData()
                            return
                        }

                    }
                }

            })
            
        }
        
        
        
    }


}

extension IdeaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredIdeas.count
        }
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? IdeaTableViewCell else {return UITableViewCell()}
        
        let idea : Idea
        
        if searchController.isActive && searchController.searchBar.text != "" {
            idea = filteredIdeas[indexPath.row]
        } else {
            idea = ideas[indexPath.row]
        }
        
        cell.titleLabel.text = idea.title
        cell.statusLabel.text = idea.status.rawValue
        cell.dateLabel.text = idea.date
        
        return cell
    }
    
}

extension IdeaViewController: UITableViewDelegate {
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

extension IdeaViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        guard let scopeButtonTitles = searchBar.scopeButtonTitles else {return}
        let scope = scopeButtonTitles[searchBar.selectedScopeButtonIndex]
        
        guard let searchText = searchController.searchBar.text else {return}
        filterIdeas(searchText: searchText, scope: scope)
    }
}

extension IdeaViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchText = searchBar.text,
            let scope = searchBar.scopeButtonTitles else {return}
        filterIdeas(searchText: searchText, scope: scope[selectedScope])
    }
}

//extension IdeaViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard !searchText.isEmpty else {
//            filteredIdeas = ideas
//            tableView.reloadData()
//            return
//        }
//
//        filteredIdeas = ideas.filter({ (idea) -> Bool in
//            idea.title.lowercased().contains(searchText.lowercased())
//        })
//        self.tableView.reloadData()
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        guard let scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else {return}
//        
//        let selectedStatus = Idea.Status(rawValue: scopeString) ?? .notStarted
//        let searchText = searchBar.text ?? ""
//        
//        filteredIdeas = ideas.filter({ (idea) -> Bool in
//            let isStatusMatching = (idea.status == .notStarted) || (idea.status == selectedStatus)
//            
//            let isMatchingSearchText = idea.title.lowercased().contains(searchText.lowercased()) || searchText.lowercased().count == 0
//            
//            return isStatusMatching && isMatchingSearchText
//        })
//            self.tableView.reloadData()
//        
//    }
//}


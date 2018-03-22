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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 90
        }
    }
    
    var ideas : [Idea] = []
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = "Ideas"
        
        observeIdeas()
    }
    
    func observeIdeas() {
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("users/\(uid)/ideas").observe(.childAdded, with: { (snapshot) in
                
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

extension IdeaViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? IdeaTableViewCell else {return UITableViewCell()}
        
        cell.titleLabel.text = ideas[indexPath.row].title
        cell.statusLabel.text = ideas[indexPath.row].status
        cell.dateLabel.text = ideas[indexPath.row].date
        
        return cell
    }
    
}

extension IdeaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "IdeaDetailViewController") as? IdeaDetailViewController else {return}
        
        let selectedIdea = ideas[indexPath.row]
        
        vc.selectedIdea = selectedIdea
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

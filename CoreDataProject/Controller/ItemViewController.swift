//
//  ItemViewController.swift
//  CoreDataProject
//
//  Created by Dhruva Beti on 08/03/21.
//

import UIKit

class ItemViewController: UIViewController {
    
    @IBOutlet weak var itemTableview: UITableView!
    
    var itemArr = [1,2,3]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        itemTableview.dataSource = self
    }

    
    @IBAction func savePressed(_ sender: UIButton) {
    }
    
    
    @IBAction func updatePressed(_ sender: UIButton) {
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
    }
}

//Mark - TableView Delegate Methods
extension ItemViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = "Some"
        cell.detailTextLabel?.text = "Detail"
        return cell
        
    }
    
}


//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Dhruva Beti on 08/03/21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTableview: UITableView!
    var catArr = [1,2,3,4]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        categoryTableview.delegate = self
        categoryTableview.dataSource = self
    }

    
    @IBAction func savePressed(_ sender: UIButton) {
    }
    
    
    @IBAction func updatePressed(_ sender: UIButton) {
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
    }
}

//Mark - TableView Delegate Methods
extension CategoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        cell.textLabel?.text = "Some"
        cell.detailTextLabel?.text = "Detail"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toItemScreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemScreen" {
            let destinationVC = segue.destination as! ItemViewController
        }
    }
    
}


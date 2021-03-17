//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Dhruva Beti on 08/03/21.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTableview: UITableView!
    var catArr:[Category]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        categoryTableview.delegate = self
        categoryTableview.dataSource = self
        loadData()
    }

    
    @IBAction func savePressed(_ sender: UIButton) {
        let catObj = Category(context: context)
        catObj.name = "Vegatables"
        saveData()
        categoryTableview.reloadData()
    }
    
    
    @IBAction func updatePressed(_ sender: UIButton) {
        if let categoryArray = catArr {
            for catObj in categoryArray {
                catObj.name = "Fruits"
            }
            saveData()
            categoryTableview.reloadData()
        }
        
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        if let catObj = catArr?.first {
            context.delete(catObj)
            saveData()
            categoryTableview.reloadData()
        }
    }
    
    func saveData(){
        do {
            try context.save()
        } catch  {
            print("Error: \(error)")
        }
        loadData()
    }
    
    func loadData() {
        let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
        do {
            catArr = try context.fetch(fetchRequest)
        } catch {
            print("Error:\(error)")
        }
    }
}

//Mark - TableView Delegate Methods
extension CategoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        if let catObj = catArr?[indexPath.row] {
            cell.textLabel?.text = catObj.name
        }
       
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


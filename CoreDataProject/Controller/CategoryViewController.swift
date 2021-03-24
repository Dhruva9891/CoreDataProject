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
    
    @IBOutlet weak var catSearchBar: UISearchBar!
    
    var catArr:[Category]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    var previousID:Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        categoryTableview.delegate = self
        categoryTableview.dataSource = self
        catSearchBar.delegate = self
        loadData()
        
        let tapGestureReconizer = UITapGestureRecognizer.init(target: self, action: #selector(tap(sender:)))
        tapGestureReconizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureReconizer)
    }

    
    @IBAction func savePressed(_ sender: UIButton) {
        let catObj = Category(context: context)
        catObj.name = "Vegatables"
        catObj.id = generateID()
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
    
    func loadData(searchPredicate:NSPredicate? = nil) {
        let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
        if let predicat = searchPredicate {
            fetchRequest.predicate = predicat
        }
        do {
            catArr = try context.fetch(fetchRequest)
        } catch {
            print("Error:\(error)")
        }
    }
    
    func generateID() -> Int32 {
        
        if let categoryArr = catArr {
            if categoryArr.count > 0 {
                var idArr:[Int32] = []
                
                for catObj in categoryArr {
                    idArr.append(catObj.id)
                }
                if let id = idArr.max()  {
                    previousID = id
                }
            }
        }
        
        let uniqueID = previousID+1
        return uniqueID
        
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemScreen" {
            
            let destinationVC = segue.destination as! ItemViewController
            if let index = categoryTableview.indexPathForSelectedRow?.row, let catObj = catArr?[index] {
                destinationVC.selectedCategory = catObj

            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction.init(style: .destructive, title: "Delete") { (contextualAction, view, completionHandler) in
            
            if let catObj = self.catArr?[indexPath.row] {
                self.context.delete(catObj)
                self.saveData()
                self.categoryTableview.reloadData()
            }
        }
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage.init(named: "Trash Icon")
        
        let configuration = UISwipeActionsConfiguration.init(actions: [delete])
        return configuration
    }
    
}

//Mark - SearchBar Delegate Methods
extension CategoryViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadData()
            categoryTableview.reloadData()
            return
        }
        
        let predicate = NSPredicate.init(format: "name CONTAINS[c] %@", searchText)
        loadData(searchPredicate: predicate)
        categoryTableview.reloadData()
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}


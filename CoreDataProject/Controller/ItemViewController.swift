//
//  ItemViewController.swift
//  CoreDataProject
//
//  Created by Dhruva Beti on 08/03/21.
//

import UIKit
import CoreData

class ItemViewController: UIViewController {
    
    @IBOutlet weak var itemTableview: UITableView!
    
    @IBOutlet weak var itemSearchBar: UISearchBar!
    
    var itemArr:[Item]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        itemTableview.dataSource = self
        itemTableview.delegate = self
        itemSearchBar.delegate = self

        let tapGestureReconizer = UITapGestureRecognizer.init(target: self, action: #selector(tap(sender:)))
        tapGestureReconizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureReconizer)
    }

    
    @IBAction func savePressed(_ sender: UIButton) {
        if let catObj = selectedCategory {
            let itemObj = Item.init(context: context)
            itemObj.name = "Carrot"
            itemObj.done = false
            itemObj.parentCategory = catObj
            saveData()
            itemTableview.reloadData()
        }
    }
    
    
    @IBAction func updatePressed(_ sender: UIButton) {
        if let itemArray = itemArr {
            for itemObj in itemArray {
                itemObj.name = "Potato"
                itemObj.done = true
            }
            saveData()
            itemTableview.reloadData()
        }
        
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        
        if let itemObj = itemArr?.first{
            context.delete(itemObj)
            saveData()
            itemTableview.reloadData()
        }
    }
    
    func saveData() {
        do {
            try context.save()
        } catch  {
            print("Error:\(error)")
        }
        
        loadData()
    }
    
    func loadData(searchPredicate:NSPredicate? = nil) {
        let fetchRequest:NSFetchRequest<Item> = Item.fetchRequest()
        
        var predicateArr:[NSPredicate] = []
        
        if let predicat = searchPredicate {
            predicateArr.append(predicat)
        }
        
        if let catObjID = selectedCategory?.id {
            let relationPredicate = NSPredicate.init(format: "parentCategory.id == \(catObjID)")
            predicateArr.append(relationPredicate)

        }
        
        fetchRequest.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicateArr)
        
        do {
            itemArr = try context.fetch(fetchRequest)
        } catch  {
            print("Error:\(error)")
        }
        
    }
}

//Mark - TableView Delegate Methods
extension ItemViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if let itemObj = itemArr?[indexPath.row]{
            cell.textLabel?.text = itemObj.name
            cell.detailTextLabel?.text = String(itemObj.done)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            if let itemObj = self.itemArr?[indexPath.row]{
                self.context.delete(itemObj)
                self.saveData()
                self.itemTableview.reloadData()
            }
        }
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage.init(named: "Trash Icon")
        
        
        let configuration = UISwipeActionsConfiguration.init(actions: [delete])
        return configuration
        
    }
}

//Mark - SearchBar Delegate Methods
extension ItemViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadData()
            itemTableview.reloadData()
            return
        }
        
        let predicate = NSPredicate.init(format: "name CONTAINS[c] %@", searchText)
        loadData(searchPredicate: predicate)
        itemTableview.reloadData()
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

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
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        
//        context.delete(itemObj)
//        saveData()
//        itemTableview.reloadData()
    }
    
    func saveData() {
        do {
            try context.save()
        } catch  {
            print("Error:\(error)")
        }
        
        loadData()
    }
    
    func loadData() {
        let fetchRequest:NSFetchRequest<Item> = Item.fetchRequest()
        if let catObjID = selectedCategory?.id {
            fetchRequest.predicate = NSPredicate.init(format: "parentCategory.id == \(catObjID)")
        }
        
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
}


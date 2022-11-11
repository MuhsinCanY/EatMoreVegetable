//
//  ViewController.swift
//  EatMoreVegetable
//
//  Created by Muhsin Can Yılmaz on 18.10.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    
    

    @IBOutlet var tableView: UITableView!
    
    var foodItems = [Food]()
    var moc:NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        moc = appDelegate?.persistentContainer.viewContext
        self.tableView.dataSource = self
        
        loadData()
        
    }

    @IBAction func addFoodToDatabase(_ sender: UIButton) {
        
        let foodItem = Food(context: moc)
        
        foodItem.added = Date()
        
        if sender.tag == 0 {
            foodItem.foodType = "Fruit"
        }else {
            foodItem.foodType = "Vegetable"
        }
        
        appDelegate?.saveContext()
        
//        do {
//            try moc.save()
//        } catch  {
//            print("erroe")
//        }
        
        loadData()
    }
    
    func loadData(){
        
        let foodRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: false)
        foodRequest.sortDescriptors = [sortDescriptor]
        
        do {
            try foodItems = moc.fetch(foodRequest)
        } catch  {
            print("error")
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let foodItem = foodItems[indexPath.row]
        
        let foodType = foodItem.foodType
        cell.textLabel?.text = foodType
        
        let foodDate = foodItem.added!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMMM d yyyy, hh:mm a"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: foodDate)
        
        if foodType == "Fruit" {
            cell.imageView?.image = UIImage(named: "fruits")
        }else{
            cell.imageView?.image = UIImage(named: "vegetables")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}


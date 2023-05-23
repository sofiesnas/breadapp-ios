//
//  HomeViewController.swift
//  BreadApp
//
//  Created by Syafa Sofiena on 18/5/2023.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mealLogTable: UITableView!
    
    var selectedIndex: Int = 0
    var entries: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        APICalls().getMealLogs { (items) in
            self.entries = items
            self.mealLogTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "toEditMealEntry", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomMealsCell = tableView.dequeueReusableCell(withIdentifier: "mealEntryCell", for: indexPath) as! CustomMealsCell

        if let name = entries[indexPath.row].value(forKey: "name") as? String {
            cell.name.text = name
        }
        if let feeling = entries[indexPath.row].value(forKey: "feeling") as? String {
            cell.feeling.text = feeling
        }
        if let date = entries[indexPath.row].value(forKey: "date") as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: date)
            cell.date.text = dateString
        }
        if let imageData = entries[indexPath.row].value(forKey: "photo") as? Data {
            cell.icon.image = UIImage(data: imageData)
        }
        else {
            let defaultImage = UIImage(named: "bread")
            cell.icon.image = defaultImage
        }
        
        cell.icon.layer.cornerRadius = 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            if APICalls().deleteItem(objToDelete: entries[indexPath.row]) {
                entries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditMealEntry" {
            if let dest: AddFoodViewController = segue.destination as? AddFoodViewController {
                dest.editManagedObject = entries[selectedIndex]
            }
        }
    }
    
    
}


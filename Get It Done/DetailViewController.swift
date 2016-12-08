//
//  DetailViewController.swift
//  Get It Done
//
//  Created by Ty Victorson on 11/18/16.
//  Copyright © 2016 Xision. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var items = [Cell2]()
    var numItems = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clear
        
        let defaults = UserDefaults.standard
        // pulls data from disk
        if let savedPeople = defaults.object(forKey: "items") as? Data {
            items = NSKeyedUnarchiver.unarchiveObject(with: savedPeople) as! [Cell2]
            // converts data back to an object
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! SecondaryCellController
        //cell.backgroundColor = UIColor.green
        let ppl = items[indexPath.item]
        cell.myCellLabel.text = ppl.name
        return cell
    }
    
    // allows user to delete a row (FROM STACK OVERFLOW)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // saves the array to coredata
            save()
        }
    }
    
    @IBAction func CheckButton(_ sender: Any) {
        let button = (sender as AnyObject)
            button.setTitle("X", for: .normal)
        if (button.title == "X") {
            button.setTitle("O", for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.green
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        //let person = items[items.count]
        
        let ac = UIAlertController(title: "Add An Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            let name = Cell2(name: newName.text!)
            self.items.append(name)
            self.tableView.reloadData()
            self.save()
            
        })
        
        present(ac, animated: true)
    }
    
    func save() {
        // NSKeyedArchiver convert our array into a data object
        let savedData = NSKeyedArchiver.archivedData(withRootObject: items)
        
        let defaults = UserDefaults.standard
        
        defaults.set(savedData, forKey: "items")
    }
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    if (segue.identifier == "MainVC") {
            //let mvc = segue.destination as! UINavigationController
            //mvc.collectionView.cellForItem(at: IndexPath.init())?.accessibilityLabel = "\(numItems)"
    //    }
    //}
}

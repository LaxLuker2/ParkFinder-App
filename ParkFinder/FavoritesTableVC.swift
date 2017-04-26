//
//  FavoritesTableVC.swift
//  ParkFinder
//
//  Created by Luke Schwarting on 4/16/17.
//  Copyright © 2017 Luke Schwarting. All rights reserved.
//

import UIKit

class FavoritesTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        
        //check to see if the allFavorites.archive file exsits
        let fileName = "allFavorites.archive"
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: fileName)
        if FileManager.default.fileExists(atPath: pathToFile.path)
        {
            //if it does load it
            print("Opened = \(pathToFile)")
            ParkData.sharedData.favorites = NSKeyedUnarchiver.unarchiveObject(withFile: pathToFile.path) as! [StatePark]
        }
        else
        {
            // else load the deault hard-coded bookmark data
            print("Could not find \(pathToFile)")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //save when the app goes in background
        NotificationCenter.default.addObserver(self, selector: #selector(saveFavorites), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //favorites array length from StatePark
        return ParkData.sharedData.favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)

        cell.textLabel?.text = ParkData.sharedData.favorites[indexPath.row].title

        return cell
    }
    //reload the data to show the favorites array
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view. //enable deletion of list items
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ParkData.sharedData.favorites.remove(at: indexPath.row)
            
            //update the tableView
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let bookmarkToMove = ParkData.sharedData.favorites.remove(at: fromIndexPath.row)
        ParkData.sharedData.favorites.insert(bookmarkToMove, at: to.row)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            guard selectedRow < ParkData.sharedData.favorites.count else{
                print("row \(selectedRow) is not in parks!)")
                return
            }
            let detailVC = segue.destination as! ParkDetailTableVC
            detailVC.park = ParkData.sharedData.favorites[selectedRow]
        }
    }
    
    
    //MARK: - Helper -
    // save the favorites table class and save them to the disk
    func saveFavorites()
    {
        let pathToFile = FileManager.filePathInDocumentsDirectory(fileName: "allFavorites.archive")
        let success = NSKeyedArchiver.archiveRootObject(ParkData.sharedData.favorites, toFile: pathToFile.path)
        print("Saved = \(success) to \(pathToFile)")
    }

}

//
//  ParkDetailTableVC.swift
//  ParkFinder
//
//  Created by Luke Schwarting on 4/8/17.
//  Copyright © 2017 Luke Schwarting. All rights reserved.
//

import UIKit

class ParkDetailTableVC: UITableViewController {
    
    //MARK: - Ivars -
    var park:StatePark?
    let myNumSections = 5
    enum MySection: Int {
        case title = 0, description, favorite, viewOnMap, viewOnWeb
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = park?.title

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //sharing
    @IBAction func share(_ sender: AnyObject)
    {
        //snap shot
        let image = self.view.takeSnapshot()
        let textToShare = "Hey check out the \(title!) I just found!\nI was using the ParkFinder App, I ❤️ it!\nHere's their website:\n"
        let parkWebsite = NSURL(string: (park?.website)!)
        let objectsToShare:[AnyObject] = [textToShare as AnyObject, parkWebsite! as AnyObject, image!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.print]
        // These 3 commented out lines will help you on an iPad
        //let popoverMenuViewController = activityVC.popoverPresentationController
        //popoverMenuViewController?.permittedArrowDirections = .any
        //popoverMenuViewController?.barButtonItem = sender as? UIBarButtonItem
        self.present(activityVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return myNumSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plainCell", for: indexPath)
        
        switch indexPath.section
        {
            case MySection.title.rawValue:
                //set a bunch of properties for the first section
                cell.textLabel?.text = park?.title
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
                cell.textLabel?.numberOfLines = 1
                cell.textLabel?.textAlignment = .left
            
            case MySection.description.rawValue:
                cell.textLabel?.text = park?.Description
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.textAlignment = .left
            
            case MySection.favorite.rawValue:
                cell.textLabel?.text = "Favorite"
                cell.textLabel?.textColor = view.tintColor   // "hyperlink blue" by default
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
                cell.textLabel?.numberOfLines = 1
                cell.textLabel?.textAlignment = .center
            
            case MySection.viewOnMap.rawValue:
                cell.textLabel?.text = "View on Map"
                cell.textLabel?.textColor = view.tintColor   // "hyperlink blue" by default
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
                cell.textLabel?.numberOfLines = 1
                cell.textLabel?.textAlignment = .center
            
            case MySection.viewOnWeb.rawValue:
                cell.textLabel?.text = "View on Web"
                cell.textLabel?.textColor = view.tintColor   // "hyperlink blue" by default
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
                cell.textLabel?.numberOfLines = 1
                cell.textLabel?.textAlignment = .center
            
            default:
                cell.textLabel?.text = "TBD"
        }

        return cell
    }
    
    // MARK: - Add some height/padding to the rows -
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == MySection.title.rawValue
        {
            return 54.0
        }
        
        if indexPath.section == MySection.description.rawValue
        {
            return 180.0
        }
        
        return 44.0
    }
    
    //MARK: - Detect button tapped -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //favorites button tapped
        if indexPath.section == MySection.favorite.rawValue
        {
            //make sure that the park is only favorited once
            guard ParkData.sharedData.favorites.contains(park!) else{
                ParkData.sharedData.favorites.append(park!) //add park to favorites array
                print("added to favorites")
                return
            }
            
        }
        //view on map button tapped
        if indexPath.section == MySection.viewOnMap.rawValue
        {
            print("viewOnMap section tapped")
            let nc = NotificationCenter.default
            let data = ["park": park]
            //broadcast the notification
            nc.post(name: showParkNotification, object: self, userInfo: data)
        }
        //view on web tapped
        if indexPath.section == MySection.viewOnWeb.rawValue
        {
            print("viewOnWeb section tapped")
            if let url = URL(string: (park?.website)!){
                UIApplication.shared.open(
                    url,
                    options:[:],
                    completionHandler: {
                        (success) in
                        print("Open \(url.description) - success = \(success)")
                }
                )
            }
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

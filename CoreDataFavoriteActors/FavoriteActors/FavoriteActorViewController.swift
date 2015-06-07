//
//  FavoriteActorViewController.swift
//  FavoriteActors
//
//  Created by Jason on 1/31/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import CoreData

/**
 * Challenge 1: Convert Favorite Actors to Fetched Results View Controller.
 */

// Step 8: Add the NSFetchedResultsControllerDelegate protocol to the class declaration

class FavoriteActorViewController : UITableViewController, NSFetchedResultsControllerDelegate, ActorPickerViewControllerDelegate {
   
    // Step 4: Remove the actors array
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addActor")

        // This will be removed in step 5
        
        
        // Step 2: invoke fetchedResultsController.performFetch(nil) here
        fetchedResultsController.performFetch(nil)
        
        // Step 9: set the fetchedResultsController.delegate = self
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Core Data Convenience. This will be useful for fetching. And for adding and saving objects as well.
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    // Step 1 - Add the lazy fetchedResultsController property. See the reference sheet.
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
        }()
    
    // Step 5: Remove this method, and the invocation
    
    
    // Mark: - Actions
    
    func addActor() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ActorPickerViewController") as! ActorPickerViewController
        
        controller.delegate = self
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: - Actor Picker Delegate
    
    func actorPicker(actorPicker: ActorPickerViewController, didPickActor actor: Person?) {
        
        
        if let newActor = actor {
            
            // Debugging output
            println("picked actor with name: \(newActor.name),  id: \(newActor.id), profilePath: \(newActor.imagePath)")
            
            let dictionary: [String : AnyObject] = [
                Person.Keys.ID : newActor.id,
                Person.Keys.Name : newActor.name,
                Person.Keys.ProfilePath : newActor.imagePath ?? ""
            ]
            
            // Now we create a new Person, using the shared Context
            let actorToBeAdded = Person(dictionary: dictionary, context: sharedContext)

            // Step 3: Do not add actors to the actors array.
            // This is no longer necessary once we are modifying our table through the
            // fetched results controller delefate methods
            
            
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    // MARK: - Table View
    
    // Step 6: Replace the actors array in the table view methods. See the comments below
    
    // This one is particularly tricky. You will need to get the "section" object for section 0, then
    // get the number of objects in this section. See the reference sheet for an example.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let setionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return setionInfo.numberOfObjects
    }
    
    // This one is easy. Get the actor using the following statement:
    // 
    //        fetchedResultsController.objectAtIndexPath(:) as Person
    //
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier = "ActorCell"
        
        let actor = fetchedResultsController.objectAtIndexPath(indexPath) as! Person
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ActorTableViewCell
        
        // This is new.
        configureCell(cell, withActor: actor)
        
        return cell
    }
    
    // This one is also fairly easy. You can get the actor in the same way as cellForRowAtIndexPath above.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieListViewController") as! MovieListViewController
        
        let actor = fetchedResultsController.objectAtIndexPath(indexPath) as! Person
        
        controller.actor = actor
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    // This one is a little tricky. Instead of removing from the actors array you want to delete the actor from
    // Core Data. 
    // You can accomplish this in two steps. First get the actor object in the same way you did in the previous two methods. 
    // Then delete the actor using this invocation
    // 
    //        sharedContext.delete(actor)
    //
    // After that you do not need to delete the row from the table. That will be handled in the delegate. See reference sheet.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (editingStyle) {
        case .Delete:
            
            let actor = fetchedResultsController.objectAtIndexPath(indexPath) as! Person
            println(actor)
            sharedContext.deleteObject(actor)
            CoreDataStackManager.sharedInstance().saveContext()
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            break
        }
    }
    
    // MARK: - Configure Cell
    
    // This method is new. It contains the code that used to be in cellForRowAtIndexPath.
    // Refactoring it into its own method allow the logic to be reused in the fetch results
    // delegate methods
    
    func configureCell(cell: ActorTableViewCell, withActor actor: Person) {
        cell.nameLabel!.text = actor.name
        cell.frameImageView.image = UIImage(named: "personFrame")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if let localImage = actor.image {
            cell.actorImageView.image = localImage
        } else if actor.imagePath == nil || actor.imagePath == "" {
            cell.actorImageView.image = UIImage(named: "personNoImage")
        }
            
            // If the above cases don't work, then we should download the image
            
        else {
            
            // Set the placeholder
            cell.actorImageView.image = UIImage(named: "personPlaceholder")
            
            
            let size = TheMovieDB.sharedInstance().config.profileSizes[1]
            let task = TheMovieDB.sharedInstance().taskForImageWithSize(size, filePath: actor.imagePath!) { (imageData, error) -> Void in
                
                if let data = imageData {
                    dispatch_async(dispatch_get_main_queue()) {
                        let image = UIImage(data: data)
                        actor.image = image
                        cell.actorImageView.image = image
                    }
                }
            }
            
            cell.taskToCancelifCellIsReused = task
        }
    }
    
    // Step 7: You can implmement the delegate methods here. Or maybe above the table methods. Anywhere is fine.
    
    // MARK: - Saving the array
    
    var actorArrayURL: NSURL {
        let filename = "favoriteActorsArray"
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        
        return documentsDirectoryURL.URLByAppendingPathComponent(filename)
    }
}
































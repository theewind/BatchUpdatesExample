//
//  ViewController.swift
//  BatchUpdatesExample
//
//  Created by LiYunFeng on 14-11-16.
//  Copyright (c) 2014年 sogou. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var mainMoc: NSManagedObjectContext?
    let batch = true    //效果很明显
    let name = "Michela"
    
    func updateData() {
        var fetchRequest = NSFetchRequest()
        var entityName = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.mainMoc!)
        fetchRequest.entity = entityName
        
        var error: NSError?
        var fetchedObjects = self.mainMoc!.executeFetchRequest(fetchRequest, error: &error)
        
        if let persons = fetchedObjects {
            if error == nil {
                for person in persons {
                    (person as Person).name = self.name
                }
                
                if !self.mainMoc!.save(&error) {
                    NSLog("Unresloved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if batch {
            var batchRequest = NSBatchUpdateRequest(entityName: "Person")
            batchRequest.propertiesToUpdate = ["name": self.name]
            batchRequest.resultType = NSBatchUpdateRequestResultType.UpdatedObjectsCountResultType
            var error: NSError?
            var results = self.mainMoc!.executeRequest(batchRequest, error: &error) as NSBatchUpdateResult
            NSLog("Updated objects: \(results.result)")
        } else {
            self.updateData()
        }
        
        NSLog("Done.")
    }
}


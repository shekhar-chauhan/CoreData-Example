//
//  DataController.swift
//  CoreData Example
//
//  Created by Shekhar Chauhan on 4/17/24.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FoodModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved!!! whoohoo!!!")
        } catch {
            print("We could not save the data...")
        }
    }
    
    func addWaterDetails(waterConsumed: Double, dateConsumed: Date, context: NSManagedObjectContext) {
        let waterDetails = WaterEntity(context: context)
        waterDetails.waterConsumed = waterConsumed
        waterDetails.date = dateConsumed
        
        save(context: context)
    }
    
    func editWaterDetails(water: WaterEntity, waterConsumed: Double, dateConsumed: Date, context: NSManagedObjectContext) {
        water.waterConsumed = waterConsumed
        
        save(context: context)
    }
}

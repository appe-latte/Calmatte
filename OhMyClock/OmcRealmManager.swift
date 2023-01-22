//
//  OmcRealmManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-22.
//

import Foundation
import RealmSwift

class OmcRealmManager : ObservableObject {
    private(set) var localRealm : Realm?
    @Published private(set) var milestones: [Milestone] = []
    
    init() {
        openRealm()
        getMilestone()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    // MARK: "Create" function
    
    func addMilestone(milestoneTitle: String) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newMilestone = Milestone(value: ["title": milestoneTitle, "completed": false])
                    localRealm.add(newMilestone)
                    getMilestone()
                    
                    print("New milestone added!: \(newMilestone)")
                }
            } catch {
                print("Error creating milestoone: \(error)")
            }
        }
    }
    
    // MARK: "Read" function
    
    func getMilestone() {
        if let localRealm = localRealm {
            let allMilestones = localRealm.objects(Milestone.self).sorted(byKeyPath: "completed")
            
            milestones = []
            allMilestones.forEach { milestone in
                milestones.append(milestone)
            }
        }
    }
    
    // MARK: "Update" function
    
    func updateMilestone(id: ObjectId, completed: Bool) {
        if let localRealm = localRealm {
            do {
                let milestoneToUpdate = localRealm.objects(Milestone.self).filter(NSPredicate(format: "id == %@", id))
                guard !milestoneToUpdate.isEmpty else { return }
                
                try localRealm.write {
                    milestoneToUpdate[0].completed = completed
                    getMilestone()
                    
                    print("Milestone successfully updated: \(id), status: \(completed)")
                }
            } catch {
                print("Error updating Milestone \(id), error: \(error)")
            }
        }
    }
    
    // MARK: "Delete" function
    
    func deleteMilestone(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let milestoneToDelete = localRealm.objects(Milestone.self).filter(NSPredicate(format: "id == %@", id))
                guard !milestoneToDelete.isEmpty else { return }
                
                try localRealm.write {
                    localRealm.delete(milestoneToDelete)
                    getMilestone()
                    
                    print("Deleted milestone: \(id)")
                }
            } catch {
                print("Error deleting milestone \(error)")
            }
        }
    }
}

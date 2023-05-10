//
//  OmcRealmManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-22.
//

import SwiftUI
import RealmSwift

class OmcRealmManager : ObservableObject {
    private var realm: Realm!
    @Published private(set) var milestones: [Milestone] = []
    
    init() {
        openRealm()
        retrieveMilestones()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addMilestone(title: String) {
        do {
            try realm.write {
                let newMilestone = Milestone(value: ["title": title, "completed": false])
                realm.add(newMilestone)
                retrieveMilestones()
                print("New milestone added: \(newMilestone)")
            }
        } catch {
            print("Error adding milestone: \(error)")
        }
    }
    
    func retrieveMilestones() {
        let allMilestones = realm.objects(Milestone.self).sorted(byKeyPath: "completed")
        milestones = Array(allMilestones)
    }
    
    func editMilestone(id: ObjectId, title: String) {
        do {
            let milestoneToUpdate = realm.objects(Milestone.self).filter(NSPredicate(format: "id == %@", id))
            guard !milestoneToUpdate.isEmpty else { return }
            
            try realm.write {
                milestoneToUpdate[0].title = title
                retrieveMilestones()
                print("Milestone updated successfully: \(id), title: \(title)")
            }
        } catch {
            print("Error updating milestone: \(error)")
        }
    }
    
    func updateMilestone(id: ObjectId, completed: Bool) {
        do {
            let milestoneToUpdate = realm.objects(Milestone.self).filter(NSPredicate(format: "id == %@", id))
            guard !milestoneToUpdate.isEmpty else { return }
            
            try realm.write {
                milestoneToUpdate[0].completed = completed
                retrieveMilestones()
                print("Milestone updated successfully: \(id), status: \(completed)")
            }
        } catch {
            print("Error updating milestone: \(error)")
        }
    }
    
    func deleteMilestone(id: ObjectId) {
        guard let milestone = realm.object(ofType: Milestone.self, forPrimaryKey: id) else { return }
        try! realm.write {
            let milestoneToDelete = realm.object(ofType: Milestone.self, forPrimaryKey: id)
            if milestoneToDelete != nil {
                realm.delete(milestoneToDelete!)
                if let index = milestones.firstIndex(of: milestone) {
                    milestones.remove(at: index)
                }
            }
        }
    }
}

//
//  Database.swift
//  Roommate
//
//  Created by Andrew Huang on 3/19/24.
//

import Foundation
import SwiftUI

final class Database: ObservableObject{
    @Published var db: [UUID : User] = [:]
    @Published private var currentUser: User = User()
    
    static let shared = Database()
    ///create a filemanager to read the json of the information
    static let fileManager = FileManager.default
    static let sandboxPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("myDatabase.json")
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    func add(_ user: User) -> Bool{
        if db[user.id] != nil{
            return false
        }
        else{
            db[user.id] = user
            return true
        }
    }
    func update( _ user: User) -> Bool{
        if db[user.id] != nil{
            db[user.id] = user
            return true
        }
        else{
            db[user.id] = user
            return false
        }
    }
    func find(_ id: UUID)-> User?{
        return db[id];
    }
    
    ///save data model
    func save()-> Bool{
        let values: [User] = Array(db.values)
        do{
            let data = try encoder.encode(values)
            try data.write(to: Database.sandboxPath)
            return true
        }catch{
            print("error saving")
            return false
        }
    }
    
    ///only need replace because since no deletion, no instance of server having fewer entries than local
    func replaceDB(users: [User]) -> Bool {
        for user in users{
            let _ = self.update(user)
        }
        let res = self.save()
        return res
    }
    
    func setCurrentUser(_ user: User){
        currentUser = user
    }
    
    func getCurrentUser()-> User{
        return currentUser
    }
    
    func bindingForCurrentUser() -> Binding<User> {
        Binding<User>(
            get: { self.currentUser },
            set: { self.currentUser = $0 }
        )
    }
    
    func bindingForUser(_ id: UUID) -> Binding<User> {
        Binding<User>(
            get: { self.db[id]! },
            set: { self.db[id]! = $0 }
        )
    }
    func list() -> [User]{
            return Array(db.values)
        }
    func filter()-> [User]{
        ///need to get rid of all users with wrong hard info
        var  order: [Float: [User]] = [:]
        
        for profile in self.db.values{
            var failedHardFilter: Bool = false
            var similarity: Float = 0.0
            ///cannot be your own profile
            if currentUser.id == profile.id {
                failedHardFilter = true
            }
            ///calculate similarity value from each field
            ///gender preference
            if self.currentUser.preference.gender != profile.gender{
                failedHardFilter = true
            }
            ///school preference
            if self.currentUser.preference.sameSchool &&  self.currentUser.school != profile.school{
                failedHardFilter = true
            }
            ///age must be right range
            if profile.age < self.currentUser.preference.ageRange.min || profile.age > self.currentUser.preference.ageRange.max{
                failedHardFilter = true
            }
            
            
            //
            print("\(profile.fName), and \(failedHardFilter)" )
            
            if !failedHardFilter{
                if order[similarity] == nil{
                    order[similarity] = [profile]
                }
                else{
                    order[similarity]!.append(profile)
                }
            }
                
           
        }
        
        
        
        
        let  sortedOrder = order.sorted{$0.key > $1.key}
        var result: [User] = []
        for (key, value) in sortedOrder{
            result.append(contentsOf: value)
        }
        
        return result
    }

    
}

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
            ///HARD FILTERS
            ///gender preference
            if self.currentUser.preference.gender == profile.gender{
                similarity += 10

            }
            ///school preference
            if self.currentUser.preference.sameSchool &&  self.currentUser.school == profile.school{
                similarity += 8

            }
            ///age must be right range
            if profile.age >= self.currentUser.preference.ageRange.min && profile.age <= self.currentUser.preference.ageRange.max{
                similarity += 9

            }
            
            //same major
            if self.currentUser.preference.sameMajor &&  self.currentUser.major == profile.major{
                similarity += 8
            }
            if self.currentUser.friends.contains(profile.id){
                failedHardFilter = true
            }
            if self.currentUser.applyList.contains(profile.id){
                failedHardFilter = true
            }
             
            //SOFT FILTER
            /*
             Weights: 
             
             purpose: 2
             school:
             gradyear: 1
             sleepschedule:2
             major: 1
             budget: 9
             issmoke: 3
             havepets: 1
             selfintro: ???
             haveRoom: 1
             location: 9
             Interests: 
             */
            if self.currentUser.purpose == profile.purpose{
                similarity += 2
            }
            if self.currentUser.gradYear == profile.gradYear{
                similarity += 1
            }
            //FIX SLEEP SCHEDULE
            ///two early birds
            if self.currentUser.sleepSchedule.max  < 20  && profile.sleepSchedule.max < 20 {
                similarity += 3
            }
            //two night owl
            if self.currentUser.sleepSchedule.max  >= 20  && profile.sleepSchedule.max >= 20 {
                similarity += 5
            }
            if self.currentUser.isSmoke == profile.isSmoke {
                similarity += 3
            }
            
            if self.currentUser.havePets == profile.havePets {
                similarity += 2
            }
            if self.currentUser.haveRoom != profile.haveRoom {
                similarity += 4
            }
            
            if self.currentUser.seen.contains(profile.id){
                similarity -= 14
            }
            
            //get union of interests
            let userInterests = Set(self.currentUser.interests)
            let profileInterests = Set(profile.interests)
            
            let unionInterests = userInterests.union(profileInterests)
            let unionInterestsArray = Array(unionInterests)
            
            similarity += Float(unionInterestsArray.count) * 3.0
            
            ///FIGURE OUT LOCATION
            
            
            
            
            
            
            
            //
            print("\(profile.fName), and \(similarity) , and \(failedHardFilter)")
            
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
        for (score, users) in sortedOrder{
            for user in users{
                print("\(score), \(user.fName)")
            }
            result.append(contentsOf: users)
        }
        
        return result
    }

    
}

//
//  LocalStorageServiceImpl.swift
//  Dobby
//
//  Created by yongmin lee on 1/9/23.
//

import Foundation
import CoreData
import FirebaseCrashlytics

class LocalStorageServiceImpl {
    
    // MARK: properties
    static let shared = LocalStorageServiceImpl()
    
    // MARK: Core Data stack
    private lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CoreDataCloud")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                Crashlytics.crashlytics().record(error: error)
                fatalError("Unresolved error 1 \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    // MARK: initialize
    private init() {}

    // MARK: Core Data methods
    func saveContext () {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            Crashlytics.crashlytics().record(error: error)
            return []
        }
    }
    
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }
    
    // MARK: Handling SettingInfo
    @discardableResult
    func saveSettingInfo(_ settingInfo: SettingInfoDTO) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "SettingInfo", in: self.context)
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            managedObject.setValue(settingInfo.alarmOnOff, forKey: LocalKey.alarmOnOff.rawValue)
            managedObject.setValue(settingInfo.alarmTime, forKey: LocalKey.alarmTime.rawValue)
            managedObject.setValue(settingInfo.userInfo, forKey: LocalKey.userInfo.rawValue)
            managedObject.setValue(
                settingInfo.accessToken,
                forKey: LocalKey.accessToken.rawValue
            )
            managedObject.setValue(
                settingInfo.refreshToken,
                forKey: LocalKey.refreshToken.rawValue
            )
            do {
                try self.context.save()
                return true
            } catch {
                Crashlytics.crashlytics().record(error: error)
                return false
            }
        }
        return false
    }
    
    func fetchSettingInfo() -> SettingInfoDTO? {
        let request: NSFetchRequest<SettingInfo> = SettingInfo.fetchRequest()
        if let fetchResult = self.fetch(request: request).last {
            return SettingInfoDTO(
                accessToken: fetchResult.accessToken,
                refreshToken: fetchResult.refreshToken,
                alarmOnOff: fetchResult.alarmOnOff,
                alarmTime: fetchResult.alarmTime,
                userInfo: fetchResult.userInfo
            )
        }
        return nil
    }
}

//
//  LocalStorageServiceImpl.swift
//  Dobby
//
//  Created by yongmin lee on 1/9/23.
//

import Foundation
import CoreData

class LocalStorageServiceImpl {
    
    // MARK: properties
    static let shared = LocalStorageServiceImpl()
    
    // MARK: Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DobbyCoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("loadPersistentStores error \(error), \(error.userInfo)")
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
                BeaverLog.error("saveContext error  \(error)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            BeaverLog.error("fetch error  \(error)")
            return []
        }
    }
    
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            BeaverLog.error("deleteAll error  \(error)")
            return false
        }
    }
    
    // MARK: Handling SettingInfo
    @discardableResult
    func saveSettingInfo(_ settingInfo: SettingInfoDTO) -> Bool {
        let entity = NSEntityDescription.entity(
            forEntityName: "Settings",
            in: self.context
        )
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
            managedObject.setValue(
                settingInfo.lastUpdateAt,
                forKey: LocalKey.lastUpdateAt.rawValue
            )
            do {
                try self.context.save()
                return true
            } catch {
                BeaverLog.error("saveSettingInfo error  \(error)")
                return false
            }
        }
        return false
    }
    
    func fetchSettingInfo() -> SettingInfoDTO? {
        let request: NSFetchRequest<Settings> = Settings.fetchRequest()
        if let fetchResult = self.fetch(request: request).last {
            return SettingInfoDTO(
                accessToken: fetchResult.accessToken,
                refreshToken: fetchResult.refreshToken,
                alarmOnOff: fetchResult.alarmOnOff,
                alarmTime: fetchResult.alarmTime,
                userInfo: fetchResult.userInfo,
                lastUpdateAt: fetchResult.lastUpdateAt
            )
        }
        return nil
    }
}

extension LocalStorageServiceImpl: LocalStorageService {
    func read(key: LocalKey) -> String? {
        guard let settingInfo = self.fetchSettingInfo() else {return nil}
        switch key {
        case .accessToken:
            return settingInfo.accessToken
        case .refreshToken:
            return settingInfo.refreshToken
        case .alarmOnOff:
            return  settingInfo.alarmOnOff
        case .alarmTime:
            return settingInfo.alarmTime
        case .lastUpdateAt:
            return settingInfo.lastUpdateAt
        default:
            return nil
        }
    }
    
    func write(key: LocalKey, value: String) {
        let currentInfo = self.fetchSettingInfo()
        let newSettingInfo = SettingInfoDTO(
            accessToken: key == .accessToken ? value : currentInfo?.accessToken,
            refreshToken: key == .refreshToken ? value : currentInfo?.refreshToken,
            alarmOnOff: key == .alarmOnOff ? value : currentInfo?.alarmOnOff,
            alarmTime: key == .alarmTime ? value : currentInfo?.alarmTime,
            userInfo: currentInfo?.userInfo,
            lastUpdateAt: Date().toStringWithFormat("yyyy-MM-dd HH:mm:ss")
        )
        let request = Settings.fetchRequest()
        if self.deleteAll(request: request) {
            self.saveSettingInfo(newSettingInfo)
        }
    }
    
    func delete(key: LocalKey) {
        guard let currentInfo = self.fetchSettingInfo() else {return}
        let updateSettingInfo = SettingInfoDTO(
            accessToken: key == .accessToken ? "" : currentInfo.accessToken,
            refreshToken: key == .refreshToken ? "" : currentInfo.refreshToken,
            alarmOnOff: key == .alarmOnOff ? "" : currentInfo.alarmOnOff,
            alarmTime: key == .alarmTime ? "" : currentInfo.alarmTime,
            userInfo: key == .userInfo ? nil : currentInfo.userInfo,
            lastUpdateAt: Date().toStringWithFormat("yyyy-MM-dd HH:mm:ss")
        )
        let request = Settings.fetchRequest()
        if self.deleteAll(request: request) {
            self.saveSettingInfo(updateSettingInfo)
        }
    }
    
    func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        guard let currentInfo = self.fetchSettingInfo(),
              let encodedUser = try? encoder.encode(user)
        else {return}
        
        let updateSettingInfo = SettingInfoDTO(
            accessToken: currentInfo.accessToken,
            refreshToken: currentInfo.refreshToken,
            alarmOnOff: currentInfo.alarmOnOff,
            alarmTime: currentInfo.alarmTime,
            userInfo: encodedUser,
            lastUpdateAt: Date().toStringWithFormat("yyyy-MM-dd HH:mm:ss")
        )
        let request = Settings.fetchRequest()
        if self.deleteAll(request: request) {
            self.saveSettingInfo(updateSettingInfo)
        }
    }
    
    func getUser() -> User? {
        guard let currentInfo = self.fetchSettingInfo() else {return nil}
        if let data = currentInfo.userInfo {
            let decoder = JSONDecoder()
            let savedUser = try? decoder.decode(User.self, from: data)
            return savedUser
        }
        return nil
    }
    
    func clear() {
        let request = Settings.fetchRequest()
        self.deleteAll(request: request)
    }
}

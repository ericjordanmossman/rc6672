import SwiftUI
import RealmSwift

struct ContentView: View {
    let db = RealmService()
    var localPath: URL

    
    var body: some View {
        Group {
//            Button("Seed Local Realm", action: db.seedLocalRealm)
            Button("Print Local Realm Results") {
                print(self.db.openLocalRealm(path: self.localPath).objects(LocalClass.self))
            }
            Button("Print Local Object by Primary Key") {
                // Hardcoded primary key "1" should exist in Resources/bundled.realm.
                // See the commented method `seedLocalRealm` for how bundled.realm was created.
                guard let object = self.db.openLocalRealm(path: self.localPath).object(ofType: LocalClass.self, forPrimaryKey: "1") else {
                    print("Object not found")
                    return
                }
                print(object)
            }
            
            Button("Login in Anonymous user", action: db.loginAnonymousUser)
            Button("Logout user", action: db.logout)
            Button("Add synced objects", action: db.addSyncedObject)
            Button("Print Synced Realm Results") {
                guard let realm = self.db.openSyncedRealm() else {
                    return
                }
                print(realm.objects(SyncedClass.self))
            }
        }
    }
}

// This RealmService class just made it easier to try some tests and investigate.
// It shouldn't be considered an example to imitate in a production application.
class RealmService {
    static let app = RealmApp(id: Constants.REALM_APP_ID)
    
    func openLocalRealm(path: URL?) -> Realm {
        var config = Realm.Configuration()
        config.fileURL = path ?? config.fileURL
        config.readOnly = false
        return try! Realm(configuration: config)
    }
    
    func openSyncedRealm() -> Realm? {
        guard let user = RealmService.app.currentUser() else {
            print("Could not open realm. There is no authenticated user")
            return nil
        }
        var config = user.configuration(partitionValue: user.identity!)
        config.objectTypes = [SyncedClass.self]
        return try! Realm(configuration: config)
    }
    
    func addSyncedObject() {
        guard let realm = openSyncedRealm() else { return }
        
        try! realm.write({
            realm.create(SyncedClass.self, value: ["partition": realm.configuration.syncConfiguration?.partitionValue.stringValue])
        })
    }
    
    func loginAnonymousUser() {
        guard RealmService.app.currentUser() == nil else {
            print("Already Authenticated: \(String(describing: RealmService.app.currentUser()?.identity))")
            return
        }
        
        RealmService.app.login(withCredential: AppCredentials.anonymous()) { completionUser, error in
            guard error == nil else {
                print("Error \(String(describing: error))")
                return
            }
            
            guard let user = completionUser else {
                fatalError("No error or user returned")
            }
            print("Authenticated user: \(String(describing: user.identity))")
        }
    }
    func logout() {
        RealmService.app.logOut { error in
            guard error != nil else {
                return
            }
            print(error as Any)
        }
    }

// The primary keys are single digit integers just to make retrieving by primary key easier for testing.
//        func seedLocalRealm() {
//            var config = Realm.Configuration()
//            config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("bundled.realm")
//            config.readOnly = false
//            let realm = try! Realm(configuration: config)
//
//            // Delete all previous objects primary keys are not repeated
//            try! realm.write({
//                realm.deleteAll()
//            })
//
//            // Seed 3 "Grades"
//            var i = 0
//            try! realm.write({
//                while i < 3 {
//                    realm.create(LocalClass.self, value: ["_id": String(i), "name": UUID().uuidString])
//                    i += 1
//                }
//            })
//        }
}

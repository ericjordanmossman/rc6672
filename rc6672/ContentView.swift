import SwiftUI
import RealmSwift

struct ContentView: View {
    static let app = RealmApp(id: Constants.REALM_APP_ID)
    
    var body: some View {
        Group {
//            Button("Seed Local Realm", action: seedLocalRealm)
            Button("Print Local Realm Results") {
                print(openBundledRealm().objects(LocalClass.self))
            }
            Button("Print Local Object by Primary Key") {
                // Hardcoded primary key "1" should exist in Resources/bundled.realm.
                // See the commented method `seedLocalRealm` for how bundled.realm was created.
                guard let object = openBundledRealm().object(ofType: LocalClass.self, forPrimaryKey: "1") else {
                    print("Object not found")
                    return
                }
                print(object)
            }
            
            Button("Login in Anonymous user", action: loginAnonymousUser)
            Button("Add synced objects", action: addSyncedObject)
            Button("Print Synced Realm Results") {
                guard let realm = openSyncedRealm() else {
                    return
                }
                print(realm.objects(SyncedClass.self))
            }
        }
    }
    
    func printSyncResults() -> Void {
        return
    }
    
    private func openSyncedRealm() -> Realm? {
        guard let user = ContentView.app.currentUser() else {
            print("Could not open realm. There is no authenticated user")
            return nil
        }
        var config = user.configuration(partitionValue: user.identity!)
        config.objectTypes = [SyncedClass.self]
        return try! Realm(configuration: config)
    }
    
    private func addSyncedObject() {
        guard let realm = openSyncedRealm() else { return }
                
        try! realm.write({
            realm.create(SyncedClass.self, value: ["partition": realm.configuration.syncConfiguration?.partitionValue.stringValue])
        })
    }
    
    private func loginAnonymousUser() {
        guard ContentView.app.currentUser() == nil else {
            print("Already Authenticated: \(String(describing: ContentView.app.currentUser()?.identity))")
            return
        }
        
        ContentView.app.login(withCredential: AppCredentials.anonymous()) { completionUser, error in
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
    
    private func openBundledRealm() -> Realm {
        var config = Realm.Configuration()
        config.fileURL = Bundle.main.url(forResource: "bundled", withExtension: "realm")
        config.readOnly = false
        return try! Realm(configuration: config)
    }
    
//    private func seedLocalRealm() {
//        var config = Realm.Configuration()
//        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("bundled.realm")
//        config.readOnly = false
//        let realm = try! Realm(configuration: config)
//
//        // Delete all previous objects primary keys are not repeated
//        try! realm.write({
//            realm.deleteAll()
//        })
//
//        // Seed 3 "Grades"
//        var i = 0
//        try! realm.write({
//            while i < 3 {
//                realm.create(LocalClass.self, value: ["_id": String(i), "name": UUID().uuidString])
//                i += 1
//            }
//        })
//    }
}

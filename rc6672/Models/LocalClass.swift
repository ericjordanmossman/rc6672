import Foundation
import RealmSwift

// Class definition from 'Grade' in realm-cocoa #6672
// This class is just used in a local realm.
class LocalClass: Object {
    @objc dynamic var _id=""
    @objc dynamic var sno=0
    @objc dynamic var name=""
    @objc dynamic var version=0
    @objc dynamic var timestamp = Date()
    let linkedPrimarySkills = List<String>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["sno", "name"]
    }
}

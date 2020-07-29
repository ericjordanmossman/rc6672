import Foundation
import RealmSwift

class SyncedClass: Object {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var partition = ""
    @objc dynamic var date = Date()
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    convenience init(partition: String, name: String) {
        self.init()
        self.partition = partition
    }
}

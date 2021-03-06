////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

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

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

import XCTest
import RealmSwift
import Realm

@testable import rc6672

class rc6672Tests: XCTestCase {
    var db: RealmService! = nil
    let bundledPath: URL! = Constants.LOCAL_PATH
    var testDir: URL! = nil
    
    override func setUpWithError() throws {
        db = RealmService()
    }

    override func tearDownWithError() throws {
        db = nil
    }
    
    func testExample() throws {
        // Synchronusly Log in user
        let expect_login = self.expectation(description: "User logged in")
        RealmService.app.login(withCredential: AppCredentials.anonymous(), completion: { user, error in
            XCTAssertNotNil(user, "User not logged in")
            expect_login.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
        
        // Opens and writes to a synchronized realm
        db.addSyncedObject()
        
        // Opens and reads results from local realm
        let config = Realm.Configuration()
        let localPath = config.fileURL!.deletingLastPathComponent().appendingPathComponent("local.realm")
        let realm = db.openLocalRealm(path: localPath)
        
        let results = realm.objects(LocalClass.self)
        let objectFromPredicate = results.filter(NSPredicate(format: "_id == %@", "1")).first
        
        let objectFromPrimaryKey = realm.object(ofType: LocalClass.self, forPrimaryKey: "1")
        
//        print(objectFromPredicate)
//        print(objectFromPrimaryKey)
        
        XCTAssertNotNil(objectFromPredicate)
        XCTAssertNotNil(objectFromPrimaryKey)
        XCTAssert(objectFromPredicate == objectFromPrimaryKey)
    }
}

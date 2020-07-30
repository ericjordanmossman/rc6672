# rc6672
This project is an attempt to reproduce the report in #6672. It's not intended as an example of Realm best practice.

Steps to run:
* `pod install`
* Create test server [Realm App](https://www.mongodb.com/realm).
* Add MongoDB Realm app id to `Constants.APP_ID`
* Enable developer mode on test server. This will allow the server to receive the schema for the synchronized classes without throwing a mismatch error.
* command + u

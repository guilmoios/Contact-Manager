Purpose
--------------

MOGContacts is an Objective-C library for easily managing a local contacts list.

Unlike other solutions, MOGContacts allows developers create any custom fields without the need to use the model defaults. Just create a JSON object with the keys and values you need and the library will take care of storing and giving it back as an NSDictionary.

Supported iOS & SDK Versions
-----------------------------

* Supported build target - iOS 8.1 (Xcode 6.1, Apple LLVM compiler 6.0)
* Earliest supported deployment target - iOS 7.0
* Earliest compatible deployment target - iOS 7.0

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

MOGContacts requires ARC. If you wish to use MOGContacts in a non-ARC project, just add the `-fobjc-arc` compiler flag to the `MOGContacts.m` class. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click `MOGContacts.m` in the list and type `-fobjc-arc` into the popover.

If you wish to convert your whole project to ARC, run the Edit > Refactor > Convert to Objective-C ARC... tool in Xcode and make sure all files that you wish to use ARC for (including `MOGContacts.m`) are checked.


## Getting Started

MOGContacts makes use of `FMDB`, so please import in into your project. You can find `FMDB` at:
https://github.com/ccgus/fmdb

- Copy the MOGContacts Library folder into your project.
- Import MOGContacts.h inside your controller:
```objc
#import "MOGContacts.h"

```

## Creating a MOGContact Object

A MOGContact object consists of the following properties

```objc
@property (nonatomic, assign) int userId;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSDictionary *userDefined;
@property (nonatomic, copy) NSString *userDefinedJSON;

```

- The property `userId` is only used when getting the contact from the database as an ID is automatically assigned when you create a new contact.
- Properties `firstName`, `lastName`, `company`, `title`, `phoneNumber` and `email` are regular strings.
- Property `userDefined` is an NSDictionary, so it accepts any type of object, example:
```objc
newContact.userDefined = @{"memberId":@(19),"isMarried":@(YES),"favoriteBand":@"RUSH"}
```
- Property `userDefinedJSON` is automatically created when you set property `userDefined`. It creates a JSON string from the NSDictionary to be saved into the database during the Create mode or provides you with a JSON string when retrieving data from the database.

In order for you to create a MOGContact object you need to allocate and initialize the MOGContact object, set the properties values and call the desired method.
```objc
MOGContact *contact = [[MOGContact alloc] init];
contact.firstName = @"Guilherme";
contact.lastName = @"Mogames";
contact.company = @"Kinvey";
contact.title = @"iOS Developer";
contact.phoneNumber = @"617-378-5758";
contact.email = @"gmogames@gmail.com";
contact.userDefined = @{"memberId":@(19),"isMarried":@(YES),"favoriteBand":@"RUSH"}

```

## Supported Methods

```objc
// Returns a NSMutableArray with all contacts in the database
- (NSMutableArray *)getUsers;

// Returns a MOGContact object with the specified contact
- (MOGContact *)getUserWithId:(int)userId;

// Add a new contact to the database
- (BOOL)creatUserWithObject:(MOGContact *)contact;

// Updates an already existing contact
- (BOOL)updateUserWithObject:(MOGContact *)contact;

// Deletes a specific contact
- (BOOL)deleteUserWithID:(int)userId;

```

MOGContacts is a singleton, so in order to call any method, you can follow the following example
```objc
[[MOGContacts sharedManager] updateUserWithObject:contact];

// If Creating a new, updating or deleting a contact, you can check for success or error by
if([[MOGContacts sharedManager] updateUserWithObject:contact]){
	//Success
} else{
	//Error
}

```
In case of failure getting contacts, the returned object will be `nil`


## Example Project
To see how to use and understand more about the Library, please take a look at the `ContactsManager` Example Project
- After downloading, run a `pod install` to install the required libraries before running the example project.

## Backlog For Improvement
 
- Find someone who can write a better How To Guide
- Create a Pod to be easily imported using CocoaPods
- Include the option for the developer to chose where to save the Contact (Kinvey, Database, Local, etc...)
```objc
[[MOGContacts sharedManager] dataLocation:MOGContactDataSourceKinvey]; 
```
- Improve error reporting (provide error messages instead of boolean)
- Transform library into a .a library
- Add better Alert and UI Blockage options
- Add encryption to the data saved
- Add local cache support if user decide to store data in the cloud





## Context
A customer is building a Contact Management app. You need to ship a library to the developers there, and they are ready to start coding soon. They would be okay upgrading library versions as you iterate on the implementation, but would rather not see the interface changing. 

In its simplest form, a `Contact` object consists of the following properties: first name, last name, company, title, phone number and email address. 

## Task
* Design and implement a simple CRUD API in Objective-C (or Swift) for `Contact` objects. 
* Extend the API to support user-defined properties. A user-defined property can have an arbitrary name and data type. 

The persistence mechanism is up to you.  You can store the objects in Kinvey, or in sqlite, or in core data, or you can just keep them in memory. The only important parts are that the API is designed well and it "works". 

## Deliverables
* Library source code 
* Documentation on how to use the API
* A list of future work.

### Note
There is no “right” solution here and we are not looking for a fully robust set of features. Instead we are interested in understanding the choices you made, given the limited time window. We also care about what you would do next, if you had more time. It is fine to, for example, choose to support a limited set of data types, as long as you clearly document that.

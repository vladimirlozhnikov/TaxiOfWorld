//
//  AppDelegate.h
//  TaxiOfWorld
//
//  Created by vladimir.lozhnikov on 22.07.13.
//  Copyright (c) 2013 taxiofworld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NetworkManager.h"
#import "User.h"
#import "ChooseLocationViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSManagedObjectContext* managedObjectContext;
    NSManagedObjectModel* managedObjectModel;
    NSPersistentStoreCoordinator* persistentStoreCoordinator;
    
    NetworkManager* networkManager;
    NSData* deviceToken;
    User* me;
}

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) ChooseLocationViewController *viewController;

@property (retain, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (retain, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (retain, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@property (readonly) NetworkManager* networkManager;
@property (nonatomic, retain) User* me;
@property (readonly) NSData* deviceToken;

-(void)showActivity;
-(void)hideActivity;

@end

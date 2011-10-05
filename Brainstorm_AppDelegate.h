//
//  Brainstorm_AppDelegate.h
//  Brainstorm
//
//  Created by Jon Doud on 6/12/09.
//  Copyright Jon Doud 2009 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Brainstorm_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

@end

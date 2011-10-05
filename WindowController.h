#import <Cocoa/Cocoa.h>

@interface WindowController : NSObject {
	IBOutlet id window;
	IBOutlet id categoryList;
	IBOutlet id noteList;
	IBOutlet id editor;

	IBOutlet NSArrayController *categories;
	IBOutlet NSArrayController *notes;
}
- (void)prepareControllers;
- (IBAction)selectCategory:(id)sender;
- (IBAction)selectNote:(id)sender;

- (IBAction)addCategory:(id)sender;
- (IBAction)deleteCategory:(id)sender;

- (IBAction)addNote:(id)sender;
- (IBAction)deleteNote:(id)sender;
- (IBAction)renameNote:(id)sender;

- (IBAction)saveAsRTF:(id)sender;
- (IBAction)exportAll:(id)sender;
@end

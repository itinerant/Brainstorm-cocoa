#import "WindowController.h"

@implementation WindowController
- (IBAction)awakeFromNib {
	// set sort descriptors
	[categories setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]]];
	[notes setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]]];
	
	// set editor defaults
	[editor setRulerVisible:YES];
	[editor setFont:[NSFont fontWithName:@"Helvetica" size:13]];
  
  // get controller data
  [self performSelector: @selector(prepareControllers)
             withObject: nil
             afterDelay: 1.0];
}

- (void)prepareControllers {

  [categories rearrangeObjects];
  [notes rearrangeObjects];
  
  // select first category if a category exists
  if([[categories arrangedObjects] count] > 0)
  {
    [categories setSelectionIndex:0];
    [self selectCategory:nil];
  }
}

- (IBAction)selectCategory:(id)sender {
	NSString *predicateString = [[[NSString alloc] initWithFormat:@"category = '%@'", [[[categories selectedObjects] objectAtIndex:0] valueForKey:@"name"]] autorelease];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
	[notes setFilterPredicate:predicate];
	if([[notes arrangedObjects] count] > 0)
	{
		[notes setSelectionIndex:0];
		[self selectNote:sender];
	}
}

- (IBAction)selectNote:(id)sender {
	// set focus to the editor if a note exists
	if([notes selectionIndex] != NSNotFound)
		[window makeFirstResponder:editor];
	
	// save changes
	NSError *error = nil;
    if (![[[NSApp delegate] managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }	
}	

// *************************
// Category Methods
// ************************* 

- (IBAction)addCategory:(id)sender {
	NSManagedObject *category = [NSEntityDescription 
							 insertNewObjectForEntityForName:@"Category" inManagedObjectContext:[[NSApp delegate] managedObjectContext]];
	
	[category setValue:@"New Category" forKey:@"name"];
	
	// save changes
	NSError *error = nil;
    if (![[[NSApp delegate] managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (IBAction)deleteCategory:(id)sender {
	if([[notes arrangedObjects] count] > 0)
	{
		NSRunAlertPanel(@"Brainstorm Error", @"You must delete all notes in a category before deleting the category.", @"Ok", @"", @"");
	}
	else
		[categories removeObject:[[categories selectedObjects] objectAtIndex:0]];
}


// *************************
// Note Methods
// *************************
- (IBAction)addNote:(id)sender
{
	if([categories selectionIndex] != NSNotFound)
	{
		NSManagedObject *note = [NSEntityDescription 
									 insertNewObjectForEntityForName:@"Note" inManagedObjectContext:[[NSApp delegate] managedObjectContext]];
		
		[note setValue:@"New Note" forKey:@"name"];
		[note setValue:[[[categories selectedObjects] objectAtIndex:0] valueForKey:@"name"] forKey:@"category"];
		NSData *data = [[[NSData alloc] init] autorelease];
		[note setValue:data forKey:@"text"];
		
		// save changes
		NSError *error = nil;
		if (![[[NSApp delegate] managedObjectContext] save:&error]) {
			[[NSApplication sharedApplication] presentError:error];
		}
		
	}
	else
	{
		NSRunAlertPanel(@"Brainstorm Error", @"You must select a category before creating a new note.", @"Ok", @"", @"");
	}		
}

- (IBAction)deleteNote:(id)sender {
	[notes removeObject:[[notes selectedObjects] objectAtIndex:0]];
}

- (IBAction)renameNote:(id)sender {
	[noteList editColumn:0 row:[notes selectionIndex] withEvent:nil select:YES];
}

- (IBAction)saveAsRTF:(id)sender {
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setRequiredFileType:@"rtf"];
	[savePanel setTitle:@"Save as Rich Text"];
	if ([savePanel runModal] == NSOKButton)
		[[editor RTFFromRange:
		  NSMakeRange(0, [[editor string] length])] 
		 writeToFile:[savePanel filename] atomically:YES];
}

- (IBAction) exportAll:(id)sender {
	NSMutableString *path = [[NSMutableString alloc] initWithString:@"/Users/jdoud/Downloads/Brainstorm"];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm createDirectoryAtPath:path withIntermediateDirectories:TRUE 
				   attributes:nil error:nil];
	
	// for each note, save in folder(category) as file (note)
	for(int i=0; i<[[categories arrangedObjects] count]; i++)
	{
		[categories setSelectionIndex:i];
		[self selectCategory:sender];
		[fm createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", path, [[[categories selectedObjects] objectAtIndex:0] valueForKey:@"name"]]
								 withIntermediateDirectories:TRUE attributes:nil error:nil];
		
		for(int j=0; j<[[notes arrangedObjects] count]; j++)
		{
			[notes setSelectionIndex:j];
			[self selectNote:sender];
			[[editor RTFFromRange:
			  NSMakeRange(0, [[editor string] length])] 
			 writeToFile:[NSString stringWithFormat:@"%@/%@/%@.rtf", path, [[[categories selectedObjects] objectAtIndex:0] valueForKey:@"name"], 
				  [[[notes selectedObjects] objectAtIndex:0] valueForKey:@"name"]]
			 atomically:YES];
		}
	}
}


- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(int)rowIndex
{
	return YES;
}

@end

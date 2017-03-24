//
//  ScaryBugDoc.m
//  ScaryBugs
//
//  Created by Ray Wenderlich on 8/24/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "ScaryBugDoc.h"
#import "ScaryBugData.h"
#import "ScaryBugDatabase.h"
#import "NSData+CocoaDevUsersAdditions.h"


#define kDataKey        @"Data"
#define kDataFile       @"data.plist"
#define kCsvFile		@"data.csv"
//#define kThumbImageFile @"thumbImage.png"
//#define kFullImageFile  @"fullImage.png"

@implementation ScaryBugDoc
@synthesize data = _data;
//@synthesize thumbImage = _thumbImage;
//@synthesize fullImage = _fullImage;
@synthesize docPath = _docPath;


- (id)init {
    if ((self = [super init])) {        
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}

- (id)initWithTitle:(NSString*)title {   
	//- (id)initWithTitle:(NSString*)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage {  
    if ((self = [super init])) {
        _data = [[ScaryBugData alloc] initWithTitle:title]; //rating:rating];
        //_thumbImage = [thumbImage retain];
       // _fullImage = [fullImage retain];
    }
    return self;
}

- (void)dealloc {
    [_data release];
    _data = nil;   
    //[_fullImage release];
   // _fullImage = nil;
  //  [_thumbImage release];
   /// _thumbImage = nil;
    [_docPath release];
    _docPath = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Database methods


- (BOOL)createDataPath
{    
    if (_docPath == nil)
    {
        self.docPath = [ScaryBugDatabase nextScaryBugDocPath];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        //NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
    
}

- (ScaryBugData *)data {
    
	if (_data != nil) return _data;
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;
	
	
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [[unarchiver decodeObjectForKey:kDataKey] retain];    
    [unarchiver finishDecoding];
    [unarchiver release];
    
    return _data;    
}

- (void)saveData {
    
    if (_data == nil) return;
    
    [self createDataPath];
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
   
	
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];          
    [archiver encodeObject:_data forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    [archiver release];
    [data release];
}

- (void)deleteDoc
{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        //NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    
}

- (NSString *)getExportFileName {
    NSString *fileName = _data.title;
    NSString *zippedName = [fileName stringByAppendingString:@".motd"];
    return zippedName;
}


- (NSData *)exportToNSData {
   
	NSError *error;
    NSURL *url = [NSURL fileURLWithPath:_docPath];

	NSFileWrapper *dirWrapper = [[[NSFileWrapper alloc] initWithURL:url options:0 error:&error] autorelease];
    if (dirWrapper == nil)
    {
        //NSLog(@"Error creating directory wrapper: %@", error.localizedDescription);
        return nil;
    }   
    [self saveData];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
	documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Schedules.sqlite"];
    
    NSError *copyError = nil;
    
    [[NSFileManager defaultManager] copyItemAtPath:documentsDirectory 
                                            toPath:[_docPath stringByAppendingPathComponent:@"Schedules.sqlite"] 
                                             error:&copyError];
    
	
    NSData *dirData = [dirWrapper serializedRepresentation];
    NSData *gzData = [dirData gzipDeflate];    
   // [gzData writeToFile:[[ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Newfile.motd"] atomically:YES];
	return gzData;
//    return dirData;
}

- (NSData *) testEmail{
	//creating path
    [self createDataPath];
    
      
//    NSString *zippedName = [self getExportFileName];
	//NSLog(@"Zipped Name : %@", zippedName);
	
    NSData *gzData = [self exportToNSData];
	return gzData;
}

-(NSData*) androidMailData
{
    [self createDataPath];
    
    
    //    NSString *zippedName = [self getExportFileName];
	//NSLog(@"Zipped Name : %@", zippedName);
	
    NSData *gzData = [self exportToNSData];
	return gzData;
}


- (BOOL)exportToDiskWithForce:(BOOL)force {
    
		//creating path
    [self createDataPath];
    
    // Figure out destination name (in public docs dir)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];      
    NSString *zippedName = [self getExportFileName];
	//NSLog(@"Zipped Name : %@", zippedName);
	NSString *zippedPath = [documentsDirectory stringByAppendingPathComponent:zippedName];
    // Check if file already exists (unless we force the write)
    if (!force && [[NSFileManager defaultManager] fileExistsAtPath:zippedPath]) {
        return FALSE;
    }
    
	//Export to data buffer
    NSData *gzData = [self exportToNSData];
    if (gzData == nil) return FALSE;
    
    // Write to disk
	
    [gzData writeToFile:zippedPath atomically:YES];
    return TRUE;
    
}

- (BOOL)importData:(NSData *)zippedData
{
		 // Read data into a dir Wrapper
		NSData *unzippedData = [zippedData gzipInflate];    
				
		NSFileWrapper *dirWrapper = [[[NSFileWrapper alloc] initWithSerializedRepresentation:unzippedData] autorelease];
//    NSFileWrapper *dirWrapper = [[[NSFileWrapper alloc] initWithSerializedRepresentation:zippedData] autorelease];
		if (dirWrapper == nil)
        {
			//NSLog(@"Error creating dir wrapper from unzipped data");
//            UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"URL" message:[NSString stringWithFormat:@"Error creating dir wrapper from unzipped data"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alrt show];
//            [alrt release];
			return FALSE;
		}
		//NSLog(@"Directory Wrapper");
		
		// Calculate desired name
		NSString *dirPath = [ScaryBugDatabase nextScaryBugDocPath]; 
		//NSLog(@"Dir Path : %@",dirPath);
		
		NSURL *dirUrl = [NSURL fileURLWithPath:dirPath];  
		//NSLog(@"Dir URL : %@",dirUrl);
	
	NSError *error;
		BOOL success = [dirWrapper writeToURL:dirUrl options:NSFileWrapperWritingAtomic originalContentsURL:nil error:&error];
		if (!success)
        {
			//NSLog(@"Error importing file: %@", error.localizedDescription);
			return FALSE;
		}
		
		// Success!
		self.docPath = dirPath;
   
		// return TRUE;    
//    NSDictionary *datadict = [NSDictionary dictionaryWithContentsOfFile:[dirPath stringByAppendingPathComponent:kDataFile]];
//    NSArray *datafilename = [[[datadict valueForKey:@"$objects"] objectAtIndex:2] componentsSeparatedByString:@"_"];
//    
//    UIAlertView *confirmalert = [[UIAlertView alloc] initWithTitle:@"My Overtime" message:[NSString stringWithFormat:@"Do you want to import file %@ dated %@",[datafilename objectAtIndex:1],[datafilename objectAtIndex:2]]  delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
//    [confirmalert show];
//    [confirmalert release];
//		
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Schedules.sqlite"];
    NSError *error1;
		
    NSArray *csvfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:&error1];
		if (csvfiles == nil)
        {
			//NSLog(@"Error reading contents of documents directory: %@", [error1 localizedDescription]);
//			UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Error readingfile" message:[NSString stringWithFormat:@"Error reading : %@",error1.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alrt show];
//            [alrt release];
            return FALSE;
		}
   
    for (NSString *filename in csvfiles)
    {
        if ([filename.pathExtension compare:@"sqlite" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            NSError *copyError = nil;
            NSFileManager *fileman = [NSFileManager defaultManager];
            if ([fileman fileExistsAtPath:documentsDirectory])
            {
                NSError *deleteError = nil;
                [fileman removeItemAtPath:documentsDirectory error:&deleteError];
                if (deleteError)
                {
//                    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"delete error" message:[NSString stringWithFormat:@"Error deleting : %@",deleteError.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    [alrt show];
//                    [alrt release];
                    //NSLog(@"Delete Error : %@", deleteError.localizedDescription);
                    return FALSE;
                }
            }
            [fileman copyItemAtPath:[dirPath stringByAppendingPathComponent:filename] toPath:documentsDirectory error:&copyError];
            if (copyError)
            {
//                UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"copy error" message:[NSString stringWithFormat:@"Error copying : %@",copyError.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alrt show];
//                [alrt release];
                //NSLog(@"Copy Error : %@",copyError.localizedDescription);
                return FALSE;
            }
        }
    }
   	return YES;
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Entering alertview" message:[NSString stringWithFormat:@"%@",newPath] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alrt show];
    [alrt release];
    
    if (buttonIndex == 1) {
       
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectory = [paths objectAtIndex:0];
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Schedules.sqlite"];
        NSError *error1;
        NSArray *csvfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:newPath error:&error1];
		if (csvfiles == nil) {
			//NSLog(@"Error reading contents of documents directory: %@", [error1 localizedDescription]);
			UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Error readingfile" message:[NSString stringWithFormat:@"Error reading : %@",error1.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alrt show];
            [alrt release];
		}
        
        for (NSString *filename in csvfiles) {
            if ([filename.pathExtension compare:@"sqlite" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                NSError *copyError = nil;
                NSFileManager *fileman = [NSFileManager defaultManager];
                if ([fileman fileExistsAtPath:documentsDirectory]) {
                    NSError *deleteError = nil;
                    [fileman removeItemAtPath:documentsDirectory error:&deleteError];
                    if (deleteError) {
                        UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"delete error" message:[NSString stringWithFormat:@"Error deleting : %@",deleteError.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alrt show];
                        [alrt release];
                    }
                }
                [fileman copyItemAtPath:[newPath stringByAppendingPathComponent:filename] toPath:documentsDirectory error:&copyError];
                if (copyError) {
                    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"copy error" message:[NSString stringWithFormat:@"Error copying : %@",copyError.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alrt show];
                    [alrt release];
                }
            }
        }

    }
}
*/

-(BOOL)importDropboxData:(NSData*)dropBoxData
{
    BOOL retval = [self importData:dropBoxData];
    
    NSString *privatedoc = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *removeprivatedir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:privatedoc])
    {
        [[NSFileManager defaultManager] removeItemAtPath:privatedoc error:&removeprivatedir];
    }
	return retval;
}

- (BOOL)importFromURL:(NSURL *)importURL
{
//    NSString *file = [[NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Newfile.motd"];
//        
//    NSData *zippedData = [NSData dataWithContentsOfFile:file];
    
   NSData *zippedData = [NSData dataWithContentsOfURL:importURL];
    BOOL retval = [self importData:zippedData]; 
    
    NSString *privatedoc = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *removeprivatedir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:privatedoc])
    {
        [[NSFileManager defaultManager] removeItemAtPath:privatedoc error:&removeprivatedir];
    }
	return retval;
}


@end
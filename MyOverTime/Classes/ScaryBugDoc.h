//
//  ScaryBugDoc.h
//  ScaryBugs
//
//  Created by Ray Wenderlich on 8/24/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ScaryBugData;

@interface ScaryBugDoc : NSObject {
    ScaryBugData *_data;
   // UIImage *_thumbImage;
   // UIImage *_fullImage;
    NSString *_docPath;    

}


@property (nonatomic,retain) ScaryBugData *data;
//@property (retain) UIImage *thumbImage;
//@property (retain) UIImage *fullImage;
@property (copy) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (id)initWithTitle:(NSString*)title;
//- (id)initWithTitle:(NSString*)title rating:(float)rating thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage;
- (void)saveData;

- (void)deleteDoc;

- (NSString *)getExportFileName;
- (NSData *)exportToNSData;
- (BOOL)exportToDiskWithForce:(BOOL)force;
- (BOOL)importFromURL:(NSURL *)importURL;
- (NSData *) testEmail;

- (BOOL)importData:(NSData *)zippedData;
-(BOOL)importDropboxData:(NSData*)dropBoxData;





@end

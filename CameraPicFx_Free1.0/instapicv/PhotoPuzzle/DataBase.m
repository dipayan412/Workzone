//
//  DataBase.m
//  PhotoPuzzle
//
//  Created by Uzman Parwaiz on 8/15/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import "DataBase.h"
#import <sqlite3.h>
@implementation DataBase
+(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] 
                              stringByAppendingPathComponent: @"PhotoPuzzle.sqlite"];
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];;
    
	// If the database already exists then return without doing anything
	if(success) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
    
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PhotoPuzzle.sqlite"];
    
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
	//[fileManager release];
}

#pragma mark- AddPuzzle Functions
+(void)AddPuzzle:(NSString *)user_id puzzleImage:(NSData *)image Font_Selection:(NSString *)Font_Selection Text_Place:(NSString *)Text_Place Complexity_Level:(NSString *)Complexity_Level Text:(NSString *)Text
{
    sqlite3 *database;
    //const char *query = "Insert into clientInfo(name,address) values(?,?)";
    NSString *query = @"Insert or replace into NewPuzzle(user_name,Image,Font_Selection,Text_Place,Complexity_Level,Text) values(?,?,?,?,?,?)";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *cruddatabase = [documentsDir stringByAppendingPathComponent:@"PhotoPuzzle.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &database);
    
    if(sqlite3_open([cruddatabase UTF8String],&database) == SQLITE_OK)
    {
        
        //        const char* key = [@"BIGSecret" UTF8String];
        //        sqlite3_key(database, key, strlen(key));
        sqlite3_stmt *compiledStatement=nil;
        //  sqlite3_prepare_v2(database, query, 1, &compiledStatement, NULL);
        //  if(sqlite3_exec(database, [query UTF8String], NULL, &compiledStatement, NULL)==SQLITE_OK )
        if(sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Error while Inserting Record :- '%s'", sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
            
        }
        
        else if (sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            
            sqlite3_bind_text(compiledStatement, 1, [user_id UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(compiledStatement, 2, [image bytes],[image length], NULL);
            sqlite3_bind_text(compiledStatement, 3, [Font_Selection UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 4, [Text_Place UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 5, [Complexity_Level UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 6, [Text UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_step(compiledStatement);
            sqlite3_finalize(compiledStatement);
            sqlite3_close(database); 
        }   
    }
}
#pragma mark- UpdatePuzzle Functions
+(void)UpdatePuzzle:(NSString *)user_id Font_Selection:(NSString *)Font_Selection Text_Place:(NSString *)Text_Place Complexity_Level:(NSString *)Complexity_Level Text:(NSString *)Text ID:(int)ID
{
    sqlite3 *database;
    //const char *query = "Insert into clientInfo(name,address) values(?,?)";
    NSString *query = [NSString stringWithFormat:@"update NewPuzzle set Font_Selection='%@',Text_Place='%@',Complexity_Level='%@',Text='%@' where id=%d",Font_Selection,Text_Place,Complexity_Level,Text,ID];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *cruddatabase = [documentsDir stringByAppendingPathComponent:@"PhotoPuzzle.sqlite"];
    sqlite3_open([cruddatabase UTF8String], &database);
    if(sqlite3_open([cruddatabase UTF8String],&database) == SQLITE_OK)
    {
        
        //        const char* key = [@"BIGSecret" UTF8String];
        //        sqlite3_key(database, key, strlen(key));
        sqlite3_stmt *compiledStatement=nil;
        //  sqlite3_prepare_v2(database, query, 1, &compiledStatement, NULL);
        //  if(sqlite3_exec(database, [query UTF8String], NULL, &compiledStatement, NULL)==SQLITE_OK )
        if(sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Error while Inserting Record :- '%s'", sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
            
        }
        
        else if (sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(compiledStatement, 1, 1000);
            
            sqlite3_bind_int(compiledStatement, 2 , 1);
            char* errmsg;
            sqlite3_exec(database, "COMMIT", NULL, NULL, &errmsg);
            
            if(SQLITE_DONE != sqlite3_step(compiledStatement))
                NSLog(@"Error while updating. %s", sqlite3_errmsg(database));
            sqlite3_finalize(compiledStatement);
            
            sqlite3_close(database); 
        }  
    }
    
    sqlite3_close(database);
}
#pragma mark- viewAllPuzzle Functions
+(NSMutableArray*)viewAllPuzzle:(NSString *)user_id
{
    NSMutableArray *data=[[NSMutableArray alloc]init];
    sqlite3 *database;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *cruddatabase = [documentsDir stringByAppendingPathComponent:@"PhotoPuzzle.sqlite"];
	// Open the database from the users filessytem
	if(sqlite3_open([cruddatabase UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        NSString *query =[[[NSString alloc]initWithFormat:@"select id,user_name,Image,Font_Selection,Text_Place,Complexity_Level,Text from NewPuzzle where user_name='%@'",user_id] autorelease];
        //NSLog(@"%@",query);
		sqlite3_stmt *compiledStatement;
		//if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, nil) 
            == SQLITE_OK){
			// Loop through the results and add them to the feeds array
			//while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
				// Read the data from the result row
                int ID = sqlite3_column_int(compiledStatement, 0);
                NSString *user_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
                NSData *Image = [[[NSData alloc] initWithBytes:sqlite3_column_blob(compiledStatement,2) length: 
                                 sqlite3_column_bytes(compiledStatement, 2)] autorelease];
                NSString *Font_Selection = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
                NSString *Text_Place = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
                NSString *Complexity_Level = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,5)];
                NSString *Text = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,6)];
                
				NSDictionary *val = [[[NSDictionary alloc]initWithObjectsAndKeys:user_name,@"user_name",Image,@"image",Font_Selection,@"fontsize",Text_Place,@"textplace",Complexity_Level,@"complexitylevel",Text,@"Text",[NSString stringWithFormat:@"%d",ID],@"id",nil] autorelease];
                //NSLog(@"%@",val);
                [data addObject:val];
                
			}
		}
        //  NSLog(@"%@",login_Database);
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    return data;
}
@end
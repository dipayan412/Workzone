//
//  DataBaseManager.m
//  RenoMate
//
//  Created by yogesh ahlawat on 09/05/12.
//  Copyright (c) 2012 ahlawat789@gmail.com. All rights reserved.
//

#import "DataBaseManager.h"

@implementation DataBaseManager

static sqlite3 *database=nil;

static DataBaseManager *loader;

+(DataBaseManager*)getInstance
{
    if(loader == nil)
    {
        loader = [[DataBaseManager alloc] init];
    }
    return loader;
}

-(void)insertCatName:(NSString*)ob
{
    ob = [ob stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK)
    {
        NSString *myQuery=[[NSString alloc]initWithFormat:@"insert into CatNameTable (Name)values ('%@');", ob];
        sqlite3_exec(database, [myQuery UTF8String], nil, nil, nil);
    }
}

-(int)returnCount
{
    int i=0;
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
    sqlite3_stmt *selectstmt;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *myQuery1=[[NSString alloc]initWithFormat:@"SELECT * FROM CatDescriptionTable"];
        
        
        if(sqlite3_prepare_v2(database,[myQuery1 UTF8String],-1, &selectstmt, NULL) == SQLITE_OK)
        {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                
                i++;
            }
        }
        
    }
    return i;
}

-(int)returnCountByCat:(NSString *)cat
{
    cat = [cat stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    int i=0;
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
   
    sqlite3_stmt *selectstmt;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSString *myQuery1=[[NSString alloc]initWithFormat:@"SELECT * FROM CatDescriptionTable where Name='%@'",cat];
       
    
    if(sqlite3_prepare_v2(database,[myQuery1 UTF8String],-1, &selectstmt, NULL) == SQLITE_OK) 
    {
        
        while(sqlite3_step(selectstmt) == SQLITE_ROW) 
        { 
            
            i++;
        }
    }
    
}
    return i;
}


-(void)insertCatDescription:(CategoryDescriptionDB *)ob
{
    if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK)
    {
        ob.notes = [ob.notes stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        ob.name = [ob.name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        ob.location = [ob.location stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        NSString *myQuery=[[NSString alloc]initWithFormat:@"insert into CatDescriptionTable (Name,Notes,PhotoRef,Location,Longitute,Latitute)values ('%@','%@','%@','%@','%f','%f');",ob.name,ob.notes,ob.PhotoRef,ob.location,ob.longitute,ob.latitute];

        sqlite3_exec(database, [myQuery UTF8String], nil, nil, nil);
        
        NSLog(@"INSERT %@",ob.notes);
    }
}

-(NSString *)getDBPath
{
    // return path for database from document folder of project
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
//    NSLog(@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]);
    
    return databasePath;
}

-(NSMutableArray *)getCatagoryNames
{
   // obtain data from database to show in tableview on first screen
    
    NSMutableArray *mutableArr=[[NSMutableArray alloc] init];
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
//    NSLog(@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]);
    
    
    sqlite3_stmt *selectstmt;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSString *myQuery1 = @"SELECT * FROM CatNameTable order by upper(Name);";
        
        if(sqlite3_prepare_v2(database,[myQuery1 UTF8String],-1, &selectstmt, NULL) == SQLITE_OK) 
        {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            { 
//                NSLog(@"%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)]);
                [mutableArr addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)]];
              
            }
        }
        
        else
            NSLog(@"DataBse Not fetch successfully");
        
        
    }
    
    return mutableArr;
}

-(void)removeCat:(NSString *)str
{
//    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];

    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
              sqlite3_stmt *deleteStmt = nil;
        @synchronized(self)
        {
            if(deleteStmt == nil)
            {
                const char *sql = "delete from CatNameTable where Name=?";
               // sqlite3_bind_int(deleteStmt, 1, coffeeID);
                
                if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
                {
                    NSAssert1(0,@"Error while creating delete statement.'%s'",sqlite3_errmsg(database));
                }
            }
            
                  sqlite3_bind_text(deleteStmt, 1, [str UTF8String], -1, SQLITE_TRANSIENT);
            
            if(SQLITE_DONE != sqlite3_step(deleteStmt))
                NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
            
            sqlite3_reset(deleteStmt);	
            sqlite3_finalize(deleteStmt);
        }
    }
}

-(NSMutableArray *)getMatchingCat:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSMutableArray *mutableArr=[[NSMutableArray alloc] init];
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
//    NSLog(@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]);
    
    
    sqlite3_stmt *selectstmt;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSString *wildcardAlternateSearch = [NSString stringWithFormat:@"%@%@%@",@"%",str,@"%"];
        NSString *myQuery1=[[NSString alloc]initWithFormat:@"SELECT * FROM CatNameTable where Name LIKE '%@'",wildcardAlternateSearch];
      //  NSString *myQuery1=[[NSString alloc]initWithString:@"SELECT * FROM CatNameTable where Name LIKE '?'"];
        
      //  sqlite3_bind_text(selectstmt,1, [wildcardAlternateSearch UTF8String], -1, SQLITE_TRANSIENT);
        
        NSLog(@"%@ %@",myQuery1,wildcardAlternateSearch);
        
        if(sqlite3_prepare_v2(database,[myQuery1 UTF8String],-1, &selectstmt, NULL) == SQLITE_OK) 
        {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            { 
//                NSLog(@"%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)]);
                [mutableArr addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)]];
                
            }
//              NSLog(@"%@",myQuery1);
        }
        
        else
        {
            NSLog(@"DataBse Not fetch successfully");
        }
    }
    
    return mutableArr;    
}

-(NSMutableArray *)getSubCat:(NSString *)str
{
    NSLog(@"str %@", str);
    
//    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSLog(@"str %@", str);
    
    NSMutableArray *mutableArr=[[NSMutableArray alloc] init];
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
    sqlite3_stmt *selectstmt;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        NSString *myQuery1=[[NSString alloc]initWithFormat:@"SELECT * FROM CatDescriptionTable where Name=\"%@\" ORDER BY PhotoRef DESC;", str];
         
        if(sqlite3_prepare_v2(database,[myQuery1 UTF8String],-1, &selectstmt, NULL) == SQLITE_OK) 
        {
//            NSLog(@"%@",myQuery1);
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            { 
                CategoryDescriptionDB *ob=[[CategoryDescriptionDB alloc] init];

                ob.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)];                              
                ob.notes = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)];
                ob.location = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,2)];
                ob.latitute = sqlite3_column_double(selectstmt,3);
                ob.longitute = sqlite3_column_double(selectstmt, 4);
                ob.PhotoRef = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,5)];
                
                NSLog(@"NOTES IN GETSUBCAT: %@",ob.notes);
                
                [mutableArr addObject:ob];
            }
        }
        else
        {
            NSLog(@"DataBse Not fetch successfully");
        }
    }
    
    NSLog(@"GETSUBCATRETURN %@",mutableArr);
    
    return mutableArr;
}

-(void)removePhoto:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
//    NSLog(@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]);
    
    
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *deleteStmt = nil;
        @synchronized(self){	
            
            if(deleteStmt == nil)
            {
                const char *sql = "delete from CatDescriptionTable where PhotoRef=?";
                // sqlite3_bind_int(deleteStmt, 1, coffeeID);
                
                
                if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
                {
                    NSAssert1(0,@"Error while creating delete statement.'%s'",sqlite3_errmsg(database));
                }
            }
            
            sqlite3_bind_text(deleteStmt, 1, [str UTF8String], -1, SQLITE_TRANSIENT);
            
            if(SQLITE_DONE != sqlite3_step(deleteStmt))
                NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
            
            sqlite3_reset(deleteStmt);	
            sqlite3_finalize(deleteStmt);
            
            
        }
    }

}

-(NSMutableArray *)getMatchingSubCat:(NSString *)searchstring:(NSString *)category
{
    searchstring = [searchstring stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    category = [category stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSMutableArray *mutableArr=[[NSMutableArray alloc] init];
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
//    NSLog(@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]);
    
    
    sqlite3_stmt *selectstmt;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSString *wildcardAlternateSearch = [NSString stringWithFormat:@"%@%@%@",@"%",searchstring,@"%"];
        NSString *myQuery1=[[NSString alloc]initWithFormat:@"SELECT * FROM CatDescriptionTable where  Notes LIKE '%@' OR Location LIKE '%@' AND Name='%@'  ORDER BY PhotoRef DESC", wildcardAlternateSearch, wildcardAlternateSearch, category];
        
//        NSLog(@"%@ %@",myQuery1,wildcardAlternateSearch);
        
        if(sqlite3_prepare_v2(database,[myQuery1 UTF8String],-1, &selectstmt, NULL) == SQLITE_OK) 
        {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) 
            { 
                CategoryDescriptionDB *ob=[[CategoryDescriptionDB alloc] init];
//                NSLog(@"%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)]);
                ob.name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)];
                
                ob.notes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,1)];
                ob.location=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,2)];
                //ob.latitute=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,4)];
                //ob.latitude=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,5)];
                ob.PhotoRef=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,5)];
//                NSLog(@"%@",ob);
                [mutableArr addObject:ob];

                
             
                
            }
//            NSLog(@"%@",myQuery1);
        }
        
        else
            NSLog(@"DataBse Not fetch successfully");
        
        
    }
    
    return mutableArr;
}

-(void)updateInfo:(CategoryDescriptionDB *)ob
{

    ob.name = [ob.name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    ob.notes = [ob.notes stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    ob.location = [ob.location stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths1 objectAtIndex:0];
    
    NSString *databasePath=[[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]];
    
//    NSLog(@"%@",[documentsDir stringByAppendingPathComponent:@"renomate.sqlite"]);
    
    
    sqlite3_stmt *updatestmt;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString *myQuery1=[[NSString alloc]initWithFormat:@"update CatDescriptionTable Set Name = '%@', Notes='%@',Location='%@',Longitute= '%f', Latitute= '%f' Where PhotoRef ='%@' ",ob.name,ob.notes,ob.location,ob.longitute,ob.latitute,ob.PhotoRef];
        //  NSString *myQuery1=[[NSString alloc]initWithString:@"SELECT * FROM CatNameTable where Name LIKE '?'"];
        
        //  sqlite3_bind_text(selectstmt,1, [wildcardAlternateSearch UTF8String], -1, SQLITE_TRANSIENT);
        
//        NSLog(@"%@",myQuery1);
        
        if(sqlite3_prepare_v2(database,[myQuery1 UTF8String],-1, &updatestmt, NULL) == SQLITE_OK) 
        {
            
            if(sqlite3_step(updatestmt) == SQLITE_DONE) 
            { 
               
            }
            else
            {
                NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
                
                sqlite3_reset(updatestmt);
            }
        }
        else
            NSLog(@"DataBse Not fetch successfully");
    }
}

@end

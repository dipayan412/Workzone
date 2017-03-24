//
//  InspectionListItemProcedure.m
//  ETrackPilot
//
//  Created by World on 7/16/13.
//  Copyright (c) 2013 World. All rights reserved.
//

#import "InspectionListItemProcedure.h"

@interface InspectionListItemProcedure()

@property (nonatomic, retain) ASIHTTPRequest *getInspectionListItemRequest;

@end

@implementation InspectionListItemProcedure

@synthesize getInspectionListItemRequest;


-(void)inspectionListItemForListItemIdentifier:(NSArray*)listItemArray
{   
    [self deletePreviousData];
    
    for(int i = 0; i < listItemArray.count; i++)
    {
        NSMutableString *urlstr = [[NSMutableString alloc] init];
        [urlstr appendFormat:@"http://etrack.ws/pilot.svc/getInspectionListItems"];
        [urlstr appendFormat:@"?token=%@",[UserDefaultsManager token]];
        [urlstr appendFormat:@"&listId=%@",[listItemArray objectAtIndex:i]];
        
        NSURL *url = [NSURL URLWithString:urlstr];
        
        /*
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setCompletionBlock:^
         {
             NSLog(@"ResponseList: %@",request.responseString);

             NSError *error = nil;
             NSString *jsonString = [NSString stringWithFormat:@"{\"inspectionListItem\":%@}",request.responseString];
             NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
             
             NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
             if (error)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to purge Data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [alert release];
             }
             
             AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
             NSManagedObjectContext *context = [appdelegate managedObjectContext];
             
             NSArray *inspectionListItemArray = [responseObject objectForKey:@"inspectionListItem"];
             for (int i = 0; i < inspectionListItemArray.count; i++)
             {
                 NSDictionary *inspectionListItemObj = [inspectionListItemArray objectAtIndex:i];
                 InspectionListItems *inspectionListItem = [NSEntityDescription insertNewObjectForEntityForName:@"InspectionListItems" inManagedObjectContext:context];
                 
                 inspectionListItem.itenId = [inspectionListItemObj objectForKey:@"id"];
                 inspectionListItem.name = [inspectionListItemObj objectForKey:@"name"];
                 inspectionListItem.listId = [inspectionListItemObj objectForKey:@"listId"];
             } 
         }];
        
        [request startAsynchronous];
        */
        
        self.getInspectionListItemRequest = [ASIHTTPRequest requestWithURL:url];
        getInspectionListItemRequest.delegate = self;
        [getInspectionListItemRequest startAsynchronous];
    }
}

-(void)deletePreviousData
{
    NSError *error = nil;
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    NSEntityDescription *chartEntity = [NSEntityDescription entityForName:@"InspectionListItems" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:chartEntity];
    
    NSMutableArray *fetchArray = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [fetchRequest release];
    
    if (fetchArray && [fetchArray count] > 1)
    {
        for (InspectionListItems *inspectionListItem in fetchArray)
        {
            [context deleteObject:inspectionListItem];
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"ResponseList: %@",request.responseString);
    
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithFormat:@"{\"inspectionListItem\":%@}",request.responseString];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to purge Data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    NSArray *inspectionListItemArray = [responseObject objectForKey:@"inspectionListItem"];
    for (int i = 0; i < inspectionListItemArray.count; i++)
    {
        NSDictionary *inspectionListItemObj = [inspectionListItemArray objectAtIndex:i];
        InspectionListItems *inspectionListItem = [NSEntityDescription insertNewObjectForEntityForName:@"InspectionListItems" inManagedObjectContext:context];
        
        inspectionListItem.itenId = [inspectionListItemObj objectForKey:@"itemId"];
        inspectionListItem.name = [inspectionListItemObj objectForKey:@"name"];
        inspectionListItem.listId = [inspectionListItemObj objectForKey:@"listId"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end

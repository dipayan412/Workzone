//
//  CommunityHomeController.h
//  Whosin
//
//  Created by Kumar Aditya on 12/11/11.
//  Copyright 2011 Sumoksha Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingeltonAuthorityClass.h"
#import "Connections.h"


@interface CommunityHomeController : UIViewController <UITableViewDelegate,UITableViewDataSource>{

	
	IBOutlet UIScrollView *scroller;
	IBOutlet UIImageView *imageview;
     UITableView *myTable;
	NSString *someString;
	SingeltonAuthorityClass *authorityClass;
	NSDictionary *dictString;

	UIButton *peopleButton;
	UIButton *meButton;
	int sizeofblock;
	
	 	 	 
}
	@property (nonatomic,retain)IBOutlet UIScrollView *scroller;
     @property (nonatomic,retain) IBOutlet UIImageView *imageview;
  @property (nonatomic, copy) NSString *someString; 
@property (nonatomic,retain) NSDictionary *dictString;
@property (nonatomic,retain)  IBOutlet UIButton *peopleButton;
@property (nonatomic,retain) IBOutlet UIButton *meButton;


-(void)establishConnection;
-(IBAction)peopleButtonClicked:(UIButton *)self; 
-(IBAction)meButtonClicked:(UIButton *)self; 
-(IBAction)homeButtonClicked;
-(NSString *)timeConverter:(int)sec;
 
 
@end

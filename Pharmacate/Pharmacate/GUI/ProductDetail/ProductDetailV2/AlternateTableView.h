//
//  AlternateTableView.h
//  Pharmacate
//
//  Created by Dipayan Banik on 8/13/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlternateTableView : UIView

-(id)initWithFrame:(CGRect)rect WithDataArray:(NSMutableArray*)_dataArray;
-(id)initWithDataArray:(NSMutableArray*)_dataArray;

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UITableView *tableView;

@end

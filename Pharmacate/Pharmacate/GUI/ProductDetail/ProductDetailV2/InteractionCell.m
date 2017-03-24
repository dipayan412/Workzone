//
//  InteractionCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 11/12/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

//#import "InteractionCell.h"
//
//@implementation InteractionCell
//
//
//
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//}
//
//@end

//
//  AlternativeCell.m
//  Pharmacate
//
//  Created by Dipayan Banik on 8/15/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "InteractionCell.h"
#import "NewsTableViewCell.h"

#define cellHeight 60.0f

@interface InteractionCell() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *alternativeTableView;
}

@end

@implementation InteractionCell

@synthesize cellTitleLabel;
@synthesize rightAccessoryImageView;
@synthesize dataArray;
@synthesize delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        topContainerView = [[UIView alloc] init];
        topContainerView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:topContainerView];
        
        cellTitleLabel = [[UILabel alloc] init];
        cellTitleLabel.backgroundColor = [UIColor clearColor];
        cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:cellTitleLabel];
        
        rightAccessoryImageView = [[UIImageView alloc] init];
        rightAccessoryImageView.backgroundColor = [UIColor clearColor];
        rightAccessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:rightAccessoryImageView];
        
        customSeparatorView = [[UIView alloc] init];
        customSeparatorView.backgroundColor = [UIColor lightGrayColor];
        //        [self.contentView addSubview:customSeparatorView];
        
        alternativeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        alternativeTableView.delegate = self;
        alternativeTableView.dataSource = self;
        alternativeTableView.hidden = YES;
        alternativeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:alternativeTableView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    topContainerView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, cellHeight);
    cellTitleLabel.frame = CGRectMake(5, 0, 3*self.contentView.frame.size.width/4 + 5, cellHeight);
    rightAccessoryImageView.frame = CGRectMake(self.contentView.frame.size.width - cellHeight/2, cellHeight/4, cellHeight/2, cellHeight/2);
    customSeparatorView.frame = CGRectMake(0, cellTitleLabel.frame.size.height - 0.5, self.contentView.frame.size.width, 0.5);
    alternativeTableView.frame = CGRectMake(0, customSeparatorView.frame.origin.y, self.contentView.frame.size.width, dataArray.count * 44.0f);
    if(self.contentView.frame.size.height > cellHeight)
    {
        topContainerView.backgroundColor = themeColor;
        alternativeTableView.hidden = NO;
    }
    else
    {
        topContainerView.backgroundColor = [UIColor clearColor];
        alternativeTableView.hidden = YES;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    NewsTableViewCell *cell;
    if(cell == nil)
    {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if(![[dataArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        if([[dataArray objectAtIndex:0] isEqualToString:NSLocalizedString(kAlternativeLoading, nil)] || [[dataArray objectAtIndex:0] isEqualToString:NSLocalizedString(kAlternativeNoData, nil)])
        {
            cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    else
    {
        NSDictionary *data = [dataArray objectAtIndex:indexPath.row];
        cell.newsTitleLabel.text = [data objectForKey:@"PROPRIETARY_NAME"];
        if([data objectForKey:@"IMAGE_URL"] != [NSNull null])
        {
            if(![[data objectForKey:@"IMAGE_URL"] isEqualToString:@""])
            {
                [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"IMAGE_URL"]] placeholderImage:[UIImage imageNamed:@"noImageAvailable.png"]];
            }
            else
            {
                cell.newsImageView.image = [UIImage imageNamed:@"noImageAvailable.png"];
            }
        }
        else
        {
            cell.newsImageView.image = [UIImage imageNamed:@"noImageAvailable.png"];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([[dataArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        if(delegate)
        {
            [delegate intersectionSelectedWithProductId:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"PRODUCT_ID"] andName:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"PROPRIETARY_NAME"]];
        }
    }
}

-(void)setDataArray:(NSMutableArray *)_dataArray
{
    dataArray = _dataArray;
    [alternativeTableView reloadData];
}

@end


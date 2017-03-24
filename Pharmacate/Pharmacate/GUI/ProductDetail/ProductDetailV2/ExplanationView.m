//
//  ExplanationView.m
//  Pharmacate
//
//  Created by Dipayan Banik on 7/18/16.
//  Copyright © 2016 Gravalabs. All rights reserved.
//

#import "ExplanationView.h"
#import "ExplanationCell.h"
#import "InteractionCell.h"
#define cellHeight 60

@interface ExplanationView() <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, InteractionCellDelegate>
{
    NSString *productId;
    NSMutableArray *dataArray;
    UITableView *expalanationTableView;
    NSIndexPath *selectedIndexPath;
    NSMutableString *diseaseString;
    NSMutableString *symptomString;
    NSMutableString *sideEffectString;
    NSMutableString *descriptionString;
    NSMutableString *totalIngredientStr;
    NSMutableString *pregnancyString;
    NSMutableString *boxWarningString;
    NSMutableString *contraindicationsString;
    NSMutableString *allergenString;
    NSMutableAttributedString *finalIngredientString;
    NSMutableAttributedString *finalSideEffectString;
    NSMutableString *boxWarningShortString; //Short Warning String
    NSMutableString *dosageAdminString; //Dosage Adminstration Normal String
    NSMutableString *dosageAdminShortString; //Dosage Administration Short String
    
    NSDictionary *scoreDictionary;
}

@end

@implementation ExplanationView

@synthesize delegate;

- (id)initWithFrame:(CGRect)rect WithProductId:(NSString*)_productId
{
    if ((self = [super initWithFrame:rect]))
    {
        productId = _productId;
        [self commonIntialization];
    }
    return self;
}

-(void)commonIntialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:1000];
    diseaseString = [[NSMutableString alloc] init];
    symptomString = [[NSMutableString alloc] init];
    sideEffectString = [[NSMutableString alloc] init];
    descriptionString = [[NSMutableString alloc] init];
    totalIngredientStr = [[NSMutableString alloc] init];
    finalIngredientString = [[NSMutableAttributedString alloc] init];
    finalSideEffectString = [[NSMutableAttributedString alloc] init];
    pregnancyString = [[NSMutableString alloc] init];
    boxWarningString = [[NSMutableString alloc] init];
    contraindicationsString = [[NSMutableString alloc] init];
    allergenString = [[NSMutableString alloc] init];
    boxWarningShortString = [[NSMutableString alloc] init]; //Short Warning String
    dosageAdminString = [[NSMutableString alloc] init]; //Dosage Administration Normal String
    dosageAdminShortString = [[NSMutableString alloc] init]; //Dosage Administration Short String
    
    dataArray = [[NSMutableArray alloc] init];
    
    expalanationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height) style:UITableViewStylePlain];
    expalanationTableView.delegate = self;
    expalanationTableView.dataSource = self;
    expalanationTableView.backgroundColor = [UIColor clearColor];
    expalanationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    expalanationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:expalanationTableView];
//    [self tableView:expalanationTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [self getProductDetailFromServer];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 11;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 11)
    {
        static NSString *cellId = @"cellId";
        InteractionCell *cell;
        if(cell == nil)
        {
            cell = [[InteractionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        if(selectedIndexPath.section != indexPath.section)
        {
            cell.rightAccessoryImageView.image = [UIImage imageNamed:@"forwardButtonGray.png"];
        }
        else
        {
            cell.rightAccessoryImageView.image = [UIImage imageNamed:@"downButtonBlack.png"];
        }
        
        cell.delegate = self;
        
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Advicor", @"PROPRIETARY_NAME", @"https://s3.amazonaws.com/production_medifacs/uploads/product_image/142124/8d64bbf8-4d9a-4e38-b367-18827b5d9a71.jpg", @"IMAGE_URL", @"1000060665", @"PRODUCT_ID", nil];
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        [dataArr addObject:dic1];
        
        cell.cellTitleLabel.text = @"Interactions";
        cell.dataArray = dataArr;
        
        return cell;
    }
    static NSString *cellId = @"cellId";
    ExplanationCell *cell;
    if(cell == nil)
    {
        cell = [[ExplanationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if(selectedIndexPath.section != indexPath.section)
    {
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"forwardButtonGray.png"];
    }
    else
    {
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"downButtonBlack.png"];
    }
    
    
//    if(indexPath.section == 0)
//    {
//        cell.cellTitleLabel.text = NSLocalizedString(kDetailLabelDescription, nil);
//        if(!descriptionString || [descriptionString isEqualToString:@""])
//        {
//            cell.contentLabel.text = [NSString stringWithFormat:@"%@ \n%@", NSLocalizedString(kDetailLabelLoading, nil), productId];
//        }
//        else
//        {
//            cell.contentLabel.text = [NSString stringWithFormat:@"%@ \n%@", descriptionString, productId];
//        }
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.contentView.layer.borderWidth = 0.25f;
//    }
    if(indexPath.section == 0)
    {
        cell.cellTitleLabel.text = NSLocalizedString(kDetailLabelIngredient, nil);
        if(!totalIngredientStr || [totalIngredientStr isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            if(![finalIngredientString.string isEqualToString:@""])
            {
                cell.contentLabel.attributedText = finalIngredientString;
            }
            else
            {
                cell.contentLabel.text = totalIngredientStr;
            }
        }
        
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.contentView.layer.borderWidth = 0.25f;
    }
    else if(indexPath.section == 1)
    {
        cell.cellTitleLabel.text = NSLocalizedString(kDetailLabelDisease, nil);
        if(!diseaseString || [diseaseString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            cell.contentLabel.text = diseaseString;
        }
        
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.contentView.layer.borderWidth = 0.25f;
    }
    else if(indexPath.section == 2)
    {
        cell.cellTitleLabel.text = NSLocalizedString(kDetailLabelSymptoms, nil);
        if(!symptomString || [symptomString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            cell.contentLabel.text = symptomString;
        }
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.contentView.layer.borderWidth = 0.25f;
    }
    else if(indexPath.section == 3)
    {
        cell.cellTitleLabel.text = NSLocalizedString(kDetailLabelSideEffects, nil);
        if(!sideEffectString || [sideEffectString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            if(![finalSideEffectString.string isEqualToString:@""])
            {
                cell.contentLabel.attributedText = finalSideEffectString;
            }
            else
            {
                cell.contentLabel.text = sideEffectString;
            }
            
            if(scoreDictionary && [scoreDictionary objectForKey:@"SIDE_EFFECT_SCORE"] != [NSNull null] && [scoreDictionary objectForKey:@"SIDE_EFFECT_SCORE"] != nil)
            {
                cell.gradeLabel.text = [self getGradeForScore:[[scoreDictionary objectForKey:@"SIDE_EFFECT_SCORE"] floatValue]];
                cell.gradeLabel.textColor = [UIColor colorWithRed:1.0f/255 green:95.0f/255 blue:133.0f/255 alpha:1.0f];
                cell.gradeLabel.layer.borderColor = [UIColor colorWithRed:1.0f/255 green:95.0f/255 blue:133.0f/255 alpha:1.0f].CGColor;
                cell.gradeLabel.layer.borderWidth = 2.0f;
            }
        }
        
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.contentView.layer.borderWidth = 0.25f;
    }
    else if(indexPath.section == 4)
    {
        cell.cellTitleLabel.text = @"Box Warning";
        if(!boxWarningString || [boxWarningString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            cell.contentLabel.text = boxWarningString;
            if(scoreDictionary && ![boxWarningString isEqualToString:@"No data to display"])
            {
                if([scoreDictionary objectForKey:@"WARNING_SCORE"] != [NSNull null] && [scoreDictionary objectForKey:@"WARNING_SCORE"] != nil)
                {
                    cell.gradeLabel.text = [self getGradeForScore:[[scoreDictionary objectForKey:@"WARNING_SCORE"] floatValue]];
                    cell.gradeLabel.textColor = [UIColor colorWithRed:240.0f/255 green:109.0f/255 blue:43.0f/255 alpha:1.0f];
                    cell.gradeLabel.layer.borderColor = [UIColor colorWithRed:240.0f/255 green:109.0f/255 blue:43.0f/255 alpha:1.0f].CGColor;
                    cell.gradeLabel.layer.borderWidth = 2.0f;
                }
            }
        }
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.contentView.layer.borderWidth = 0.25f;
    }
    else if(indexPath.section == 5)
    {
        cell.cellTitleLabel.text = @"Pregnancy & Breastfeeding";
        if(!pregnancyString || [pregnancyString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            cell.contentLabel.text = pregnancyString;
            if(scoreDictionary && ![pregnancyString isEqualToString:@"No data to display"])
            {
                if([scoreDictionary objectForKey:@"PREGNANCY_SCORE"] != [NSNull null] && [scoreDictionary objectForKey:@"PREGNANCY_SCORE"] != nil)
                {
                    cell.gradeLabel.text = [self getGradeForScore:[[scoreDictionary objectForKey:@"PREGNANCY_SCORE"] floatValue]];
                    cell.gradeLabel.textColor = [UIColor colorWithRed:157.0f/255 green:198.0f/255 blue:218.0f/255 alpha:1.0f];
                    cell.gradeLabel.layer.borderColor = [UIColor colorWithRed:157.0f/255 green:198.0f/255 blue:218.0f/255 alpha:1.0f].CGColor;
                    cell.gradeLabel.layer.borderWidth = 2.0f;
                }
            }
        }
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.contentView.layer.borderWidth = 0.25f;
    }
    
    else if(indexPath.section == 6)
    {
        cell.cellTitleLabel.text = @"Contraindications";
        if(!contraindicationsString || [contraindicationsString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            cell.contentLabel.text = contraindicationsString;
            if(scoreDictionary && ![contraindicationsString isEqualToString:@"No data to display"])
            {
                if([scoreDictionary objectForKey:@"CONTRAINDICATION_SCORE"] != [NSNull null] && [scoreDictionary objectForKey:@"CONTRAINDICATION_SCORE"] != nil)
                {
                    cell.gradeLabel.text = [self getGradeForScore:[[scoreDictionary objectForKey:@"CONTRAINDICATION_SCORE"] floatValue]];
                    cell.gradeLabel.textColor = [UIColor colorWithRed:30.0f/255 green:123.0f/255 blue:26.0f/255 alpha:1.0f];
                    cell.gradeLabel.layer.borderColor = [UIColor colorWithRed:30.0f/255 green:123.0f/255 blue:26.0f/255 alpha:1.0f].CGColor;
                    cell.gradeLabel.layer.borderWidth = 2.0f;
                }
            }
        }
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.contentView.layer.borderWidth = 0.25f;
    }
    
    else if(indexPath.section == 7)
    {
        cell.cellTitleLabel.text = @"Allergens";
        if(!allergenString || [allergenString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            cell.contentLabel.text = allergenString;
        }
        
        if(scoreDictionary && [scoreDictionary objectForKey:@"ALLERGEN_SCORE"] != [NSNull null] && [scoreDictionary objectForKey:@"ALLERGEN_SCORE"] != nil)
        {
            cell.gradeLabel.text = [self getGradeForScore:[[scoreDictionary objectForKey:@"ALLERGEN_SCORE"] floatValue]];
            cell.gradeLabel.textColor = [UIColor colorWithRed:100.0f/255 green:43.0f/255 blue:8.0f/255 alpha:1.0f];
            cell.gradeLabel.layer.borderColor = [UIColor colorWithRed:100.0f/255 green:43.0f/255 blue:8.0f/255 alpha:1.0f].CGColor;
            cell.gradeLabel.layer.borderWidth = 2.0f;
        }
//        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.contentView.layer.borderWidth = 0.25f;
    }
    else if(indexPath.section == 8) //Short Box Warnings
    {
        cell.cellTitleLabel.text = @"Box Warnings Short";
        if(!boxWarningShortString || [boxWarningShortString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            cell.contentLabel.text = boxWarningShortString;
        }
        //        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        cell.contentView.layer.borderWidth = 0.25f;
    }
    else if(indexPath.section == 9) //Dosage Administration
    {
        cell.cellTitleLabel.text = @"Dosage Administration";
        if(!dosageAdminString || [dosageAdminString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            cell.contentLabel.text = dosageAdminString;
        }
        //        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        cell.contentView.layer.borderWidth = 0.25f;
    }
    else if(indexPath.section == 10) //Dosage Administration Short
    {
        cell.cellTitleLabel.text = @"Dosage Administration Short";
        if(!dosageAdminShortString || [dosageAdminShortString isEqualToString:@""])
        {
            cell.contentLabel.text = NSLocalizedString(kDetailLabelLoading, nil);
        }
        else
        {
            cell.contentLabel.text = dosageAdminShortString;
        }
        //        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //        cell.contentView.layer.borderWidth = 0.25f;
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(selectedIndexPath)
    {
        ExplanationCell *cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"forwardButtonGray.png"];
    }
    ExplanationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.rightAccessoryImageView.image = [UIImage imageNamed:@"downButtonBlack.png"];
    
    if(selectedIndexPath && selectedIndexPath.section == indexPath.section)
    {
        selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:100];
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"forwardButtonGray.png"];
    }
    else
    {
        selectedIndexPath = indexPath;
        cell.rightAccessoryImageView.image = [UIImage imageNamed:@"downButtonBlack.png"];
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIndexPath && selectedIndexPath.section == indexPath.section)
    {
//        if(indexPath.section == 0)
//        {
//            CGRect r = [descriptionString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
//                                                       options:NSStringDrawingUsesLineFragmentOrigin
//                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
//                                                       context:nil];
//            return r.size.height + cellHeight + 50;
//        }
        if(indexPath.section == 0)
        {
            CGRect r = [totalIngredientStr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 20000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                       context:nil];
            if([totalIngredientStr isEqualToString:@"No data to display"])
            {
                return r.size.height + cellHeight + 50;
            }
            return r.size.height + cellHeight + 50;
        }
        else if(indexPath.section == 1)
        {
            CGRect r = [diseaseString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                   context:nil];
            return r.size.height + cellHeight + 50;
        }
        else if(indexPath.section == 2)
        {
            CGRect r = [symptomString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                   context:nil];
            return r.size.height + cellHeight + 50;
        }
        else if(indexPath.section == 3)
        {
            CGRect r = [sideEffectString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                   context:nil];
            return r.size.height + cellHeight + 50;
        }
        else if(indexPath.section == 4)
        {
            CGRect r = [boxWarningString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                   context:nil];
            return r.size.height + cellHeight + 50;
        }
        else if(indexPath.section == 5)
        {
            CGRect r = [pregnancyString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                   context:nil];
            return r.size.height + cellHeight + 50;
        }
        else if(indexPath.section == 6)
        {
            CGRect r = [contraindicationsString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                     context:nil];
            return r.size.height + cellHeight + 50;
        }
        else if(indexPath.section == 7)
        {
            CGRect r = [allergenString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                             context:nil];
            return r.size.height + cellHeight + 50;
        }
        else if(indexPath.section == 8) //Short Warning Dimensions
        {
            CGRect r = [boxWarningShortString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                           context:nil];
            return r.size.height + cellHeight + 50;
            
        }
        else if(indexPath.section == 9) //Dosage Administration Dimensions
        {
            CGRect r = [dosageAdminString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                       context:nil];
            return r.size.height + cellHeight + 50;
            
        }
        else if(indexPath.section == 10) //Dosage Administration Short Dimensions
        {
            CGRect r = [dosageAdminShortString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                                            context:nil];
            return r.size.height + cellHeight + 50;
            
        }
        else if(indexPath.section == 11)
        {
            return 2 * cellHeight;
        }
    }
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if(section == 0)
//    {
//        return 0.0f;
//    }
//    return (self.frame.size.height - 5 * cellHeight) / 4;
    return 0.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = (self.frame.size.height - 5 * cellHeight) / 4;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void)intersectionSelectedWithProductId:(NSString *)_productId andName:(NSString *)_name
{
    if(delegate)
    {
        [delegate intersectSelectionAction:_productId productName:_name];
    }
}

-(void)getProductDetailFromServer
{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:getProductDetail];
    [urlStr appendString:[NSString stringWithFormat:@"?pId=%@",productId]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSLog(@"SimilarUrl %@", urlStr);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[UserDefaultsManager getUserToken] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dataJSON;
        if(data)
        {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"ProductDetail %@",dataJSON);
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                    NSString *imageUrlString = @"";
                    NSString *gradeString = @"";
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Image_URL"] && [[[dataJSON objectForKey:@"Data"] objectForKey:@"Image_URL"] count] > 0)
                    {
                        [userInfo setObject:[[dataJSON objectForKey:@"Data"] objectForKey:@"Image_URL"] forKey:@"PRODUCT_IMAGE_URL_ARRAY"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kProductImageReceived object:nil userInfo:userInfo];
                        imageUrlString = [[[[dataJSON objectForKey:@"Data"] objectForKey:@"Image_URL"] objectAtIndex:0] objectForKey:@"image_link"];
                    }
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Scores"] != [NSNull null] && [[dataJSON objectForKey:@"Data"] objectForKey:@"Scores"] != nil)
                    {
                        NSDictionary *tmpDic = [[dataJSON objectForKey:@"Data"] objectForKey:@"Scores"];
                        NSLog(@"scores %@", tmpDic);
                        scoreDictionary = tmpDic;
                        NSMutableArray *scores = [[NSMutableArray alloc] init];
                        NSMutableArray *grades = [[NSMutableArray alloc] init];
                        
                        if([tmpDic objectForKey:@"WARNING_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"WARNING_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"WARNING_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"PREGNANCY_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"PREGNANCY_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"PREGNANCY_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"SIDE_EFFECT_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"SIDE_EFFECT_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"SIDE_EFFECT_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"DRUG_INTERACTION_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"DRUG_INTERACTION_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"DRUG_INTERACTION_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"CONTRAINDICATION_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"CONTRAINDICATION_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"CONTRAINDICATION_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"ALLERGEN_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"ALLERGEN_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"ALLERGEN_SCORE"] floatValue]]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                        }
                        
                        if([tmpDic objectForKey:@"LABEL_SCORE"] != [NSNull null])
                        {
                            [scores addObject:[tmpDic objectForKey:@"LABEL_SCORE"]];
                            [grades addObject:[self getGradeForScore:[[tmpDic objectForKey:@"LABEL_SCORE"] floatValue]]];
                            gradeString = [self getGradeForScore:[[tmpDic objectForKey:@"LABEL_SCORE"] floatValue]];
                        }
                        else
                        {
                            [scores addObject:[NSNumber numberWithInteger:0]];
                            [grades addObject:[self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]]];
                            gradeString = [self getGradeForScore:[[NSNumber numberWithInteger:0] floatValue]];
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLabelScoresReceived object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:scores, @"LABEL_SCORES", grades, @"LABEL_GRADES", nil]];
                    }
                    else
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLabelScoresMissing object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray array], @"LABEL_SCORES", nil]];
                    }
                    
                    for(int i = 0; i < [[[dataJSON objectForKey:@"Data"] objectForKey:@"Diseases"] count]; i++)
                    {
                        NSDictionary *disease = [[[dataJSON objectForKey:@"Data"] objectForKey:@"Diseases"] objectAtIndex:i];
                        [diseaseString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"DISEASE_NAME"]]];
                        if(i != [[[dataJSON objectForKey:@"Data"] objectForKey:@"Diseases"] count] - 1)
                        {
                            [diseaseString appendString:@",\n"];
                        }
                    }
                    if([diseaseString isEqualToString:@""])
                    {
                        [diseaseString appendString:@"No data to display"];
                    }
                    
                    NSArray *activeArray = [NSArray arrayWithArray:[[[dataJSON objectForKey:@"Data"] objectForKey:@"Ingredients"] objectForKey:@"Active"]];
                    NSMutableString *activeStr = [[NSMutableString alloc] init];
                    if(activeArray.count != 0)
                    {
                        for(int i = 0; i < activeArray.count; i++)
                        {
                            [activeStr appendString:[NSString stringWithFormat:@"%@",[[activeArray objectAtIndex:i] objectForKey:@"INGREDIENT_NAME"]]];
                            if(i != [activeArray count] - 1)
                            {
                                [activeStr appendString:@", "];
                            }
                        }
                        
//                        [activeStr appendString:@"\n\n"];
                        [totalIngredientStr appendString:@"Active: "];
                        [totalIngredientStr appendString:activeStr];
                    }
                    
                    NSArray *inactiveArray = [NSArray arrayWithArray:[[[dataJSON objectForKey:@"Data"] objectForKey:@"Ingredients"] objectForKey:@"Inactive"]];
                    NSMutableString *inactiveStr = [[NSMutableString alloc] init];
                    if(inactiveArray.count != 0)
                    {
                        [totalIngredientStr appendString:@"\n\n"];
                        for(int i = 0; i < inactiveArray.count; i++)
                        {
                            [inactiveStr appendString:[NSString stringWithFormat:@"%@",[[inactiveArray objectAtIndex:i] objectForKey:@"INGREDIENT_NAME"]]];
                            if(i != [inactiveArray count] - 1)
                            {
                                [inactiveStr appendString:@", "];
                            }
                        }
                        
                        [totalIngredientStr appendString:@"Inactive: "];
                        [totalIngredientStr appendString:inactiveStr];
                    }
                    
                    NSArray *unknownArray = [NSArray arrayWithArray:[[[dataJSON objectForKey:@"Data"] objectForKey:@"Ingredients"] objectForKey:@"Unknown"]];
                    NSMutableString *unknownStr = [[NSMutableString alloc] init];
                    if(unknownArray.count != 0)
                    {
                        [totalIngredientStr appendString:@"\n\n"];
                        for(int i = 0; i < unknownArray.count; i++)
                        {
                            [unknownStr appendString:[NSString stringWithFormat:@"%@",[[unknownArray objectAtIndex:i] objectForKey:@"INGREDIENT_NAME"]]];
                            if(i != [unknownArray count] - 1)
                            {
                                [unknownStr appendString:@", "];
                            }
                        }
                        [totalIngredientStr appendString:@"Unknown: "];
                        [totalIngredientStr appendString:unknownStr];
                    }
                    
                    NSDictionary *defaultAttribute = @{
                                            NSFontAttributeName:[UIFont systemFontOfSize:17],
                                            NSForegroundColorAttributeName:[UIColor blackColor]
                                            };
                    NSDictionary *boldAttribute = @{
                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:17]
                                               };
                    if(totalIngredientStr.length > 0)
                    {
                        finalIngredientString = [[NSMutableAttributedString alloc] initWithString:totalIngredientStr attributes:defaultAttribute];
                        NSRange range1 = NSMakeRange(0, 0);
                        if(activeStr.length > 0)
                        {
                            range1 = NSMakeRange(0,8);
                            [finalIngredientString setAttributes:boldAttribute range:range1];
                        }
                        NSRange range2 = NSMakeRange(0, 0);
                        if(inactiveStr.length > 0)
                        {
                            range2 = NSMakeRange(range1.location + range1.length + activeStr.length, 10);
                            [finalIngredientString setAttributes:boldAttribute range:range2];
                        }
                        NSRange range3 = NSMakeRange(0, 0);
                        if(unknownStr.length > 0)
                        {
                            range3 = NSMakeRange(range2.location + range2.length + inactiveStr.length, 9);
                            [finalIngredientString setAttributes:boldAttribute range:range3];
                        }
                    }
                    else
                    {
                        [totalIngredientStr appendString:@"No data to display"];
                    }
                    
                    if([[[dataJSON objectForKey:@"Data"] objectForKey:@"Product"] count] > 0)
                    {
                        if([[[[dataJSON objectForKey:@"Data"] objectForKey:@"Product"] objectAtIndex:0] objectForKey:@"DESCRIPTION"] != [NSNull null] || ![[[[dataJSON objectForKey:@"Data"] objectForKey:@"Product"] objectAtIndex:0] objectForKey:@"DESCRIPTION"])
                        {
                            [descriptionString appendString:[NSString stringWithFormat:@"%@", [[[[dataJSON objectForKey:@"Data"] objectForKey:@"Product"] objectAtIndex:0] objectForKey:@"DESCRIPTION"]]];
                        }
                    }
                    if([descriptionString isEqualToString:@""])
                    {
                        [descriptionString appendString:@"No data to display"];
                    }
                    
                    NSLog(@"imgUrl %@", imageUrlString);
                    NSLog(@"ovrallGrade %@", gradeString);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductDetailReceived" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:descriptionString, @"DESCRIPTION", imageUrlString, @"PRODUCT_IMAGE", gradeString, @"OVERALL_GRADE", nil]];
                    
                    for(int i = 0; i < [[[dataJSON objectForKey:@"Data"] objectForKey:@"Symptoms"] count]; i++)
                    {
                        NSDictionary *disease = [[[dataJSON objectForKey:@"Data"] objectForKey:@"Symptoms"] objectAtIndex:i];
                        [symptomString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"SYMPTOM_NAME"]]];
                        if(i != [[[dataJSON objectForKey:@"Data"] objectForKey:@"Symptoms"] count] - 1)
                        {
                            [symptomString appendString:@",\n"];
                        }
                    }
                    if([symptomString isEqualToString:@""])
                    {
                        [symptomString appendString:@"No data to display"];
                    }
                    
                    NSMutableString *severeSideEffectString = [[NSMutableString alloc] init];
                    NSMutableString *regularSideEffectString = [[NSMutableString alloc] init];
                    
                    for(int i = 0; i < [[[dataJSON objectForKey:@"Data"] objectForKey:@"SideEffects"] count]; i++)
                    {
                        NSDictionary *disease = [[[dataJSON objectForKey:@"Data"] objectForKey:@"SideEffects"] objectAtIndex:i];
                        if([[disease objectForKey:@"SIDE_EFFECT_TYPE"] isEqualToString:@"SEVERE"])
                        {
                            [severeSideEffectString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"SIDE_EFFECT_NAME"]]];
                            [severeSideEffectString appendString:@" "];
                        }
                        else
                        {
                            [regularSideEffectString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"SIDE_EFFECT_NAME"]]];
                            [regularSideEffectString appendString:@" "];
                        }
                    }
                    
                    if([severeSideEffectString length] > 0)
                    {
                        [severeSideEffectString appendString:@"\n\n"];
                        [sideEffectString appendString:@"Severe: "];
                        [sideEffectString appendString:severeSideEffectString];
                    }
                    
                    if([regularSideEffectString length] > 0)
                    {
                        [sideEffectString appendString:@"Regular: "];
                        [sideEffectString appendString:regularSideEffectString];
                    }
                    
                    if([sideEffectString isEqualToString:@""])
                    {
                        [sideEffectString appendString:@"No data to display"];
                    }
                    else
                    {
                        finalSideEffectString = [[NSMutableAttributedString alloc] initWithString:sideEffectString attributes:defaultAttribute];
                        NSRange range1 = NSMakeRange(0, 0);
                        if(severeSideEffectString.length > 0)
                        {
                            range1 = NSMakeRange(0,8);
                            [finalSideEffectString setAttributes:boldAttribute range:range1];
                        }
                        NSRange range2 = NSMakeRange(0, 0);
                        if(regularSideEffectString.length > 0)
                        {
                            range2 = NSMakeRange(range1.location + range1.length + severeSideEffectString.length, 9);
                            [finalSideEffectString setAttributes:boldAttribute range:range2];
                        }
                    }
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Pregnancy"] != [NSNull null])
                    {
                        if(![[[dataJSON objectForKey:@"Data"] objectForKey:@"Pregnancy"] isEqualToString:@""] && [[dataJSON objectForKey:@"Data"] objectForKey:@"Pregnancy"])
                        {
                            [pregnancyString appendString:[[dataJSON objectForKey:@"Data"] objectForKey:@"Pregnancy"]];
                        }
                        else
                        {
                            [pregnancyString appendString:@"No data to display"];
                        }
                    }
                    else
                    {
                        [pregnancyString appendString:@"No data to display"];
                    }
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Warnings"] != [NSNull null])
                    {
                        if(![[[dataJSON objectForKey:@"Data"] objectForKey:@"Warnings"] isEqualToString:@""] && [[dataJSON objectForKey:@"Data"] objectForKey:@"Warnings"])
                        {
                            [boxWarningString appendString:[[dataJSON objectForKey:@"Data"] objectForKey:@"Warnings"]];
                        }
                        else
                        {
                            [boxWarningString appendString:@"No data to display"];
                        }
                    }
                    else
                    {
                        [boxWarningString appendString:@"No data to display"];
                    }
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"Contraindications"] != [NSNull null])
                    {
                        if(![[[dataJSON objectForKey:@"Data"] objectForKey:@"Contraindications"] isEqualToString:@""] && [[dataJSON objectForKey:@"Data"] objectForKey:@"Contraindications"])
                        {
                            [contraindicationsString appendString:[[dataJSON objectForKey:@"Data"] objectForKey:@"Contraindications"]];
                        }
                        else
                        {
                            [contraindicationsString appendString:@"No data to display"];
                        }
                    }
                    else
                    {
                        [contraindicationsString appendString:@"No data to display"];
                    }
                    
                    for(int i = 0; i < [[[dataJSON objectForKey:@"Data"] objectForKey:@"Allergens"] count]; i++)
                    {
                        NSDictionary *disease = [[[dataJSON objectForKey:@"Data"] objectForKey:@"Allergens"] objectAtIndex:i];
                        [allergenString appendString:[NSString stringWithFormat:@"%@",[disease objectForKey:@"ALLERGEN_NAME"]]];
                        if(i != [[[dataJSON objectForKey:@"Data"] objectForKey:@"Allergens"] count] - 1)
                        {
                            [allergenString appendString:@",\n"];
                        }
                    }
                    if([allergenString isEqualToString:@""])
                    {
                        [allergenString appendString:@"No common Allergen found"];
                    }
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"WarningsShort"] != [NSNull null]) //Short Warning Retrieval
                    {
                        if(![[[dataJSON objectForKey:@"Data"] objectForKey:@"WarningsShort"] isEqualToString:@""] && [[dataJSON objectForKey:@"Data"] objectForKey:@"WarningsShort"])
                        {
                            [boxWarningShortString appendString:[[dataJSON objectForKey:@"Data"] objectForKey:@"WarningsShort"]];
                        }
                        else
                        {
                            [boxWarningShortString appendString:@"No data to display"];
                        }
                    }
                    else
                    {
                        [boxWarningShortString appendString:@"No data to display"];
                    }
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"DosageDescription"] != [NSNull null]) //Dosage Administration Retrieval
                    {
                        if(![[[dataJSON objectForKey:@"Data"] objectForKey:@"DosageDescription"] isEqualToString:@""] && [[dataJSON objectForKey:@"Data"] objectForKey:@"DosageDescription"])
                        {
                            [dosageAdminString appendString:[[dataJSON objectForKey:@"Data"] objectForKey:@"DosageDescription"]];
                        }
                        else
                        {
                            [dosageAdminString appendString:@"No data to display"];
                        }
                    }
                    else
                    {
                        [dosageAdminString appendString:@"No data to display"];
                    }
                    
                    if([[dataJSON objectForKey:@"Data"] objectForKey:@"DosageDescriptionShort"] != [NSNull null]) //Dosage Administration Short Retrieval
                    {
                        if(![[[dataJSON objectForKey:@"Data"] objectForKey:@"DosageDescriptionShort"] isEqualToString:@""] && [[dataJSON objectForKey:@"Data"] objectForKey:@"DosageDescriptionShort"])
                        {
                            [dosageAdminShortString appendString:[[dataJSON objectForKey:@"Data"] objectForKey:@"DosageDescriptionShort"]];
                        }
                        else
                        {
                            [dosageAdminShortString appendString:@"No data to display"];
                        }
                    }
                    else
                    {
                        [dosageAdminShortString appendString:@"No data to display"];
                    }

                    [expalanationTableView reloadData];
                });
            }
            else
            {
                NSLog(@"%@",error);
                [[NSNotificationCenter defaultCenter] postNotificationName:kLabelScoresMissing object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray array], @"LABEL_SCORES", nil]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductDetailReceived" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"No data to display", @"DESCRIPTION", @"", @"PRODUCT_IMAGE", @"", @"OVERALL_GRADE", nil]];
            }
        }
    }];
    [dataTask resume];
}

-(NSString*)getGradeForScore:(float)number
{
    if(number >= 1.0f)
    {
        return @"A+";
    }
    else if(number > 0.74 && number < 1)
    {
        return @"A";
    }
    else if(number > 0.49 && number <= 0.74)
    {
        return @"B+";
    }
    else if(number > 0.24 && number <= 49)
    {
        return @"B";
    }
    else if(number > 0.0 && number <= 0.24)
    {
        return @"C";
    }
    else
    {
        return @"D";
    }
}

@end

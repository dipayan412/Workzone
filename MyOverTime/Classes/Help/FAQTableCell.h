//
//  FAQTableCell.h
//  MyOvertime
//
//  Created by Ashif on 6/18/13.
//
//

#import <UIKit/UIKit.h>

@interface FAQTableCell : UITableViewCell

@property (nonatomic, retain) UIWebView *answerTextView;
@property (nonatomic, retain) UITextView *ansView;
@property (nonatomic, assign) int indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndex:(int)_index;
-(void)setAnswerText:(NSString*)_answer;

@end

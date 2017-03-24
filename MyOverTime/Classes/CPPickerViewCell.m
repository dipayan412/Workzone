

#import "CPPickerViewCell.h"

@interface CPPickerViewCell ()

@property (nonatomic, unsafe_unretained) CPPickerView *pickerView;

@end



@implementation CPPickerViewCell

@synthesize pickerView;
@synthesize dataSource, delegate;
@synthesize selectedItem, showGlass, peekInset;
@synthesize currentIndexPath = _currentIndexPath;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CPPickerView *newPickerView = [[CPPickerView alloc] initWithFrame:CGRectMake(0, 20, 112, 30)];
        [self addSubview:newPickerView];
        self.pickerView = newPickerView;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.itemFont = [UIFont boldSystemFontOfSize:14];
        self.pickerView.itemColor = [UIColor blackColor];
        self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin ;

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSInteger position=110;
    
    pickerView.frame= CGRectMake(self.contentView.bounds.size.width-position,self.contentView.bounds.size.height/2-15,112,30);

   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (NSIndexPath *)currentIndexPath {
    if (_currentIndexPath == nil) {
        _currentIndexPath = [(UITableView *)self.superview indexPathForCell:self];
    }
    return _currentIndexPath;
}

#pragma mark External

- (void)reloadData {
    [self.pickerView reloadData];
}

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self.pickerView selectItemAtIndex:index animated:animated];
}

- (NSInteger)selectedItem {
    return [self.pickerView selectedItem];
}

- (void)setShowGlass:(BOOL)doShowGlass {
    self.pickerView.showGlass = doShowGlass;
}

- (BOOL)showGlass {
    return self.pickerView.showGlass;
}

- (void)setPeekInset:(UIEdgeInsets)aPeekInset {
    self.pickerView.peekInset = aPeekInset;
}

- (UIEdgeInsets)peekInset {
    return self.pickerView.peekInset;
}

#pragma mark CPPickerView Delegate

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item {
    if ([self.delegate respondsToSelector:@selector(pickerViewAtIndexPath:didSelectItem:)]) {
        [self.delegate pickerViewAtIndexPath:self.currentIndexPath didSelectItem:item];
    }
}

#pragma mark CPPickerView Datasource

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView {
    NSInteger numberOfItems = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInPickerViewAtIndexPath:)]) {
        numberOfItems = [self.dataSource numberOfItemsInPickerViewAtIndexPath:self.currentIndexPath];
    }
    
    return numberOfItems;
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item {
    NSString *title = nil;
    if ([self.dataSource respondsToSelector:@selector(pickerViewAtIndexPath:titleForItem:)])
    {
        title = [self.dataSource pickerViewAtIndexPath:self.currentIndexPath titleForItem:item];
    }
    
    return title;
}

#pragma mark Custom getters/setters

@end

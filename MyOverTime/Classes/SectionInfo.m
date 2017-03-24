
#import "SectionInfo.h"
#import "SectionHeaderView.h"

@implementation SectionInfo

@synthesize open, rowHeights, headerView;

-(id)init
{
	if (self = [super init])
    {
		rowHeights = [[NSMutableArray alloc] init];
	}
	return self;
}


- (NSUInteger)countOfRowHeights
{
	return [rowHeights count];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)idx
{
	return [rowHeights objectAtIndex:idx];
}

- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx
{
//	[rowHeights insertObject:anObject atIndex:idx];
    [rowHeights addObject:anObject];
}

- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes
{
	[rowHeights insertObjects:rowHeightArray atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx
{
	[rowHeights removeObjectAtIndex:idx];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes
{
	[rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject
{
	[rowHeights replaceObjectAtIndex:idx withObject:anObject];
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray
{
	[rowHeights replaceObjectsAtIndexes:indexes withObjects:rowHeightArray];
}

@end

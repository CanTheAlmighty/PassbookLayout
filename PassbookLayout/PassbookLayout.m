//
//  PassbookLayout.m
//  Passbooks
//
//  Created by Jose Luis Canepa on 3/3/14.
//  Copyright (c) 2014 Jose Luis Canepa. All rights reserved.
//

#import "PassbookLayout.h"

@implementation PassbookLayout

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self useDefaultMetricsAndInvalidate:NO];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    if (self)
    {
        [self useDefaultMetricsAndInvalidate:NO];
    }
    
    return self;
}

- (void)useDefaultMetricsAndInvalidate:(BOOL)invalidate
{
    PassbookLayoutMetrics m;
    
    m.normal.size       = CGSizeMake(320.0, 320.0);
    m.normal.overlap    = 0.0;
    m.collapsed.size    = CGSizeMake(320.0, 48.0);
    m.collapsed.overlap = 4.0;
    m.inheritance       = 0.10;
    
    _metrics = m;
    
    if (invalidate) [self invalidateLayout];
}

- (void)useDefaultMetrics
{
    [self useDefaultMetricsAndInvalidate:YES];
}

#pragma mark - Layout

- (void)prepareLayout
{
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame  = frameForPassAtIndex(indexPath, self.collectionView.bounds, _metrics);
    attributes.zIndex = zIndexForPassAtIndex(indexPath);
    
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self.collectionView numberOfItemsInSection:0]];
    
    for (NSInteger i=0; i < [self.collectionView numberOfItemsInSection:0]; i++)
    {
        array[i] = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    return array;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, 1000.0);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - Postioning

#pragma mark Cell positioning

CGRect frameForPassAtIndex(NSIndexPath *indexPath, CGRect b, PassbookLayoutMetrics m)
{
    CGRect f;
    
    f.origin.x = (b.size.width - m.normal.size.width) / 2.0;
    f.origin.y = indexPath.item * (m.collapsed.size.height - m.collapsed.overlap);
    
    // The default size is the normal size
    f.size = m.collapsed.size;
    
    // Bouncy effect on top (works only on constant invalidation)
    // Commenting this disables all top animations
    if (b.origin.y < 0 && m.inheritance > 0.0)
    {
        if (indexPath.section == 0 && indexPath.item == 0)
        {
            // Keep stuck at top
            f.origin.y      = b.origin.y;
            f.size.height   = m.collapsed.size.height - b.origin.y * (1 + m.inheritance);
            
            NSLog(@"%.2f", f.size.height);
        }
        else
        {
            // Displace in stepping amounts factored by resitatnce
            f.origin.y     -= b.origin.y * indexPath.item * m.inheritance;
            f.size.height  -= b.origin.y * m.inheritance;
        }
    }
    
    return f;
}

#pragma mark z-index

NSInteger zIndexForPassAtIndex(NSIndexPath *indexPath)
{
    return indexPath.item;
}

#pragma mark - Accessors

- (void)setMetrics:(PassbookLayoutMetrics)metrics
{
    _metrics = metrics;
    
    [self invalidateLayout];
}

@end

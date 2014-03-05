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
    PassbookLayoutEffects e;
    
    m.normal.size       = CGSizeMake(320.0, 320.0);
    m.normal.overlap    = 0.0;
    m.collapsed.size    = CGSizeMake(320.0, 96.0);
    m.collapsed.overlap = 32.0;
    
    e.inheritance       = 0.10;
    e.sticksTop         = YES;
    e.bouncesTop        = YES;
    
    _metrics = m;
    _effects = e;
    
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
    
    attributes.frame  = frameForPassAtIndex(indexPath, self.collectionView.bounds, _metrics, _effects);
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

CGRect frameForPassAtIndex(NSIndexPath *indexPath, CGRect b, PassbookLayoutMetrics m, PassbookLayoutEffects e)
{
    CGRect f;
    
    f.origin.x = (b.size.width - m.normal.size.width) / 2.0;
    f.origin.y = indexPath.item * (m.collapsed.size.height - m.collapsed.overlap);
    
    // The default size is the normal size
    f.size = m.collapsed.size;
    
    if (b.origin.y < 0 && e.inheritance > 0.0 && e.bouncesTop)
    {
        // Bouncy effect on top (works only on constant invalidation)
        if (indexPath.section == 0 && indexPath.item == 0)
        {
            // Keep stuck at top
            f.origin.y      = b.origin.y * e.inheritance/2.0;
            f.size.height   = m.collapsed.size.height - b.origin.y * (1 + e.inheritance);
            
            NSLog(@"%.2f", f.size.height);
        }
        else
        {
            // Displace in stepping amounts factored by resitatnce
            f.origin.y     -= b.origin.y * indexPath.item * e.inheritance;
            f.size.height  -= b.origin.y * e.inheritance;
        }
    }
    else if (b.origin.y > 0)
    {
        // Stick to top
        if (f.origin.y < b.origin.y && e.sticksTop)
        {
            f.origin.y = b.origin.y;
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

- (void)setEffects:(PassbookLayoutEffects)effects
{
    _effects = effects;
    
    [self invalidateLayout];
}

@end

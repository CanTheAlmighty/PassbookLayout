//
//  PassbookLayout.m
//  Passbooks
//
//  Created by Jose Luis Canepa on 3/3/14.
//  Copyright (c) 2014 Jose Luis Canepa. All rights reserved.
//

#import "PassbookLayout.h"

@interface PassbookLayout ()
{
}
@end

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
    
    m.normal.size       = CGSizeMake(320.0, 420.0);
    m.normal.overlap    = 0.0;
    m.collapsed.size    = CGSizeMake(320.0, 96.0);
    m.collapsed.overlap = 32.0;
    
    m.bottomStackedHeight = 8.0;
    m.bottomStackedTotalHeight = 32.0;
    
    e.inheritance       = 0.20;
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
    // Ain't Nobody Here but Us Chickens
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSArray *selectedIndexPaths = [self.collectionView indexPathsForSelectedItems];
    
    if (selectedIndexPaths.count && [(NSIndexPath*)selectedIndexPaths[0] isEqual:indexPath])
    {
        // Layout selected cell (normal size)
        attributes.frame  = frameForSelectedPass(self.collectionView.bounds, _metrics);
    }
    else if (selectedIndexPaths.count)
    {
        // Layout unselected cell (bottom-stuck)
        attributes.frame  = frameForUnselectedPass(indexPath, selectedIndexPaths[0], self.collectionView.bounds, _metrics);
    }
    else
    {
        // Layout collapsed cells (collapsed size)
        BOOL isLast = (indexPath.item == ([self.collectionView numberOfItemsInSection:indexPath.section]-1));
        attributes.frame  = frameForPassAtIndex(indexPath, isLast, self.collectionView.bounds, _metrics, _effects);
    }
    
    attributes.zIndex = zIndexForPassAtIndex(indexPath);
        
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSRange range = rangeForVisibleCells(rect, [self.collectionView numberOfItemsInSection:0] , _metrics);
    
    // Uncomment to see the current range
    //NSLog(@"Visible range: %@", NSStringFromRange(range));
    
    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:range.length];
    
    for (NSUInteger index=0,item=range.location; item < (range.location + range.length); item++, index++)
    {
        cells[index] = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
    }
    
    return cells;
}

- (CGSize)collectionViewContentSize
{
    return collectionViewSize(self.collectionView.bounds, [self.collectionView numberOfItemsInSection:0], _metrics);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark - Postioning

#pragma mark Cell visibility

NSRange rangeForVisibleCells(CGRect rect, NSInteger count, PassbookLayoutMetrics m)
{
    NSInteger min = floor(rect.origin.y                     / (m.collapsed.size.height - m.collapsed.overlap));
    NSInteger max = ceil((rect.origin.y + rect.size.height) / (m.collapsed.size.height - m.collapsed.overlap));
    
    max = (max > count) ? count : max;
    
    min = (min < 0)     ? 0   : min;
    min = (min < max)   ? min : max;
    
    NSRange r = NSMakeRange(min, max-min);
    
    return r;
}

CGSize collectionViewSize(CGRect bounds, NSInteger count, PassbookLayoutMetrics m)
{
    return CGSizeMake(bounds.size.width, count * (m.collapsed.size.height - m.collapsed.overlap));
}

#pragma mark Cell positioning

/// Normal collapsed cell, with bouncy animations on top
CGRect frameForPassAtIndex(NSIndexPath *indexPath, BOOL isLastCell, CGRect b, PassbookLayoutMetrics m, PassbookLayoutEffects e)
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
    
    // Edge case, if it's the last cell, display in full height, to avoid any issues.
    if (isLastCell)
    {
        f.size = m.normal.size;
    }
    
    return f;
}

/// Centered cell
CGRect frameForSelectedPass(CGRect b, PassbookLayoutMetrics m)
{
    CGRect f;
    
    f.size      = m.normal.size;
    f.origin.x  =              (b.size.width  - f.size.width ) / 2.0;
    f.origin.y  = b.origin.y + (b.size.height - f.size.height) / 2.0;
    
    return f;
}

/// Bottom-stack cell
CGRect frameForUnselectedPass(NSIndexPath *indexPath, NSIndexPath *indexPathSelected, CGRect b, PassbookLayoutMetrics m)
{
    CGRect f;
    
    f.size        = m.collapsed.size;
    f.origin.x    = (b.size.width - m.normal.size.width) / 2.0;
    f.origin.y    = b.origin.y + b.size.height - m.bottomStackedTotalHeight + m.bottomStackedHeight*(indexPath.item - indexPathSelected.item);
    
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

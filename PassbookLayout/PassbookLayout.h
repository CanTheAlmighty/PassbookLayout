//
//  PassbookLayout.h
//  Passbooks
//
//  Created by Jose Luis Canepa on 3/3/14.
//  Copyright (c) 2014 Jose Luis Canepa. All rights reserved.
//

#import <UIKit/UIKit.h>

struct PassMetrics
{
    /// Size of a state of a pass
    CGSize size;
    
    /// Amount of "pixels" of overlap between this pass and others.
    CGFloat overlap;
};

typedef struct
{
    /// Normal is the real size of the pass, the "full screen" display of it.
    struct PassMetrics normal;
    
    /// Collapsed is when
    struct PassMetrics collapsed;
    
    /// How much of the pulling is translated into movement on the top. An inheritance of 0 disables this feature
    CGFloat inheritance;
    
    BOOL bouncesTop;
    
}PassbookLayoutMetrics;

@interface PassbookLayout : UICollectionViewLayout

@property (nonatomic,assign) PassbookLayoutMetrics metrics;

/// Resets to the default metrics
- (void)useDefaultMetrics;

@end

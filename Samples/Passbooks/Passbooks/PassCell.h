//
//  PassCell.h
//  Passbooks
//
//  Created by Jose Luis Canepa on 3/3/14.
//  Copyright (c) 2014 Jose Luis Canepa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PassCellStyleRed,
    PassCellStyleBlue,
    PassCellStyleIve,
    
    PassCellStyleCount,
}PassCellStyle;

@interface PassCell : UICollectionViewCell

- (void)setStyle:(PassCellStyle)style;

@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UILabel *labelTitle;
@property (nonatomic,weak) IBOutlet UILabel *labelSubtitle;

@end

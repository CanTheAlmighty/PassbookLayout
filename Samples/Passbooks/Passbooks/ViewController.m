//
//  ViewController.m
//  Passbooks
//
//  Created by Jose Luis Canepa on 3/3/14.
//  Copyright (c) 2014 Jose Luis Canepa. All rights reserved.
//

#import "ViewController.h"

#import "PassbookLayout.h"
#import "PassCell.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"PassCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"pass"];
}

#pragma mark (Dis)Appear

- (void)viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pass" forIndexPath:indexPath];
    
    [cell setStyle:indexPath.item % PassCellStyleCount];
    
    return cell;
}

#pragma mark - UIScrollView delegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [[(UICollectionView*)scrollView collectionViewLayout] invalidateLayout];
//}

#pragma mark - Miscellaneous

#pragma mark Status Bar color
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}

@end

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
    return 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pass" forIndexPath:indexPath];
    
    [cell setStyle:indexPath.item % PassCellStyleCount];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Alternates selection. Deselects all selected cells, and if there's none, it just accepts the selection
    BOOL shouldSelect = YES;
    
    for (NSIndexPath *indexPath in [collectionView indexPathsForSelectedItems])
    {
        // Freaking collection views, you need to tell it that the thing got deselected
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
        shouldSelect = NO;
    }
    
    return shouldSelect;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView performBatchUpdates:nil completion:nil];
    [collectionView setScrollEnabled:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView performBatchUpdates:nil completion:nil];
    [collectionView setScrollEnabled:NO];
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

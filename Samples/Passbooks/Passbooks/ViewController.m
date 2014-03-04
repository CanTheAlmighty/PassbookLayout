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
    [self.collectionView registerClass:[PassCell class] forCellWithReuseIdentifier:@"pass"];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pass" forIndexPath:indexPath];
    
    cell.backgroundColor = indexPath.item % 2 ? [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0] : [UIColor colorWithRed:0.0 green:0.0 blue:0.7 alpha:1.0] ;
    
    return cell;
}

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

//
//  RootViewControlleriPad.h
//  QuickCrypt
//
//  Created by build on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewControlleriPad;
@class DetailViewController;

//@protocol RootViewControllerDelegate <NSObject>
//
//@required
//- (void)rootViewController
//
//@end

@interface RootViewControlleriPad : UITableViewController
{
    DetailViewController *detailViewController;
    UIScrollView *detailScrollView;
    NSArray *aryCryptoMethods;
}

@property (nonatomic, strong) DetailViewController *detailViewController;   // The detail view controller, where most the goods are
@property (nonatomic, strong) UIScrollView *detailScrollView;               // Scrollview to contain detailview
@property (nonatomic, strong) NSArray *aryCryptoMethods;                    // Array of the different cryptomethods supported

@end

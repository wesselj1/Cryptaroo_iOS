//
//  AppDelegate.h
//  QuickCrypt
//
//  Created by build on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewControlleriPad;
@class RootViewControlleriPhone;
@class DetailViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UISplitViewController *splitViewController;           // The app's split view controller
@property (strong, nonatomic) RootViewControlleriPad *rootViewControlleriPad;       // RootViewController for the iPad
@property (strong, nonatomic) RootViewControlleriPhone *rootViewControlleriPhone;   // RootViewController for the iPhone/iPod
@property (strong, nonatomic) DetailViewController *detailViewController;           // The detail view for iPad
@property (strong, nonatomic) TextData *textData;                                   // Persistant data object for text and options
@property (strong, nonatomic) UIToolbar *toolbar;                                   // Toolbar displayed above the iPad app
@property (strong, nonatomic) UILabel *toolbarTitle;                                // Label displayed on the iPad toolbar

natural_t freeMemory();
void print_free_memory();

@end

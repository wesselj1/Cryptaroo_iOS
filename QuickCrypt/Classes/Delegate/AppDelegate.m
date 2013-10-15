//
//  AppDelegate.m
//  Cryptaroo
//
//  Created by build on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewControlleriPhone.h"
#import "RootViewControlleriPad.h"
#import "DetailViewController.h"
#import "InfoViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize splitViewController = _splitViewController;
@synthesize rootViewControlleriPhone = _rootViewControlleriPhone;
@synthesize rootViewControlleriPad = _rootViewControlleriPad;
@synthesize detailViewController = _detailViewController;
@synthesize textData = _textData;
@synthesize toolbar = _toolbar;
@synthesize toolbarTitle = _toolbarTitle;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // If the user is using an iPad device
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
    {
        // Initialize the app's split, root, and detail views.
        self.splitViewController = [[UISplitViewController alloc] init];
        self.rootViewControlleriPad = [[RootViewControlleriPad alloc] init];
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView1" bundle:nil]; // Default view (Frequency Count) uses DetailView1
        _detailViewController.rootViewController = _rootViewControlleriPad;
        _rootViewControlleriPad.detailViewController = _detailViewController;
        
        UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:_rootViewControlleriPad];
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:_detailViewController];
        
        // Set the Root and Detail views
//        self.splitViewController.masterViewController = self.rootViewControlleriPad;
//        self.rootViewControlleriPad.detailViewController = self.detailViewController;
        self.splitViewController.viewControllers = @[rootNav, detailNav];
        self.splitViewController.delegate = _detailViewController;
    
        // Allocate and set navigation controller
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_detailViewController];
//        self.detailViewController.navController = navController;
        
        // Add the root controller and detail navigation controller to the splitview
//        self.splitViewController.viewControllers = [NSArray arrayWithObjects:_rootViewControlleriPad, navController, nil];
//        self.splitViewController.delegate = _detailViewController;
        self.detailViewController.splitViewController = self.splitViewController; // Set detail view's pointer to the split view

        
        // Setup the toolbar title label and add as a subview on the toolbar
//        _toolbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 30)];
//        _toolbarTitle.center = self.splitViewController.toolbar.center;
//        _toolbarTitle.textColor = [UIColor whiteColor];
//        _toolbarTitle.backgroundColor = [UIColor clearColor];
//        _toolbarTitle.textAlignment = NSTextAlignmentCenter;
//        _toolbarTitle.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
//        _toolbarTitle.font = [UIFont boldSystemFontOfSize:20];
//        [self setToolbarLabelTitleForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//        [self.splitViewController.toolbar addSubview:_toolbarTitle];
        if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
            
        }
//        self.splitViewController.toolbar.translucent = NO;
        self.splitViewController.navigationController.navigationBar.translucent = NO;
        
        
        // Finally, set the window's rootViewController to be splitViewController
        self.window.rootViewController = _splitViewController;
    }
    else
    {   // Else, if the user is using an iPhone/iPod device
        
        // Setup the rootViewController and navController
        self.rootViewControlleriPhone = [[RootViewControlleriPhone alloc] init];
        self.navController = [[UINavigationController alloc] initWithRootViewController:_rootViewControlleriPhone];
        self.window.rootViewController = self.navController;
    }
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        self.window.tintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
 
    [self.window makeKeyAndVisible];
    
//    // initialize defaults
//    NSString *dateKey = @"dateKey";
//    NSDate *lastRead = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
//    if (lastRead == nil)     // App first run: set up user defaults.
//    {
//        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
//        
//        // do any other initialization you want to do here - e.g. the starting default values.    
//        // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"should_play_sounds"];
//        
//        // sync the defaults to disk
//        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    
    
    // Create instance of persitent text data class
    _textData = [[TextData alloc] init];

    return YES;
}

// When the help button is pressed
- (void)helpButtonPressed
{
    // Grab the current cell (used to know which help blurb to display)
    UITableViewCell *cell = [_rootViewControlleriPad.tableView cellForRowAtIndexPath:_rootViewControlleriPad.tableView.indexPathForSelectedRow];
    
    // Get the array of help blurbs from the plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HelpInfo" ofType:@"plist"];
    NSDictionary *helpDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *helpArray = [NSArray arrayWithArray:[helpDict valueForKey:@"QCHelpStrings"]];
    
    // Display the help blurb appropriate to the cryptomethod currently in view
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cell.textLabel.text message:[helpArray objectAtIndex:_detailViewController.cryptoMethod] delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
    [alert show];
}

@end

//
//  CAIAppDelegate.m
//  Cryptaroo
//
//  Created by build on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CAIAppDelegate.h"
#import "RootViewControlleriPhone.h"
#import "RootViewControlleriPad.h"
#import "DetailViewController.h"
#import "InfoViewController.h"

@implementation CAIAppDelegate

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
    // Set Navigation and Toolbar appearance to be grayish black color
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:.25 alpha:1]];
    [[UIToolbar appearance] setTintColor:[UIColor colorWithWhite:.25 alpha:1]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // If the user is using an iPad device
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
    {
        // Initialize the app's split, root, and detail views.
        self.splitViewController = [[MGSplitViewController alloc] init];
        self.rootViewControlleriPad = [[RootViewControlleriPad alloc] init];
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView1" bundle:nil]; // Default view (Frequency Count) uses DetailView1
        
        // Set the Root and Detail views
        self.splitViewController.masterViewController = self.rootViewControlleriPad;
        self.rootViewControlleriPad.detailViewController = self.detailViewController;
    
        // Allocate and set navigation controller
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_detailViewController];
        self.detailViewController.navController = navController;
        
        // Add the root controller and detail navigation controller to the splitview
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:_rootViewControlleriPad, navController, nil];
        self.splitViewController.delegate = _detailViewController;
        self.detailViewController.splitViewController = self.splitViewController; // Set detail view's pointer to the split view
        
        // Setup splitview's menu button
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.splitViewController action:@selector(showMasterPopover:)];
        self.splitViewController.menuButton = menuButton;
        
        
        // Create an info/about button
        UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
        infoBtn.frame = CGRectMake(0, 0, 20, 20);
        UIBarButtonItem *infoBtnA = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
        [infoBtn addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.splitViewController._infoBtn = infoBtnA;
        
        // Create a help button
        UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        helpButton.frame = CGRectMake(0, 0, 20, 20);
        [helpButton setImage:[UIImage imageNamed:@"UIButtonBarHelp2.png"] forState:UIControlStateNormal];
        helpButton.showsTouchWhenHighlighted = YES;
        [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *helpButtonA = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
        self.splitViewController._helpBtn = helpButtonA;
        
        // Create a flexibleSpace for between the menu button and the help and info buttons
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.splitViewController._flexSpace = flexSpace;

        
        // Setup the toolbar title label and add as a subview on the toolbar
        _toolbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 30)];
        _toolbarTitle.center = self.splitViewController.toolbar.center;
        _toolbarTitle.textColor = [UIColor whiteColor];
        _toolbarTitle.backgroundColor = [UIColor clearColor];
        _toolbarTitle.textAlignment = UITextAlignmentCenter;
        _toolbarTitle.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        _toolbarTitle.font = [UIFont boldSystemFontOfSize:20];
        [self setToolbarLabelTitleForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        [self.splitViewController.toolbar addSubview:_toolbarTitle];
        
        
        // Finally, set the window's rootViewController to be splitViewController
        self.window.rootViewController = _splitViewController;
    }
    else
    {   // Else, if the user is using an iPHone/iPod device
        
        // Setup the rootViewController and navController
        self.rootViewControlleriPhone = [[RootViewControlleriPhone alloc] init];
        self.navController = [[UINavigationController alloc] initWithRootViewController:_rootViewControlleriPhone];
        self.window.rootViewController = self.navController;
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

// Set the toolbar title dependent on device orientation (for iPad)
- (void)setToolbarLabelTitleForOrientation:(UIInterfaceOrientation)orientation
{
    // Grab the currently selected cell (used to get the title of currentview
    UITableViewCell *cell = [_rootViewControlleriPad.tableView cellForRowAtIndexPath:_rootViewControlleriPad.tableView.indexPathForSelectedRow];
    if( UIDeviceOrientationIsPortrait(orientation) )
    {   
        // If the device is in portrait the master view will be hidden so add the label of the current method to the label
        _toolbarTitle.text = [NSString stringWithFormat:@"Cryptaroo - %@", cell.textLabel.text];
    }
    else
    {   // If in landscape just set the title to Cryptaroo
        _toolbarTitle.text = @"Cryptaroo";
    }
}


// When the info/about button is pressed
- (void)infoButtonPressed
{   // Create the info popover view and display it
    InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    [_splitViewController displayInfoPopover:infoViewController];
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

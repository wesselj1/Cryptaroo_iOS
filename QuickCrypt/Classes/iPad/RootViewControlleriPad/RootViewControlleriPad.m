//
//  RootViewControlleriPad.m
//  QuickCrypt
//
//  Created by build on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewControlleriPad.h"
#import "DetailViewController.h"
#import "KSCustomPopoverBackgroundView.h"
#import "MGSplitViewController.h"
#import "AppDelegate.h"
#import "InfoViewController.h"

@interface RootViewControlleriPad ()

@property (nonatomic, strong) MGSplitViewController *splitViewController;   // Reference to the splitViewController
@property (nonatomic, strong) AppDelegate *appDelegate;                  // Reference to our application delegate

@end

@implementation RootViewControlleriPad

@synthesize detailViewController = _detailViewController;
@synthesize detailScrollView = _detailScrollView;
@synthesize aryCryptoMethods = _aryCryptoMethods;
@synthesize splitViewController = _splitViewController;
@synthesize appDelegate = _appDelegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get a referece to our application delegate
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navigationController.navigationBar.translucent = NO;
    super.title = @"CRYPTAROO"; // Set the title of the view
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont: [[Fonts fontManager] fairviewRegularWithFontSize:30.0],
                                                           UITextAttributeTextColor: [UIColor whiteColor],
                                                           UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)]}];
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:2.0 forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = NO;
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255/255.0 green:190/255.0 blue:100/255.0 alpha:1.0]];
    } else {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:255/255.0 green:190/255.0 blue:100/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-2.0 forBarMetrics:UIBarMetricsDefault];
    }
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }

    // Array of current cryptology methods
    _aryCryptoMethods = [NSArray arrayWithObjects:@"FREQUENCY COUNT",
                        @"RUN THE ALPHABET",
                        @"BIGRAPHS",
                        @"TRIGRAPHS",
                        @"NGRAPHS",
                        @"AFFINE KNOWN PLAINTEXT ATTACK",
                        @"AFFINE ENCIPHER",
                        @"AFFINE DECIPHER",
                        @"SPLIT OFF ALPHABETS",
                        @"POLY/MONO CALCULATOR",
                        @"VIGENÈRE ENCIPHER",
                        @"VIGENÈRE DECIPHER",
                        @"AUTOKEY CYPHERTEXT ATTACK",
                        @"AUTOKEY PLAINTEXT ATTACK",
                        @"AUTOKEY DECIPHER",
                        @"GCD AND INVERSE",
                        nil];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.scrollEnabled = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 704.0); // Size for the view when in popover
    
    self.tableView.separatorColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated
{   // Default to selecting the first row in the table view
    if( !self.tableView.indexPathForSelectedRow )
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    [_appDelegate setToolbarLabelTitleForOrientation:toInterfaceOrientation];               // Set the toolbar title for the new orientation
//    [_appDelegate.splitViewController._infoPopoverController dismissPopoverAnimated:NO];    // Dismiss the info popover if shown
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // The tableview should only be scrollable if in portrait, because the current number of methods conveniently happens to fit perfectly in landscape
    if( UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) )
        self.tableView.scrollEnabled = NO;
    else
        self.tableView.scrollEnabled = NO;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryCryptoMethods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if( cell == nil )
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Configure the cell labels
        UILabel *label;
        UIFont *font = [[Fonts fontManager] fairview_regular];
        UIColor *color1 = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0];
        UIColor *color2 = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        UIColor *color3 = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
        UIColor *color4 = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
        UIColor *color5 = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        
        for( int i = 1; i < 6; i++ )
        {
            label = (UILabel *)[cell viewWithTag:i];
            label.font = font;
            
            switch (i) {
                case 1:
                    label.textColor = color1;
                    break;
                case 2:
                    label.textColor = color2;
                    break;
                case 3:
                    label.textColor = color3;
                    break;
                case 4:
                    label.textColor = color4;
                    break;
                case 5:
                    label.textColor = color5;
                    break;
                default:
                    break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        //        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.bounds.size.width, 1)];
        //        lineView.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
        //        [cell addSubview:lineView];
    }
    
    // Set title
    UILabel *label;
    NSString *title = [_aryCryptoMethods objectAtIndex:indexPath.row];
    for( int i = 1; i < 6; i++ )
    {
        label = (UILabel *)[cell viewWithTag:i];
        label.text = title;
    }
    
    return cell;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_detailViewController.navigationController popToRootViewControllerAnimated:NO];   // Pop off views to the initial root view
    DetailViewController *d1;   // A detail view controller to be loaded
    
    /* For whatever row is selected display a detail view controller with the nib that contains
       the appropriate option set for that crypto method */
    switch( indexPath.row )
    {
        case QCFrequencyCount:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView1" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCRunTheAlphabet:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView1" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCBiGraphs:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView1" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCTriGraphs:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView1" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCNGraphs:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView2" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCAffineKnownPlaintextAttack:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView3" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCAffineEncipher:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView4" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCAffineDecipher:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView4" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCSplitOffAlphabets:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView2" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCPolyMonoCalculator:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView2" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCViginereEncipher:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView5" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCViginereDecipher:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView5" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCAutokeyCyphertextAttack:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView2" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCAutokeyPlaintextAttack:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView6" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCAutokeyDecipher:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView3" bundle:nil cryptoMethod:indexPath.row];
            break;
        case QCGCDAndInverse:
            d1 = [[DetailViewController alloc] initWithNibName:@"DetailView7" bundle:nil cryptoMethod:indexPath.row];
        default:
            break;
    }
    
    
    // Dismiss the master popover (if displayed) and push on the detail view
    [_detailViewController.popoverController dismissPopoverAnimated:YES];
    if ( indexPath.row != QCFrequencyCount ) {
        if( _detailViewController.menuButton != nil ) {
            d1.menuButton = _detailViewController.menuButton;
        } else {
            UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.splitViewController action:@selector(toggleMasterVisible:)];
            d1.menuButton = menuButton;
        }
        d1.methodTitle = _aryCryptoMethods[indexPath.row];
        [_detailViewController.navigationController pushViewController:d1 animated:NO];
    }
    
    //[self.splitViewController.view setNeedsLayout];
    
    // Set the toolbar title for the new detail view
//    [_appDelegate setToolbarLabelTitleForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

@end

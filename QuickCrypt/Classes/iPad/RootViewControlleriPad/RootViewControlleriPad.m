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
{
}
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

    // Array of current cryptology methods supported by app (used to populate the table view
    _aryCryptoMethods = [NSArray arrayWithObjects:@"Frequency Count",
                        @"Run The Alphabet",
                        @"BiGraphs",
                        @"TriGraphs",
                        @"NGraphs",
                        @"Affine Known Plaintext Attack",
                        @"Affine Encipher",
                        @"Affine Decipher",
                        @"Split Off Alphabets",
                        @"Poly/Mono Calculator",
                        @"Viginere Encipher",
                        @"Viginere Decipher",
                        @"Autokey Cyphertext Attack",
                        @"Autokey Plaintext Attack",
                        @"Autokey Decipher",
                        @"GCD and Inverse",
                        nil];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.scrollEnabled = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 704.0); // Size for the view when in popover
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
    [_appDelegate setToolbarLabelTitleForOrientation:toInterfaceOrientation];               // Set the toolbar title for the new orientation
    [_appDelegate.splitViewController._infoPopoverController dismissPopoverAnimated:NO];    // Dismiss the info popover if shown
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cell.tag = indexPath.row;
    cell.textLabel.text = [_aryCryptoMethods objectAtIndex:indexPath.row];  // Set row text according to the array of methods
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_detailViewController.navController popToRootViewControllerAnimated:NO];   // Pop off views to the initial root view
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
    [_detailViewController.navController pushViewController:d1 animated:NO];
    
    //[self.splitViewController.view setNeedsLayout];
    
    // Set the toolbar title for the new detail view
    [_appDelegate setToolbarLabelTitleForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

@end

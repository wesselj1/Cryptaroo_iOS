//
//  RootViewControlleriPhone.m
//  QuickCrypt
//
//  Created by build on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewControlleriPhone.h"
#import "CryptToolViewController.h"
#import "GCDandInverseViewController.h"
#import "InfoViewController.h"
#import "Fonts.h"

@interface RootViewControlleriPhone ()

- (void)infoButtonPressed; // Called when info button is pressed

@end

@implementation RootViewControlleriPhone

@synthesize tableView = _tableView;
@synthesize aryCryptoMethods = _aryCryptoMethods;

- (id)init
{
    self = [super initWithNibName:@"RootViewControlleriPhone" bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    super.title = @"CRYPTAROO"; // Set the title of the view
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont: [[Fonts fontManager] fairviewRegularWithFontSize:30.0],
                          UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)]}];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-2.0 forBarMetrics:UIBarMetricsDefault];
    
    // All of our supported crypto methods
    aryCryptoMethods = [NSArray arrayWithObjects:@"FREQUENCY COUNT",
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
    
    // Set the back button for the navbar
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [back setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"Fairview-SmallCaps" size:20.0],
                                   UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]}
                        forState:UIControlStateNormal];
    [self.navigationItem setBackBarButtonItem:back];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:245/255.0 green:161/255.0 blue:60/255.0 alpha:1.0]];
    
    // Create the info button
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoBtn addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 10.0f;
    self.navigationItem.rightBarButtonItems = @[space, infoBarButtonItem];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryCryptoMethods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // Create a cell for each of the supported crypto methods
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"Cell"];
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
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
        [cell addSubview:lineView];
    }

    // Set title
    UILabel *label;
    NSString *title = [aryCryptoMethods objectAtIndex:indexPath.row];
    for( int i = 1; i < 6; i++ )
    {
        if( i == 1 )
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.view.bounds.size.width, 1)];
            lineView.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
            [cell addSubview:lineView];
        }
        label = (UILabel *)[cell viewWithTag:i];
        label.text = title;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCDandInverseViewController *GCDviewController;
    CryptToolViewController *cryptToolViewController;
    
    if( indexPath.row == QCGCDAndInverse )
    {   // If they select GCD and Inverse create and push a GCDViewController
        GCDviewController = [[GCDandInverseViewController alloc] init];
        GCDviewController.title = [aryCryptoMethods objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:GCDviewController animated:YES];
    }
    else
    {   // For every other row, load a crypto tool view
        cryptToolViewController = [[CryptToolViewController alloc] initWithCryptoType:indexPath.row];
        cryptToolViewController.title = [aryCryptoMethods objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:cryptToolViewController animated:YES];
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)infoButtonPressed
{   // When the info button is pressed, push the infoViewController on screen
    InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    [self.navigationController pushViewController:infoViewController animated:YES];
}

@end

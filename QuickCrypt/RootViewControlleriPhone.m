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

@interface RootViewControlleriPhone ()

- (void)infoButtonPressed;

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
    
    super.title = @"Cryptaroo";
    
    aryCryptoMethods = [NSArray arrayWithObjects:@"Frequency Count",
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
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:back];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    [infoBtn addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
{
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cell.tag = indexPath.row;
    cell.textLabel.text = [aryCryptoMethods objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCDandInverseViewController *GCDviewController;
    CryptToolViewController *cryptToolViewController;
    
    if( indexPath.row == QCGCDAndInverse )
    {
        GCDviewController = [[GCDandInverseViewController alloc] init];
        GCDviewController.title = [aryCryptoMethods objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:GCDviewController animated:YES];
    }
    else
    {
        cryptToolViewController = [[CryptToolViewController alloc] initWithCryptoType:indexPath.row];
        cryptToolViewController.title = [aryCryptoMethods objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:cryptToolViewController animated:YES];
    }
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)infoButtonPressed
{
    InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    [self.navigationController pushViewController:infoViewController animated:YES];
}

@end

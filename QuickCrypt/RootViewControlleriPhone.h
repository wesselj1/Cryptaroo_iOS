//
//  RootViewControlleriPhone.h
//  QuickCrypt
//
//  Created by build on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewControlleriPhone : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableView;    // The main menu's table view
    NSArray *aryCryptoMethods;          // The cryptop method's supported
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *aryCryptoMethods;

@end

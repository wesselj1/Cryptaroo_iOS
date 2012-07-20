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
    IBOutlet UITableView *tableView;
    NSArray *aryCryptoMethods;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *aryCryptoMethods;

@end

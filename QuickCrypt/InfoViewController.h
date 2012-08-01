//
//  InfoViewController.h
//  QuickCrypt
//
//  Created by build on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
{
    IBOutlet UITextView *textView;  // TextView where information about the app is displayed
}

@property (nonatomic, strong) UITextView *textView;

@end

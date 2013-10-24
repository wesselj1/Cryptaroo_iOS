//
//  GCDandInverseViewControllerViewController.h
//  QuickCrypt
//
//  Created by build on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoneCancelNumberPadToolbar.h"
#import "HelpViewController.h"

@interface GCDandInverseViewController : UIViewController <HelpViewControllerDelegate, DoneCancelNumberPadToolbarDelegate>
{
    IBOutlet UITextField *inverseOfField;   // Field for the integer of which the inverse is desired
    IBOutlet UITextField *modField;         // Field for the modulus the user would like to use
    IBOutlet UILabel *label1;               // Labels used for view
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *label4;
    IBOutlet UITextField *gcd;              // Field for the resulting greatest common denominator of given integer and mod
    IBOutlet UITextField *inverse;          // Field for the resulting inverse of the given integer in the modulus given
    IBOutlet UIButton *calculate;           // The calculate button to get inverse and gcd
}

@property (nonatomic, strong) UITextField *inverseOfField;
@property (nonatomic, strong) UITextField *modField;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UITextField *gcd;
@property (nonatomic, strong) UITextField *inverse;
@property (nonatomic, strong) UIButton *caclculate;

- (id)init;                                         // Initializes a GCD and invese view
- (IBAction)dismissKeyboard:(id)sender;             // Dismisss the keyboard from any of the textFields
- (IBAction)calculateButtonPressed:(id)sender;      // What to do when the calculate button is pressed

@end

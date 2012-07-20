//
//  GCDandInverseViewControllerViewController.h
//  QuickCrypt
//
//  Created by build on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCDandInverseViewController : UIViewController
{
    IBOutlet UIView *optionsViewMat;
    IBOutlet UITextField *inverseOfField;
    IBOutlet UITextField *modField;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *label4;
    IBOutlet UITextField *gcd;
    IBOutlet UITextField *inverse;
    IBOutlet UIButton *calculate;
}

@property (nonatomic, strong) UIView *optionsViewMat;
@property (nonatomic, strong) UITextField *inverseOfField;
@property (nonatomic, strong) UITextField *modField;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UITextField *gcd;
@property (nonatomic, strong) UITextField *inverse;
@property (nonatomic, strong) UIButton *caclculate;

- (id)init;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)calculateButtonPressed:(id)sender;

@end

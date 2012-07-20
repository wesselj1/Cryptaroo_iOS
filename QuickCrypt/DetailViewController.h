//
//  DetailViewController.h
//  QuickCrypt
//
//  Created by build on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, MGSplitViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    MGSplitViewController *splitViewController; // Reference to splitViewController
    
    UIPopoverController *popoverController; // The master popover controller
    
    IBOutlet SSTextView *inputText;         // The input text view
    IBOutlet SSTextView *outputText;        // The output text view
    IBOutlet UIButton *computeButton;       // Compute button
    IBOutlet UIStepper *stepper1;           // Stepper 1
    IBOutlet UIStepper *stepper2;           // Stepper 2
    IBOutlet UITextField *textField1;       // Various textFields used for options
    IBOutlet UITextField *textField2;
    IBOutlet UITextField *textField3;
    IBOutlet UITextField *textField4;
    IBOutlet UISwitch *switch1;
    IBOutlet UIView *optionsViewMat;        // View that contains the options for the cryptomethod
    IBOutlet UIView *GCDViewMat;            // View that holds the fields of the GCD and inverse calculator
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UIScrollView *scrollView;      // Scroll view containing everything
    
    QCCryptoMethod cryptoMethod;            // The current cryptomethod
    UINavigationController *navController;  // Reference to the app's navController
}

@property (nonatomic, strong) MGSplitViewController *splitViewController;

@property (nonatomic, strong) UIPopoverController *popoverController;

@property (nonatomic, strong) SSTextView *inputText;
@property (nonatomic, strong) SSTextView *outputText;
@property (nonatomic, strong) UIButton *computeButton;
@property (nonatomic, strong) UIStepper *stepper1;
@property (nonatomic, strong) UIStepper *stepper2;
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;
@property (nonatomic, strong) UITextField *textField4;
@property (nonatomic, strong) UISwitch *switch1;
@property (nonatomic, strong) UIView *optionsViewMat;
@property (nonatomic, strong) UIView *GCDViewMat;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@property (nonatomic, strong) UIScrollView *scrollView;

@property QCCryptoMethod cryptoMethod;
@property (nonatomic, strong) UINavigationController *navController;


- (void)stepperValueChanged;                    // Handles change of a stepper value
- (void)multiplierStepperValueChanged;          // Handles a change in value of the multiplier stepper
- (void)adderStepperValueChanged;               // Handles a change in value of the adder stepper
- (IBAction)computeButtonPressed:(id)sender;    // Handles what to do when user pressed the compute button
- (IBAction)didChangeOption:(id)sender;         /* Handles what to do when any option is changed, all options are hooked to this IBAction
                                                 so that we can save options anytime a change made then call the appropriate handler for that option */

// Init with the appropriate nib and note the cryptomethod being loaded
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cryptoMethod:(QCCryptoMethod)cryptoMethod; 

@end

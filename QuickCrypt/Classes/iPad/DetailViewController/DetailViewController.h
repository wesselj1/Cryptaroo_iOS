//
//  DetailViewController.h
//  QuickCrypt
//
//  Created by build on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewControlleriPad.h"
#import "QCButton.h"
#import "QCTextField.h"
#import "QCLabel.h"
#import "HelpViewController.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate, HelpViewControllerDelegate>
{
    UIPopoverController *popoverController; // The master popover controller
    
    IBOutlet SSTextView *inputText;         // The input text view
    IBOutlet SSTextView *outputText;        // The output text view
    IBOutlet QCButton *computeButton;       // Compute button
    IBOutlet UIStepper *stepper1;           // Stepper 1
    IBOutlet UIStepper *stepper2;           // Stepper 2
    IBOutlet QCTextField *textField1;       // Various textFields used for options
    IBOutlet QCTextField *textField2;
    IBOutlet QCTextField *textField3;
    IBOutlet QCTextField *textField4;
    IBOutlet UISwitch *switch1;
    IBOutlet UIView *optionsViewMat;        // View that contains the options for the cryptomethod
    IBOutlet UIView *GCDViewMat;            // View that holds the fields of the GCD and inverse calculator
    IBOutlet QCLabel *label1;
    IBOutlet QCLabel *label2;
    IBOutlet QCLabel *label3;
    IBOutlet QCLabel *label4;
    IBOutlet QCLabel *additiveLabel;
    IBOutlet QCLabel *multiplicativeLabel;
    IBOutlet UIScrollView *scrollView;      // Scroll view containing everything
    IBOutlet UIView *divider1;
    IBOutlet UIView *divider2;
    
    QCCryptoMethod cryptoMethod;            // The current cryptomethod
    UINavigationController *navController;  // Reference to the app's navController
}

@property (nonatomic, strong) UISplitViewController *splitViewController;
@property (nonatomic, strong) RootViewControlleriPad *rootViewController;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) NSString *methodTitle;

@property (nonatomic, strong) SSTextView *inputText;
@property (nonatomic, strong) SSTextView *outputText;
@property (nonatomic, strong) UIButton *computeButton;
@property (nonatomic, strong) UIStepper *stepper1;
@property (nonatomic, strong) UIStepper *stepper2;
@property (nonatomic, weak) QCTextField *textField1;
@property (nonatomic, weak) QCTextField *textField2;
@property (nonatomic, weak) QCTextField *textField3;
@property (nonatomic, weak) QCTextField *textField4;
@property (nonatomic, strong) UISwitch *switch1;
@property (nonatomic, strong) UIView *optionsViewMat;
@property (nonatomic, strong) UIView *GCDViewMat;
@property (nonatomic, strong) QCLabel *label1;
@property (nonatomic, strong) QCLabel *label2;
@property (nonatomic, strong) QCLabel *label3;
@property (nonatomic, strong) QCLabel *label4;
@property (nonatomic, strong) QCLabel *additiveLabel;
@property (nonatomic, strong) QCLabel *multiplicativeLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *divider1;
@property (nonatomic, strong) UIView *divider2;

@property QCCryptoMethod cryptoMethod;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) UIBarButtonItem *menuButton;


- (void)stepperValueChanged;                    // Handles change of a stepper value
- (void)multiplierStepperValueChanged;          // Handles a change in value of the multiplier stepper
- (void)adderStepperValueChanged;               // Handles a change in value of the adder stepper
- (IBAction)computeButtonPressed:(id)sender;    // Handles what to do when user pressed the compute button
- (IBAction)didChangeOption:(id)sender;         /* Handles what to do when any option is changed, all options are hooked to this IBAction
                                                 so that we can save options anytime a change made then call the appropriate handler for that option */

// Init with the appropriate nib and note the cryptomethod being loaded
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cryptoMethod:(QCCryptoMethod)cryptoMethod; 

@end

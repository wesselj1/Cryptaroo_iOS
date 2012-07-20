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
@property (nonatomic, strong) UIView *optionsViewMat2;
@property (nonatomic, strong) UIView *GCDViewMat;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@property (nonatomic, strong) UIScrollView *scrollView;

@property QCCryptoMethod cryptoMethod;
@property (nonatomic, strong) UINavigationController *navController;


- (void)stepperValueChanged;
- (void)multiplierStepperValueChanged;
- (void)adderStepperValueChanged;
- (IBAction)computeButtonPressed:(id)sender;
- (IBAction)didChangeOption:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cryptoMethod:(QCCryptoMethod)cryptoMethod; 

@end

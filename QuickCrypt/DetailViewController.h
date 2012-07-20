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
    MGSplitViewController *splitViewController;
    
    UIPopoverController *popoverController; // The master popover controller
    
    IBOutlet SSTextView *inputText;
    IBOutlet SSTextView *outputText;
    IBOutlet UIButton *computeButton;
    IBOutlet UIStepper *stepper1;
    IBOutlet UIStepper *stepper2;
    IBOutlet UITextField *textField1;
    IBOutlet UITextField *textField2;
    IBOutlet UITextField *textField3;
    IBOutlet UITextField *textField4;
    IBOutlet UIPickerView *picker1;
    IBOutlet UISwitch *switch1;
    IBOutlet UIView *optionsViewMat;
    IBOutlet UIView *optionsViewMat2;
    IBOutlet UIView *GCDViewMat;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    
    IBOutlet UIScrollView *scrollView;
    
    QCCryptoMethod cryptoMethod;
    UINavigationController *navController;
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
@property (nonatomic, strong) UIPickerView *picker1;
@property (nonatomic, strong) UISwitch *switch1;
@property (nonatomic, strong) UIView *optionsViewMat;
@property (nonatomic, strong) UIView *optionsViewMat2;
@property (nonatomic, strong) UIView *GCDViewMat;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

@property (nonatomic, strong) UIScrollView *scrollView;

@property QCCryptoMethod cryptoMethod;
@property (nonatomic, strong) UINavigationController *navController;


- (IBAction)stepperValueChanged:(id)sender;
- (IBAction)multiplierStepperValueChanged;
- (IBAction)adderStepperValueChanged;
- (IBAction)computeButtonPressed:(id)sender;
- (IBAction)didChangeOption:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cryptoMethod:(QCCryptoMethod)cryptoMethod; 

@end

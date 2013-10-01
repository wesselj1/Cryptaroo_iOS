//
//  OptionsViewController.h
//  QuickCrypt
//
//  Created by build on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QCButton;
@class QCLabel;
@class QCTextField;

@protocol OptionsViewControllerDelegate;

@interface OptionsViewController : UIViewController <UITextFieldDelegate>

@property (weak) id <OptionsViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIStepper *stepper1;
@property (nonatomic, weak) IBOutlet UIStepper *stepper2;
@property (nonatomic, weak) IBOutlet QCTextField *textField1;
@property (nonatomic, weak) IBOutlet QCTextField *textField2;
@property (nonatomic, weak) IBOutlet QCTextField *textField3;
@property (nonatomic, weak) IBOutlet UIView *optionsViewMat;
@property (nonatomic, weak) IBOutlet QCLabel *label1;
@property (nonatomic, weak) IBOutlet QCLabel *label2;
@property (nonatomic, weak) IBOutlet UIView *buttonDivider;
@property (nonatomic, weak) IBOutlet QCButton *applyButton;
@property (nonatomic, weak) IBOutlet QCButton *cancelButton;
@property (nonatomic, weak) IBOutlet UISwitch *switch1;
@property (nonatomic) QCCryptoMethod cryptoMethod;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forMethod:(QCCryptoMethod)method withOptions:(NSArray *)options;
- (IBAction)stepperValueChanged:(id)sender; // What to do when a stepper value has changed
- (IBAction)applyButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;
- (IBAction)multiplierStepperValueChanged:(id)sender;
- (IBAction)adderStepperValueChanged:(id)sender;

@end

@protocol OptionsViewControllerDelegate <NSObject>

@required
- (void)dismissOptionsViewController:(OptionsViewController *)viewController;
- (void)dismissandApplyOptionsViewController:(OptionsViewController *)viewController;
@end

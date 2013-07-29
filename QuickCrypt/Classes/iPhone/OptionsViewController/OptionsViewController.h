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

@protocol OptionsViewControllerDelegate;

@interface OptionsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    IBOutlet UIStepper *stepper1;       // Stepper for any incremental integer options
    IBOutlet UITextField *textField1;   // Three possibly used textFields
    IBOutlet UITextField *textField2;
    IBOutlet UITextField *textField3;
    IBOutlet UIPickerView *picker1;     // Picker that is used for picking multiplicative and additive key for affine ciphers
    IBOutlet UISwitch *switch1;
    IBOutlet QCLabel *label1;
    IBOutlet QCLabel *label2;
    IBOutlet UIView *buttonDivider;
    IBOutlet QCButton *applyButton;
    IBOutlet QCButton *cancelButton;
    QCCryptoMethod cryptoMethod;        // The current crypto method for the view
}

@property (weak) id <OptionsViewControllerDelegate> delegate;
@property (nonatomic, strong) UIStepper *stepper1;
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;
@property (nonatomic, strong) UIPickerView *picker1;
@property (nonatomic, strong) UIView *optionsViewMat;
@property (nonatomic, strong) QCLabel *label1;
@property (nonatomic, strong) QCLabel *label2;
@property (nonatomic, strong) UIView *buttonDivider;
@property (nonatomic, strong) QCButton *applyButton;
@property (nonatomic, strong) QCButton *cancelButton;
@property (nonatomic) QCCryptoMethod cryptoMethod;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forMethod:(QCCryptoMethod)method withOptions:(NSArray *)options;
- (IBAction)stepperValueChanged:(id)sender; // What to do when a stepper value has changed
- (IBAction)applyButtonTouched:(id)sender;
- (IBAction)cancelButtonTouched:(id)sender;

@end

@protocol OptionsViewControllerDelegate <NSObject>

@required
- (void)dismissOptionsViewController:(OptionsViewController *)viewController;
- (void)dismissandApplyOptionsViewController:(OptionsViewController *)viewController;
@end

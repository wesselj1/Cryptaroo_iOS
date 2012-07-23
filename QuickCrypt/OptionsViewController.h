//
//  OptionsViewController.h
//  QuickCrypt
//
//  Created by build on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionsViewControllerDelegate;

@interface OptionsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    IBOutlet UIStepper *stepper1;       // Stepper for any incremental integer options
    IBOutlet UITextField *textField1;   // Three possibly used textFields
    IBOutlet UITextField *textField2;
    IBOutlet UITextField *textField3;
    IBOutlet UIPickerView *picker1;     // Picker that is used for picking multiplicative and additive key for affine ciphers
    IBOutlet UISwitch *switch1;
    IBOutlet UIView *optionsViewMat;    // The view that contains our options
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    QCCryptoMethod cryptoMethod;        // The current crypto method for the view
}

@property (nonatomic, strong) UIStepper *stepper1;
@property (nonatomic, strong) UITextField *textFiedl1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;
@property (nonatomic, strong) UIPickerView *picker1;
@property (nonatomic, strong) UIButton *checkBox;
@property (nonatomic, strong) UIView *optionsViewMat;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic) QCCryptoMethod cryptoMethod;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forMethod:(QCCryptoMethod)method withOptions:(NSArray *)options;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)stepperValueChanged:(id)sender; // What to do when a stepper value has changed

@end

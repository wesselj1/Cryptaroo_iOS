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
    id <OptionsViewControllerDelegate> delegate;
    IBOutlet UIStepper *stepper1;
    IBOutlet UITextField *textField1;
    IBOutlet UITextField *textField2;
    IBOutlet UITextField *textField3;
    IBOutlet UIPickerView *picker1;
    IBOutlet UISwitch *switch1;
    IBOutlet UIButton *doneButton;
    IBOutlet UIView *optionsViewMat;
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    QCCryptoMethod cryptoMethod;
}

@property (nonatomic, strong) id <OptionsViewControllerDelegate> delegate;
@property (nonatomic, strong) UIStepper *stepper1;
@property (nonatomic, strong) UITextField *textFiedl1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;
@property (nonatomic, strong) UIPickerView *picker1;
@property (nonatomic, strong) UIButton *checkBox;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIView *optionsViewMat;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic) QCCryptoMethod cryptoMethod;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forMethod:(QCCryptoMethod)method withOptions:(NSArray *)options;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)stepperValueChanged:(id)sender;

@end



//@protocol OptionsViewControllerDelegate <NSObject>

//@required
//- (void) optionsViewContoller:(OptionsViewController *)viewController didFinishSelectingOptions:(NSMutableArray *)options;

//@end

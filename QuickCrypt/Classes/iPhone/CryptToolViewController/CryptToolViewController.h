//
//  CryptToolViewController.h
//  QuickCrypt
//
//  Created by build on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsViewController.h"

@interface CryptToolViewController : UIViewController <UITextViewDelegate, OptionsViewControllerDelegate>
{
    IBOutlet UIButton *backgroundButton;// Button in background of everything to dismiss keyboard
    IBOutlet SSTextView *inputText;     // The input textView
    IBOutlet SSTextView *outputText;    // The output textView
    IBOutlet UIButton *computeButton;   // The compute button
    IBOutlet UIButton *optionButton;    // The option button which goes to the options screen
    IBOutlet UIView *divider;           // The divider between the input and output text
    IBOutlet UIView *buttonDivider;     // The divider between the compute and options buttons
    QCCryptoMethod cryptoMethod;        // The current cryptop method of the view
}

@property (nonatomic, weak) UIButton *backgroundButton;
@property (nonatomic, weak) SSTextView *inputText;
@property (nonatomic, weak) SSTextView *outputText;
@property (nonatomic, weak) UIButton *computeButton;
@property (nonatomic, weak) UIButton *optionButton;
@property (nonatomic, weak) UIView *divider;
@property (nonatomic, weak) UIView *buttonDivider;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *inputTextTopConstraint_7;
@property QCCryptoMethod cryptoMethod;

- (id)initWithCryptoType:(QCCryptoMethod)method;    // Init the view method with a given crypto method
- (IBAction)dismissKeyboard:(id)sender;             // Method to dismiss the keyboard when background button hit
- (IBAction)setOptionsPressed:(id)sender;           // Will be called to present options screen
- (IBAction)computeButtonPressed:(id)sender;        // Executes the crypto method on input text when button pressed

@end

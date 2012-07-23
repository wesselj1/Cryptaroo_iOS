//
//  CryptToolViewController.h
//  QuickCrypt
//
//  Created by build on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsViewController.h"

@interface CryptToolViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UIButton *backgroundButton;// Button in background of everything to dismiss keyboard
    IBOutlet SSTextView *inputText;     // The input textView
    IBOutlet SSTextView *outputText;    // The output textView
    IBOutlet UIButton *computeButton;   // The compute button
    IBOutlet UIButton *optionButton;    // The option button which goes to the options screen
    QCCryptoMethod cryptoMethod;        // The current cryptop method of the view
}

@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) SSTextView *inputText;
@property (nonatomic, strong) SSTextView *outputText;
@property (nonatomic, strong) UIButton *computeButton;
@property (nonatomic, strong) UIButton *optionButton;
@property QCCryptoMethod cryptoMethod;

- (id)initWithCryptoType:(QCCryptoMethod)method;    // Init he view method with a given crypto method
- (IBAction)dismissKeyboard:(id)sender;             // Method to dismiss the keyboard when background button hit
- (IBAction)setOptionsPressed:(id)sender;           // Will be called to present options screen
- (IBAction)computeButtonPressed:(id)sender;        // Executes the crypto method on input text when button pressed

@end

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
    IBOutlet UIButton *backgroundButton;
    IBOutlet SSTextView *inputText;
    IBOutlet SSTextView *outputText;
    IBOutlet UIButton *computeButton;
    IBOutlet UIButton *optionButton;
    QCCryptoMethod cryptoMethod;
}

@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) SSTextView *inputText;
@property (nonatomic, strong) SSTextView *outputText;
@property (nonatomic, strong) UIButton *computeButton;
@property (nonatomic, strong) UIButton *optionButton;
@property QCCryptoMethod cryptoMethod;

- (id)initWithCryptoType:(QCCryptoMethod)method;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)setOptionsPressed:(id)sender;
- (IBAction)computeButtonPressed:(id)sender;

@end

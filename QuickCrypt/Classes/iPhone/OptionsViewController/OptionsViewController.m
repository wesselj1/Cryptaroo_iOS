//
//  optionsViewController.m
//  QuickCrypt
//
//  Created by build on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsViewController.h"
#import "CryptToolViewController.h"
#import "QCLabel.h"
#import "QCTextField.h"
#import "Fonts.h"

#define kMultiplierComponent 0
#define kAditiveComponent 1

@interface OptionsViewController () {
    int lastStepperValue;
}

- (void)setOptionsTitlesArray;   // Set the title of the labels for this particular option set
- (void)getOptionsAndSave;      // Update the array of options and send them back to the textData instance
- (void)recallOptions;          // Recall options from previous edit of these options for current method

@property (nonatomic, strong) NSArray *optionsAry;              // Our array of options
@property (nonatomic, strong) NSMutableArray *optionsTitles;    // The title of the options to be set, used to set labels
@property (nonatomic, strong) TextData *td;                     // Instance of our textData class
@property (nonatomic) CGRect initialFrame;

@property (nonatomic, strong) DoneCancelNumberPadToolbar *accessoryToolbar;

@end

@implementation OptionsViewController


#pragma mark - View Lifecycle Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forMethod:(QCCryptoMethod)method withOptions:(NSMutableArray *)options
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cryptoMethod = method;
        _optionsAry = options;
        [self setOptionsTitlesArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    
    if( _cryptoMethod == QCNGraphs || _cryptoMethod == QCSplitOffAlphabets || _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCAutokeyCyphertextAttack || _cryptoMethod == QCAutokeyPlaintextAttack) {
        DoneCancelNumberPadToolbar *toolbar = [[DoneCancelNumberPadToolbar alloc] initWithTextField:_textField1];
        _textField1.inputAccessoryView = toolbar;
        _textField2.inputAccessoryView = toolbar;
        _textField3.inputAccessoryView = toolbar;
    }
    
    self.td = [TextData textDataManager]; // Get instance of our textData class
    _optionsAry = [_td.optionsList objectAtIndex:_cryptoMethod]; // Get the options from textData

    if( _buttonDivider != nil )
        _buttonDivider.backgroundColor = [UIColor colorWithWhite:102/255.0 alpha:1.0];
    
    
    // Set any labels that may exist
    if( [_optionsTitles objectAtIndex:0] )
        _label1.text = [_optionsTitles objectAtIndex:0];
    if( _optionsTitles.count > 1 && [_optionsTitles objectAtIndex:1] )
        _label2.text = [_optionsTitles objectAtIndex:1];
    
    [_switch1 setOn:NO]; // Default switch to be OFF
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [[UISwitch appearance] setTintColor:[UIColor colorWithRed:255/255.0 green:190/255.0 blue:100/255.0 alpha:1.0]];
    }
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:255/255.0 green:190/255.0 blue:100/255.0 alpha:1.0]];
    
    // Setup the steppers for the approriate methods
    if( _cryptoMethod == QCAffineDecipher || _cryptoMethod == QCAffineEncipher )
    {
        [_stepper1 setMinimumValue:1];
        [_stepper1 setMaximumValue:25];
        [_stepper1 setStepValue:2];
        [_stepper1 setValue:1];
        [_stepper1 setWraps:YES];
        
        [_stepper2 setMinimumValue:0];
        [_stepper2 setMaximumValue:25];
        [_stepper2 setStepValue:1];
        [_stepper2 setValue:0];
        [_stepper2 setWraps:YES];
    }
    else
    {
        [_stepper1 setMinimumValue:1];
        [_stepper1 setStepValue:1];
    }
    [[UIStepper appearance] setTintColor:[UIColor colorWithRed:255/255.0 green:190/255.0 blue:100/255.0 alpha:1.0]];
    
    if( _cryptoMethod == QCAutokeyPlaintextAttack )
    {   // For QCAutoKeyPlaintextAttack the keyboard type for said two fields should be a decimal pad (for entering doubles)
        _textField2.keyboardType = UIKeyboardTypeDecimalPad;
        _textField3.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    [self setFonts];
    
    [self recallOptions];   // Recall any previous options from this method
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self getOptionsAndSave];   // Save the options array
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Rotation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Picker Methods
- (IBAction)stepperValueChanged:(id)sender
{
    double stepperValue = _stepper1.value;
    _textField1.text = [NSString stringWithFormat:@"%.f", stepperValue];
}

- (IBAction)multiplierStepperValueChanged:(id)sender
{   // Get the stepper value and set it to the textField
    double stepperValue = _stepper1.value;
    if( stepperValue == 13 )
    {   // Multiplier value should skip 13 for affine ciphers because it contains no inverse
        if ( stepperValue - lastStepperValue >= 0 ) // Check if incrementing or decrementing to know if we should be skipping to 15 or 11
            stepperValue = 15;
        else
            stepperValue = 11;
        
        [_stepper1 setValue:stepperValue];
    }
    
    
    _textField1.text = [NSString stringWithFormat:@"%.f", stepperValue];
    lastStepperValue = stepperValue;    // Update the last stepperValue
}

- (IBAction)adderStepperValueChanged:(id)sender
{   // Get the stepper value and set it to the textField
    double stepperValue = _stepper2.value;
    _textField2.text = [NSString stringWithFormat:@"%.f", stepperValue];
}


#pragma mark - Set Option Titles
- (void)setOptionsTitlesArray
{
    switch ( _cryptoMethod )
    {
        case QCNGraphs:
            _optionsTitles = [NSMutableArray arrayWithObjects:@"Length of NGraph", nil];
            break;
        case QCAffineKnownPlaintextAttack:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword", @"Shift First", nil];
            break;
        case QCAffineEncipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Multiplicative Shift", @"Additive Shift", nil];
            break;
        case QCAffineDecipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Multiplicative Shift", @"Additive Shift", nil];
            break;
        case QCSplitOffAlphabets:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Wordlength", nil];
            break;
        case QCPolyMonoCalculator:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword Size", nil];
            break;
        case QCViginereEncipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword", nil];
            break;
        case QCViginereDecipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword", nil];
            break;
        case QCAutokeyCyphertextAttack:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword Length", nil];
            break;
        case QCAutokeyPlaintextAttack:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Max Keyword Length", @"Friedman Range", nil];
            break;
        case QCAutokeyDecipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword", @"Include Plaintext In Key", nil];
            break;
        case QCGCDAndInverse:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Inverse of", @"Mod", nil];
            break;
        default:
            break;
    }
}

- (void)setFonts
{
    if( _label1 )
    {
        [_label1 setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:28.0]];
        [_label1 setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    }
    
    if( _label2 )
    {
        [_label2 setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:28.0]];
        [_label2 setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    }
}


#pragma mark - TextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *badCharacters; // The bad set of characters
    
    if( textField.tag != 0 )
    {   // If the tag isn't 0, then it is one of the float fields in QCAutoPlainTextAttack
        // So if they are trying to enter a period check to see if a period already exists
        if( [string compare:@"."] == NSOrderedSame && [textField.text rangeOfString:@"." options:0 range:NSMakeRange(0, textField.text.length)].location != NSNotFound )
            return NO; // If a period exist, don't allow the character change
    }
    
    if( ![string isEqualToString:@""] ) // Make sure incoming character is not blank
    {
        // If they are editing one of the two float fields and not entering a period (already handled that above), allow only numbers
        if( _cryptoMethod == QCAutokeyPlaintextAttack && textField.tag != 0 && ![string isEqualToString:@"."] )
            badCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@",?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        
        // Else if it is one of the integer fields only only integers
        else if( _cryptoMethod == QCNGraphs || _cryptoMethod == QCSplitOffAlphabets || _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCAutokeyCyphertextAttack || _cryptoMethod == QCAutokeyPlaintextAttack || _cryptoMethod == QCGCDAndInverse )
        {
            badCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@".,?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
            
            // If the new entry in the integer field is valid, update the stepper value, else set stepper value to text as double minus bad character
            if ( string.length > 0 && ![badCharacters characterIsMember:[string characterAtIndex:0]] && textField.tag == 0 )
                [_stepper1 setValue:[[_textField1.text stringByAppendingString:string] doubleValue]];
            else if( string.length <= 0 && textField.tag == 0 )
                [_stepper1 setValue:[[_textField1.text substringToIndex:_textField1.text.length-1] doubleValue]];
        }
        else    // Else, the field must be one taking text, so only allow uppper and lowercase characters
            badCharacters = [NSCharacterSet characterSetWithCharactersInString:@".,?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•1234567890"];
        
        // Don't allow change to field if no text entered or the character is bad
        if( string.length > 0 && [badCharacters characterIsMember:[string characterAtIndex:0]] )
            return NO;
    }
    
    return YES;
}


#pragma mark - Option Handling Methods
- (void)recallOptions
{
    if( _optionsAry && [_optionsAry count] > 0 )
    {
        switch ( _cryptoMethod )
        {
            case QCNGraphs:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_textField1.text intValue]];
                break;
            case QCAffineKnownPlaintextAttack:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_switch1 setOn:[[_optionsAry objectAtIndex:1] boolValue]];
                break;
            case QCAffineEncipher:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_textField1.text intValue]];
                _textField2.text = [_optionsAry objectAtIndex:1];
                [_stepper2 setValue:[_textField2.text intValue]];
                break;
            case QCAffineDecipher:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_textField1.text intValue]];
                _textField2.text = [_optionsAry objectAtIndex:1];
                [_stepper2 setValue:[_textField2.text intValue]];
                break;
            case QCSplitOffAlphabets:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_textField1.text intValue]];
                break;
            case QCPolyMonoCalculator:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_textField1.text intValue]];
                break;
            case QCViginereEncipher:
                _textField1.text = [_optionsAry objectAtIndex:0];
                break;
            case QCViginereDecipher:
                _textField1.text = [_optionsAry objectAtIndex:0];
                break;
            case QCAutokeyCyphertextAttack:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_textField1.text intValue]];
                break;
            case QCAutokeyPlaintextAttack:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_textField1.text intValue]];
                _textField2.text = [_optionsAry objectAtIndex:1];
                _textField3.text = [_optionsAry objectAtIndex:2];
                break;
            case QCAutokeyDecipher:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_switch1 setOn:[[_optionsAry objectAtIndex:1] boolValue]];
                break;
            case QCGCDAndInverse:
                _textField1.text = [_optionsAry objectAtIndex:0];
                _textField2.text = [_optionsAry objectAtIndex:1];
                break;
            default:
                break;
        }
    }
}

- (void)getOptionsAndSave
{
    switch ( _cryptoMethod )
    {
        case QCNGraphs:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], nil];
            break;
        case QCAffineKnownPlaintextAttack:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], [NSNumber numberWithBool:_switch1.on], nil];
            break;
        case QCAffineEncipher:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], [_textField2 text], nil];
            break;
        case QCAffineDecipher:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], [_textField2 text], nil];
            break;
        case QCSplitOffAlphabets:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], nil];
            break;
        case QCPolyMonoCalculator:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], nil];
            break;
        case QCViginereEncipher:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], nil];
            break;
        case QCViginereDecipher:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], nil];
            break;
        case QCAutokeyCyphertextAttack:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], nil];
            break;
        case QCAutokeyPlaintextAttack:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], [_textField2 text], [_textField3 text], nil];
            break;
        case QCAutokeyDecipher:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], [NSNumber numberWithBool:_switch1.on], nil];
            break;
        case QCGCDAndInverse:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], [_textField2 text], nil];
            break;
        default:
            break;
    }
    [_td.optionsList replaceObjectAtIndex:_cryptoMethod withObject:_optionsAry];
}

#pragma mark - Actions
- (IBAction)applyButtonTouched:(id)sender
{
    [self getOptionsAndSave];
    [self.delegate dismissandApplyOptionsViewController:self];
}

- (IBAction)cancelButtonTouched:(id)sender
{
    [self.delegate dismissOptionsViewController:self];
}

#pragma mark - Keyboard Notification Methods
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGSize kbSize = kbFrame.size;
    self.initialFrame = self.view.frame;
    
    float yDelta = (_initialFrame.origin.y + _initialFrame.size.height) - (self.parentViewController.view.frame.size.height-kbSize.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        if ( _cryptoMethod == QCNGraphs || _cryptoMethod == QCSplitOffAlphabets || _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCAutokeyCyphertextAttack || _cryptoMethod == QCAutokeyPlaintextAttack ) {
            self.view.frame = CGRectMake(_initialFrame.origin.x, _initialFrame.origin.y-yDelta-20, _initialFrame.size.width, _initialFrame.size.height);
        } else if ( _cryptoMethod == QCAffineKnownPlaintextAttack || _cryptoMethod == QCAutokeyDecipher ) {
            self.view.frame = CGRectMake(_initialFrame.origin.x, _initialFrame.origin.y-2*yDelta, _initialFrame.size.width, _initialFrame.size.height);
        } else if ( _cryptoMethod == QCViginereEncipher || _cryptoMethod == QCViginereDecipher ) {
            self.view.frame = CGRectMake(_initialFrame.origin.x, _initialFrame.origin.y-6*yDelta, _initialFrame.size.width, _initialFrame.size.height);
        }
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = _initialFrame;
    }];
}


@end

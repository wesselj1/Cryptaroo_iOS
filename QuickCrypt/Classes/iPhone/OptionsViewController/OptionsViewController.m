//
//  optionsViewController.m
//  QuickCrypt
//
//  Created by build on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "optionsViewController.h"
#import "CryptToolViewController.h"
#import "QCLabel.h"

#define kMultiplierComponent 0
#define kAditiveComponent 1

@interface OptionsViewController ()
{
    NSMutableArray *optionsAry;     // Our array of options
    NSMutableArray *_optionsTitles;   // The title of the options to be set, used to set labels
    NSArray *multipliers;           // The array of multiplicative keys for affine
    NSArray *additives;             // The array of additive keys for affine
    TextData *td;                   // Instance of our textData class
}

- (void)set_optionsTitlesArray;   // Set the title of the labels for this particular option set
- (void)getOptionsAndSave;      // Update the array of options and send them back to the textData instance
- (void)recallOptions;          // Recall options from previous edit of these options for current method

@property (nonatomic, strong) NSMutableArray *optionsAry;
@property (nonatomic, strong) NSMutableArray *optionsTitles;
@property (nonatomic, strong) NSArray *multipliers;
@property (nonatomic, strong) NSArray *additives;
@property (nonatomic, strong) TextData *td;

@end

@implementation OptionsViewController

@synthesize stepper1 = _stepper1;
@synthesize textField1 = _textField1;
@synthesize textField2 = _textField2;
@synthesize textField3 = _textField3;
@synthesize picker1 = _picker1;
@synthesize optionsViewMat = _optionsViewMat;
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize cryptoMethod = _cryptoMethod;
@synthesize optionsAry = _optionsAry;
@synthesize optionsTitles = _optionsTitles;
@synthesize additives = _additives;
@synthesize multipliers = _multipliers;
@synthesize buttonDivider = _buttonDivider;
@synthesize td;


#pragma mark - View Lifecycle Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forMethod:(QCCryptoMethod)method withOptions:(NSMutableArray *)options
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cryptoMethod = method;
        _optionsAry = options;
        [self set_optionsTitlesArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    td = [TextData textDataManager]; // Get instance of our textData class
    _optionsAry = [td.optionsList objectAtIndex:_cryptoMethod]; // Get the options from textData
    
    // If doing an affine method, set the array of multiplicative and additive keys to be used
    if( _cryptoMethod == QCAffineDecipher || _cryptoMethod == QCAffineEncipher )
    {
        _multipliers = [[NSArray alloc] initWithObjects:@"1", @"3", @"5", @"7", @"9", @"11", @"15", @"17", @"19", @"21", @"23", @"25", nil];
        _additives = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", nil];
    }

    if( _buttonDivider != nil )
        _buttonDivider.backgroundColor = [UIColor colorWithWhite:102/255.0 alpha:1.0];
    
    
    // Set any labels that may exist
    if( [_optionsTitles objectAtIndex:0] )
        _label1.text = [_optionsTitles objectAtIndex:0];
    if( _optionsTitles.count > 1 && [_optionsTitles objectAtIndex:1] )
        _label2.text = [_optionsTitles objectAtIndex:1];
    
    [switch1 setOn:NO]; // Default switch to be OFF
    
    // Setup the stepper
    [_stepper1 setMinimumValue:0];
    [_stepper1 setStepValue:1];
    
    if( _cryptoMethod == QCAutokeyPlaintextAttack )
    {   // For QCAutoKeyPlaintextAttack the keyboard type for said two fields should be a decimal pad (for entering doubles)
        _textField2.keyboardType = UIKeyboardTypeDecimalPad;
        _textField3.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    [self recallOptions];   // Recall any previous options from this method
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self getOptionsAndSave];   // Save the options array
}


#pragma mark - Rotation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)stepperValueChanged:(id)sender
{
    double stepperValue = _stepper1.value;
    _textField1.text = [NSString stringWithFormat:@"%.f", stepperValue];
}


#pragma mark - Set Option Titles
- (void)set_optionsTitlesArray;
{
    switch ( _cryptoMethod )
    {
        case QCNGraphs:
            _optionsTitles = [NSMutableArray arrayWithObjects:@"Length of NGraph:", nil];
            break;
        case QCAffineKnownPlaintextAttack:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword:", @"Shift First:", nil];
            break;
        case QCAffineEncipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Multiplicative Shift:", @"Additive Shift:", nil];
            break;
        case QCAffineDecipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Multiplicative Shift:", @"Additive Shift:", nil];
            break;
        case QCSplitOffAlphabets:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Wordlength:", nil];
            break;
        case QCPolyMonoCalculator:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword Size:", nil];
            break;
        case QCViginereEncipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword:", nil];
            break;
        case QCViginereDecipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword:", nil];
            break;
        case QCAutokeyCyphertextAttack:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword Length:", nil];
            break;
        case QCAutokeyPlaintextAttack:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Max Keyword Length:", @"Friedman Range:", nil];
            break;
        case QCAutokeyDecipher:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword:", @"PlainText:", nil];
            break;
        case QCGCDAndInverse:
            _optionsTitles = [[NSMutableArray alloc] initWithObjects:@"Inverse of:", @"Mod:", nil];
            break;
        default:
            break;
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
                [switch1 setOn:[[_optionsAry objectAtIndex:1] boolValue]];
                break;
            case QCAffineEncipher:
                [_picker1 selectRow:[_multipliers indexOfObject:[_optionsAry objectAtIndex:0]] inComponent:0 animated:YES];
                [_picker1 selectRow:[_additives indexOfObject:[_optionsAry objectAtIndex:1]] inComponent:1 animated:YES];
                break;
            case QCAffineDecipher:
                [_picker1 selectRow:[_multipliers indexOfObject:[_optionsAry objectAtIndex:0]] inComponent:0 animated:YES];
                [_picker1 selectRow:[_additives indexOfObject:[_optionsAry objectAtIndex:1]] inComponent:1 animated:YES];
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
                [switch1 setOn:[[_optionsAry objectAtIndex:1] boolValue]];
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
    int multiplierRow;
    int additionRow;
    switch ( _cryptoMethod )
    {
        case QCNGraphs:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], nil];
            break;
        case QCAffineKnownPlaintextAttack:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], [NSNumber numberWithBool:switch1.on], nil];
            break;
        case QCAffineEncipher:
            multiplierRow = [_picker1 selectedRowInComponent:kMultiplierComponent];
            additionRow = [_picker1 selectedRowInComponent:kAditiveComponent];
            _optionsAry = [NSArray arrayWithObjects:[_multipliers objectAtIndex:multiplierRow], [_additives objectAtIndex:additionRow], nil];
            break;
        case QCAffineDecipher:
            multiplierRow = [_picker1 selectedRowInComponent:kMultiplierComponent];
            additionRow = [_picker1 selectedRowInComponent:kAditiveComponent];
            _optionsAry = [NSArray arrayWithObjects:[_multipliers objectAtIndex:multiplierRow], [_additives objectAtIndex:additionRow], nil];
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
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], [NSNumber numberWithBool:switch1.on], nil];
            break;
        case QCGCDAndInverse:
            _optionsAry = [NSArray arrayWithObjects:[_textField1 text], [_textField2 text], nil];           
            break;
        default:
            break;
    }
    [td.optionsList replaceObjectAtIndex:_cryptoMethod withObject:_optionsAry];
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


#pragma mark - Picker Delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{   
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if( component == kMultiplierComponent )
        return [_multipliers count];
    return [_additives count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 44)];
    if( component == kMultiplierComponent )
        label.text = [NSString stringWithString:[_multipliers objectAtIndex:row]];
    else
        label.text = [NSString stringWithString:[_additives objectAtIndex:row]];
    label.font = [UIFont systemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end

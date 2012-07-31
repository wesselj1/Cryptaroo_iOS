//
//  OptionsViewController.m
//  QuickCrypt
//
//  Created by build on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsViewController.h"
#import "CryptToolViewController.h"

#define kMultiplierComponent 0
#define kAditiveComponent 1

@interface OptionsViewController ()
{
    NSMutableArray *options;        // Our array of options
    NSMutableArray *optionTitles;   // The title of the options to be set, used to set labels
    NSArray *multipliers;           // The array of multiplicative keys for affine
    NSArray *additives;             // The array of additive keys for affine
    TextData *td;                   // Instance of our textData class
}

- (void)setOptionTitlesArray;   // Set the title of the labels for this particular option set
- (void)getOptionsAndSave;      // Update the array of options and send them back to the textData instance
- (void)recallOptions;          // Recall options from previous edit of these options for current method

@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, strong) NSMutableArray *optionTitles;
@property (nonatomic, strong) NSArray *multipliers;
@property (nonatomic, strong) NSArray *additives;
@property (nonatomic, strong) TextData *td;

@end

@implementation OptionsViewController

@synthesize stepper1;
@synthesize textFiedl1;
@synthesize textField2;
@synthesize textField3;
@synthesize picker1;
@synthesize checkBox;
@synthesize optionsViewMat;
@synthesize label1;
@synthesize label2;
@synthesize cryptoMethod;
@synthesize options = _options;
@synthesize optionTitles;
@synthesize additives;
@synthesize multipliers;
@synthesize td;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forMethod:(QCCryptoMethod)method withOptions:(NSMutableArray *)optionsA
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        cryptoMethod = method;
        _options = optionsA;
        [self setOptionTitlesArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    td = [TextData textDataManager]; // Get instance of our textData class
    _options = [td.optionsList objectAtIndex:cryptoMethod]; // Get the options from textData
    
    // If doing an affine method, set the array of multiplicative and additive keys to be used
    if( cryptoMethod == QCAffineDecipher || cryptoMethod == QCAffineEncipher )
    {
        multipliers = [[NSArray alloc] initWithObjects:@"1", @"3", @"5", @"7", @"9", @"11", @"15", @"17", @"19", @"21", @"23", @"25", nil];
        additives = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", nil];
    }

    // Round the corners of the options view mat so it looks prettier
    optionsViewMat.layer.cornerRadius = 5;
    optionsViewMat.clipsToBounds = YES;
    
    
    // Set any labels that may exist
    if( [optionTitles objectAtIndex:0] )
        label1.text = [optionTitles objectAtIndex:0];
    if( optionTitles.count > 1 && [optionTitles objectAtIndex:1] )
        label2.text = [optionTitles objectAtIndex:1];
    
    [switch1 setOn:NO]; // Default switch to be OFF
    
    // Setup the stepper
    [stepper1 setMinimumValue:0];
    [stepper1 setStepValue:1];
    
    if( cryptoMethod == QCAutokeyPlaintextAttack )
    {   // For QCAutoKeyPlaintextAttack the keyboard type for said two fields should be a decimal pad (for entering doubles)
        textField2.keyboardType = UIKeyboardTypeDecimalPad;
        textField3.keyboardType = UIKeyboardTypeDecimalPad;
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
    [self getOptionsAndSave];   // Save the options
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)stepperValueChanged:(id)sender
{
    double stepperValue = stepper1.value;
    textField1.text = [NSString stringWithFormat:@"%.f", stepperValue];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
    [textField3 resignFirstResponder];
}

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
    
    if( string != @"" ) // Make sure incoming character is not blank
    {
        // If they are editing one of the two float fields and not entering a period (already handled that above), allow only numbers
        if( cryptoMethod == QCAutokeyPlaintextAttack && textField.tag != 0 && string != @"." )
            badCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@",?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        
        // Else if it is one of the integer fields only only integers
        else if( cryptoMethod == QCNGraphs || cryptoMethod == QCSplitOffAlphabets || cryptoMethod == QCPolyMonoCalculator || cryptoMethod == QCAutokeyCyphertextAttack || cryptoMethod == QCAutokeyPlaintextAttack || cryptoMethod == QCGCDAndInverse )
        {
            badCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@".,?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0"];
            
            // If the new entry in the integer field is valid, update the stepper value, else set stepper value to text as double minus bad character
            if ( string.length > 0 && ![badCharacters characterIsMember:[string characterAtIndex:0]] && textField.tag == 0 )
                [stepper1 setValue:[[textField1.text stringByAppendingString:string] doubleValue]];
            else if( string.length <= 0 && textField.tag == 0 )
                [stepper1 setValue:[[textField1.text substringToIndex:textField1.text.length-1] doubleValue]];
        }
        else    // Else, the field must be one taking text, so only allow uppper and lowercase characters
            badCharacters = [NSCharacterSet characterSetWithCharactersInString:@".,?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•1234567890"];
        
        // Don't allow change to field if no text entered or the character is bad
        if( string.length > 0 && [badCharacters characterIsMember:[string characterAtIndex:0]] )
            return NO;
    }
    
    return YES;
}

- (void)recallOptions
{
    if( _options && [_options count] > 0 )
    {
        switch ( cryptoMethod )
        {
            case QCNGraphs:
                textField1.text = [_options objectAtIndex:0];
                [stepper1 setValue:[textField1.text intValue]];
                break;
            case QCAffineKnownPlaintextAttack:
                textField1.text = [_options objectAtIndex:0];
                [switch1 setOn:[[_options objectAtIndex:1] boolValue]];
                break;
            case QCAffineEncipher:
                [picker1 selectRow:[multipliers indexOfObject:[_options objectAtIndex:0]] inComponent:0 animated:YES];
                [picker1 selectRow:[additives indexOfObject:[_options objectAtIndex:1]] inComponent:1 animated:YES];
                break;
            case QCAffineDecipher:
                [picker1 selectRow:[multipliers indexOfObject:[_options objectAtIndex:0]] inComponent:0 animated:YES];
                [picker1 selectRow:[additives indexOfObject:[_options objectAtIndex:1]] inComponent:1 animated:YES];
                break;
            case QCSplitOffAlphabets:
                textField1.text = [_options objectAtIndex:0];
                [stepper1 setValue:[textField1.text intValue]];
                break;
            case QCPolyMonoCalculator:
                textField1.text = [_options objectAtIndex:0];
                [stepper1 setValue:[textField1.text intValue]];
                break;
            case QCViginereEncipher:
                textField1.text = [_options objectAtIndex:0];
                break;
            case QCViginereDecipher:
                textField1.text = [_options objectAtIndex:0];
                break;
            case QCAutokeyCyphertextAttack:
                textField1.text = [_options objectAtIndex:0];
                [stepper1 setValue:[textField1.text intValue]];
                break;
            case QCAutokeyPlaintextAttack:
                textField1.text = [_options objectAtIndex:0];
                [stepper1 setValue:[textField1.text intValue]];
                textField2.text = [_options objectAtIndex:1];
                textField3.text = [_options objectAtIndex:2];
                break;
            case QCAutokeyDecipher:
                textField1.text = [_options objectAtIndex:0];
                [switch1 setOn:[[_options objectAtIndex:1] boolValue]];
                break;
            case QCGCDAndInverse:
                textField1.text = [_options objectAtIndex:0];
                textField2.text = [_options objectAtIndex:1];        
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
    switch ( cryptoMethod )
    {
        case QCNGraphs:
            _options = [NSArray arrayWithObjects:[textField1 text], nil];
            break;
        case QCAffineKnownPlaintextAttack:
            _options = [NSArray arrayWithObjects:[textField1 text], [NSNumber numberWithBool:switch1.on], nil];
            break;
        case QCAffineEncipher:
            multiplierRow = [picker1 selectedRowInComponent:kMultiplierComponent];
            additionRow = [picker1 selectedRowInComponent:kAditiveComponent];
            _options = [NSArray arrayWithObjects:[multipliers objectAtIndex:multiplierRow], [additives objectAtIndex:additionRow], nil];
            break;
        case QCAffineDecipher:
            multiplierRow = [picker1 selectedRowInComponent:kMultiplierComponent];
            additionRow = [picker1 selectedRowInComponent:kAditiveComponent];
            _options = [NSArray arrayWithObjects:[multipliers objectAtIndex:multiplierRow], [additives objectAtIndex:additionRow], nil];
            break;
        case QCSplitOffAlphabets:
            _options = [NSArray arrayWithObjects:[textField1 text], nil];
            break;
        case QCPolyMonoCalculator:
            _options = [NSArray arrayWithObjects:[textField1 text], nil];
            break;
        case QCViginereEncipher:
            _options = [NSArray arrayWithObjects:[textField1 text], nil];
            break;
        case QCViginereDecipher:
            _options = [NSArray arrayWithObjects:[textField1 text], nil];
            break;
        case QCAutokeyCyphertextAttack:
            _options = [NSArray arrayWithObjects:[textField1 text], nil];
            break;
        case QCAutokeyPlaintextAttack:
            _options = [NSArray arrayWithObjects:[textField1 text], [textField2 text], [textField3 text], nil];
            break;
        case QCAutokeyDecipher:
            _options = [NSArray arrayWithObjects:[textField1 text], [NSNumber numberWithBool:switch1.on], nil];
            break;
        case QCGCDAndInverse:
            _options = [NSArray arrayWithObjects:[textField1 text], [textField2 text], nil];           
            break;
        default:
            break;
    }
    [td.optionsList replaceObjectAtIndex:cryptoMethod withObject:_options];
}

- (void)setOptionTitlesArray;
{
    switch ( cryptoMethod )
    {
        case QCNGraphs:
            optionTitles = [NSMutableArray arrayWithObjects:@"Length of NGraph:", nil];
            break;
        case QCAffineKnownPlaintextAttack:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword:", @"Shift First:", nil];
            break;
        case QCAffineEncipher:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Multiplicative Shift:", @"Additive Shift:", nil];
            break;
        case QCAffineDecipher:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Multiplicative Shift:", @"Additive Shift:", nil];
            break;
        case QCSplitOffAlphabets:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Wordlength:", nil];
            break;
        case QCPolyMonoCalculator:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword Size:", nil];
            break;
        case QCViginereEncipher:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword:", nil];
            break;
        case QCViginereDecipher:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword:", nil];
            break;
        case QCAutokeyCyphertextAttack:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword Length:", nil];
            break;
        case QCAutokeyPlaintextAttack:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Max Keyword Length:", @"Friedman Range:", nil];
            break;
        case QCAutokeyDecipher:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Keyword:", @"PlainText:", nil];
            break;
        case QCGCDAndInverse:
            optionTitles = [[NSMutableArray alloc] initWithObjects:@"Inverse of:", @"Mod:", nil];            
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{   
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if( component == kMultiplierComponent )
        return [multipliers count];
    return [additives count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 44)];
    if( component == kMultiplierComponent )
        label.text = [NSString stringWithString:[multipliers objectAtIndex:row]];
    else
        label.text = [NSString stringWithString:[additives objectAtIndex:row]];
    label.font = [UIFont systemFontOfSize:22];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end

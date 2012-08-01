//
//  DetailViewController.m
//  QuickCrypt
//
//  Created by build on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "InfoViewController.h"
#import "CAIAppDelegate.h"

@interface DetailViewController ()
{
    double lastStepperValue; // Used to check if increment or decrement of multiplier stepper when setting affine options
    TextData *td;               // Reference to our textData singleton
    NSMutableArray *optionsAry; // Array to hold all the options
    UIView *activeField;        /* The currently active field, used for finding the point where the active field is to scroll point in view
                                 when keyboard is displayed */
}
@property (nonatomic, strong) TextData *td;
@property (nonatomic, strong) CAIAppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *optionsAry;
@property (nonatomic, strong) UIView *activeField;
                   
- (void)setButtonTitles;    // Set the button title per current cyrpto method
- (void)setOptionTitles;    // Set the title of the options per the current crypto method
- (void)getOptionsAndSave;  // Save the current options
- (void)recallOptions;      // Recall last options for the current crypto method
- (void)saveText;           // Save the input and output text currently in textViews
- (void)recallText;         // Recall the input and output texts
- (void)registerForKeyboardNotifications;   // Register the controller to receive keyboard notifications

@end


@implementation DetailViewController

@synthesize popoverController;
@synthesize td;
@synthesize appDelegate = _appDelegate;
@synthesize optionsAry = _optionsAry;

@synthesize splitViewController = _splitViewController;

@synthesize inputText = _inputText;
@synthesize outputText = _outputText;
@synthesize computeButton = _computeButton;
@synthesize cryptoMethod = _cryptoMethod;

@synthesize stepper1 = _stepper1;
@synthesize stepper2 = _stepper2;
@synthesize textField1 = _textField1;
@synthesize textField2 = _textField2;
@synthesize textField3 = _textField3;
@synthesize textField4 = _textField4;
@synthesize switch1 = _switch1;
@synthesize optionsViewMat = _optionsViewMat;
@synthesize GCDViewMat = _GCDViewMat;
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize navController = _navController;

@synthesize scrollView = _scrollView;
@synthesize activeField = _activeField;

#pragma mark - View Lifecycle Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cryptoMethod:(QCCryptoMethod)aCryptoMethod
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cryptoMethod = aCryptoMethod; // Set what the current crypto method is
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get references to our textData singleton and the application delegate
    td = [TextData textDataManager];
    self.appDelegate = (CAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Pull the array of options for this crypto method from our textData instance
    _optionsAry = [td.optionsList objectAtIndex:_cryptoMethod];
    
    
    // Setup the button that will be our compute button
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_computeButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    
    // Set corner radiuses for our textViews and optionsViewMat so they look pretty
    _inputText.layer.cornerRadius = 5;
    _inputText.clipsToBounds = YES;
    
    _outputText.layer.cornerRadius = 5;
    _outputText.clipsToBounds = YES;
    
    _optionsViewMat.layer.cornerRadius = 5;
    _optionsViewMat.clipsToBounds = YES;
    
    
    // Set the placeholders for the input and output textViews
    [_inputText setPlaceholder:@"Input Text"];
    [_outputText setPlaceholder:@"Output Text"];

    [_switch1 setOn:NO]; // By default switch option should be OFF
    
    
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
        [_stepper1 setMinimumValue:0];
        [_stepper1 setStepValue:1];
    }

    
    // For AutoKeyPlaintextAttack textFields two and three should be DecimalPads
    if( cryptoMethod == QCAutokeyPlaintextAttack )
    {
        _textField2.keyboardType = UIKeyboardTypeDecimalPad;
        _textField3.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    
    self.view.frame = _scrollView.bounds;
    _scrollView.contentSize = _scrollView.bounds.size;
    _scrollView.scrollEnabled = NO;
    _scrollView.bounces = YES;
    
    [self registerForKeyboardNotifications];
    [self setButtonTitles];
    [self setOptionTitles];
    [self recallOptions];
    [self recallText];
    
    _activeField = (UIView *)_inputText;
    
//    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
//    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    [infoBtn addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *infoBtnA = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
//    self.splitViewController._infoBtn = infoBtn;
//    self.splitViewController._infoBtnA = infoBtnA;
//    self.splitViewController._flexSpace = flexSpace;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _navController.navigationBarHidden = YES;
    _optionsAry = [td.optionsList objectAtIndex:_cryptoMethod];
    [self setButtonTitles];
	[self configureView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self saveText];
    [self getOptionsAndSave];
}

#pragma mark - Other View Methods
- (void)configureView
{
    // Update the user interface for the detail item.
}

#pragma mark - MGSplitView methods
- (void)splitViewController:(MGSplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc
{
    // If the splitView is to be hidden add the menu button to toolbar items
    _splitViewController = svc;
    svc.toolbar.items = [NSArray arrayWithObjects:svc.menuButton, svc._flexSpace, svc._infoBtn, svc._smallSpace, svc._helpBtn, nil];
    self.popoverController = pc;
}

- (void)splitViewController:(MGSplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;
{
    // If the toolbar is to be hidden remove the menu button from the toolbar
    _splitViewController = svc;
    if (barButtonItem) {
        svc.toolbar.items = [NSArray arrayWithObjects:svc._flexSpace, svc._infoBtn, svc._smallSpace, svc._helpBtn, nil];
	}
    self.popoverController = nil;
}

- (void)splitViewController:(MGSplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController
{
}

#pragma mark - Rotation Methods
// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // On rotate reset the bounds and frame of the scrollview
	_scrollView.bounds = self.view.frame;
    _scrollView.frame = self.view.frame;
}

#pragma mark - Set Buttons
// Set the compute button title appropriately for each cryptomethod
- (void) setButtonTitles
{
    if( _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs || _cryptoMethod == QCNGraphs )
    {
        [_computeButton setTitle: @"Get" forState: UIControlStateNormal];
        [_computeButton setTitle: @"Get" forState: UIControlStateApplication];
        [_computeButton setTitle: @"Get" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCAffineKnownPlaintextAttack || _cryptoMethod == QCAutokeyCyphertextAttack || _cryptoMethod == QCAutokeyPlaintextAttack )
    {
        [_computeButton setTitle: @"Execute" forState: UIControlStateNormal];
        [_computeButton setTitle: @"Execute" forState: UIControlStateApplication];
        [_computeButton setTitle: @"Execute" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCAffineDecipher || _cryptoMethod == QCViginereDecipher || _cryptoMethod == QCAutokeyDecipher )
    {
        [_computeButton setTitle: @"Decipher" forState: UIControlStateNormal];
        [_computeButton setTitle: @"Decipher" forState: UIControlStateApplication];
        [_computeButton setTitle: @"Decipher" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCAffineEncipher || _cryptoMethod == QCViginereEncipher )
    {
        [_computeButton setTitle: @"Encipher" forState: UIControlStateNormal];
        [_computeButton setTitle: @"Encipher" forState: UIControlStateApplication];
        [_computeButton setTitle: @"Encipher" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet )
    {
        [_computeButton setTitle: @"Go" forState: UIControlStateNormal];
        [_computeButton setTitle: @"Go" forState: UIControlStateApplication];
        [_computeButton setTitle: @"Go" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCGCDAndInverse )
    {
        [_computeButton setTitle: @"Calculate" forState: UIControlStateNormal];
        [_computeButton setTitle: @"Calculate" forState: UIControlStateApplication];
        [_computeButton setTitle: @"Calculate" forState: UIControlStateHighlighted];
    }
    else
    {
        [_computeButton setTitle: @"Split" forState: UIControlStateNormal];
        [_computeButton setTitle: @"Split" forState: UIControlStateApplication];
        [_computeButton setTitle: @"Split" forState: UIControlStateHighlighted];
    }
}

// Set the title of options appropriately for the current cryptoMethod
- (void)setOptionTitles
{
    switch ( _cryptoMethod )
    {
        case QCNGraphs:
            _label1.text = @"Length of NGraphs:";
            break;
        case QCAffineKnownPlaintextAttack:
        {
            _label1.text = @"Keyword:";
            _label2.text = @"Shift First:";
        }
            break;
        case QCAffineEncipher:
        {
            _label1.text = @"1";    // TO DO: Pull these values from cached
            _label2.text = @"0";
        }
            break;
        case QCAffineDecipher:
        {
            _label1.text = @"1";    // TO DO: Pull these values from cached
            _label2.text = @"0";
        }
            break;
        case QCSplitOffAlphabets:
            _label1.text = @"Wordlength:";
            break;
        case QCPolyMonoCalculator:
            _label1.text = @"Keyword Size:";
            break;
        case QCViginereEncipher:
            _label1.text = @"Keyword:";
            break;
        case QCViginereDecipher:
            _label1.text = @"Keyword:";
            break;
        case QCAutokeyCyphertextAttack:
            _label1.text = @"Keyword Length:";
            break;
        case QCAutokeyPlaintextAttack:
        {
            _label1.text = @"Max Keyword Length:";
            _label2.text = @"Friedman Range:";
        }
            break;
        case QCAutokeyDecipher:
        {
            _label1.text = @"Keyword:";
            _label2.text = @"PlainText:";
        }
            break;
        default:
            break;
    }
}


#pragma mark - Option Handling Methods
// Recall the options from the last time the current method was displayed
- (void)recallOptions
{
    // Check that the options array is not empty
    if( _optionsAry && [_optionsAry count] > 0 )
    {
        switch ( _cryptoMethod )
        {   // Recall all the appropriate values
            case QCNGraphs:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_textField1.text intValue]];
                break;
            case QCAffineKnownPlaintextAttack:
                _textField1.text = [_optionsAry objectAtIndex:0];
                [_switch1 setOn:[[_optionsAry objectAtIndex:1] boolValue]];
                break;
            case QCAffineEncipher:
                _label1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_label1.text intValue]];
                _label2.text = [_optionsAry objectAtIndex:1];
                [_stepper2 setValue:[_label2.text intValue]];
                break;
            case QCAffineDecipher:
                _label1.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_label1.text intValue]];
                _label2.text = [_optionsAry objectAtIndex:1];
                [_stepper2 setValue:[_label2.text intValue]];
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
                [stepper1 setValue:[textField1.text intValue]];
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

// Add the current options to the options array
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
            _optionsAry = [NSArray arrayWithObjects:_label1.text, _label2.text, nil];
            break;
        case QCAffineDecipher:
           _optionsAry = [NSArray arrayWithObjects:_label1.text, _label2.text, nil];
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
    
    // Update options array for this cryptomethod in the textData singleton
    [td.optionsList replaceObjectAtIndex:_cryptoMethod withObject:_optionsAry];
}

// Everytime the user gets an option we want to save it and then handle the option change appropriately
- (IBAction)didChangeOption:(id)sender
{
    [self getOptionsAndSave];
    
    switch ( _cryptoMethod )
    {
        case QCNGraphs:
            [self stepperValueChanged];
            break;
        case QCAffineKnownPlaintextAttack:
            [_outputText setText:[QCMethods affineKnownPlainttextAttack:[_inputText text] keyword:[_optionsAry objectAtIndex:0] shiftFirst:[[_optionsAry objectAtIndex:1] boolValue]]];
            break;
        case QCAffineEncipher:
            [self multiplierStepperValueChanged];
            [self adderStepperValueChanged];
            break;
        case QCAffineDecipher:
            [self multiplierStepperValueChanged];
            [self adderStepperValueChanged];
            break;
        case QCSplitOffAlphabets:
            [self stepperValueChanged];
            break;
        case QCPolyMonoCalculator:
            [self stepperValueChanged];
            break;
        case QCAutokeyCyphertextAttack:
            [self stepperValueChanged];
            break;
        case QCAutokeyPlaintextAttack:
            [self stepperValueChanged];
            break;
        case QCAutokeyDecipher:
            break;
        case QCGCDAndInverse:
            [self saveText];
            break;
        default:
            break;
    }
}

#pragma mark - Text View Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if( _cryptoMethod != QCGCDAndInverse )
    {   // Whenever text editing begins in a textView enable scrolling of the detailView and set the textView to the activeField
        _activeField = textView;
        _scrollView.scrollEnabled = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{   
    if( _cryptoMethod != QCGCDAndInverse )
    {   // Whenever the user changes text in the textView save it (in case they switch methods while editing the text)
        [self saveText];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if( _cryptoMethod != QCGCDAndInverse )
    {   // When they are done editing text save text, disable scrolling and default the _activeField to the input textView
        [self saveText];
        _scrollView.scrollEnabled = NO;
        _activeField = _inputText;
    }
}

#pragma mark - Text Field Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{   // Whenever the use starts editing text in a field set that field as the activeField
    _activeField = textField;
    _scrollView.scrollEnabled = YES;
}

/* Since we have little control over the type of keyboard displayed on iPad we 
 want to check that each character they try to type is valid for the particular option field being modified */
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
        if( _cryptoMethod == QCAutokeyPlaintextAttack && textField.tag != 0 && string != @"." )
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{   // When user is done editing textField default active field to input and disable scrolling
    _activeField = _inputText;
    _scrollView.scrollEnabled = NO;
}

#pragma mark - Text Recall and Save Methods
- (void)saveText
{
    if( _cryptoMethod == QCGCDAndInverse )
    {   // If GCD and Inverse calculator save the results in an array in textData object
        if( _textField3.text.length > 0 && _textField4.text.length > 0 )
            [td.outputArray replaceObjectAtIndex:_cryptoMethod withObject:[NSArray arrayWithObjects:_textField3.text, _textField4.text, nil]];
    }
    else
    {   // For any other method save the input text and add output text to replace old text for this method
        td.inputString = _inputText.text;
        [td.outputArray replaceObjectAtIndex:_cryptoMethod withObject:_outputText.text];
    }
}

- (void)recallText
{
    if( _cryptoMethod == QCGCDAndInverse )
    {   // For GCD and Inverse get the results from the output array   
        if( [[td.outputArray objectAtIndex:_cryptoMethod] isKindOfClass:[NSArray class]] )
        {
            _textField3.text = [[td.outputArray objectAtIndex:_cryptoMethod] objectAtIndex:0];
            _textField4.text = [[td.outputArray objectAtIndex:_cryptoMethod] objectAtIndex:1];
        }
    }
    else
    {   // For every other method set input string and load the last output text for this method
        _inputText.text = td.inputString;
        [_outputText setText:[td.outputArray objectAtIndex:_cryptoMethod]];
    }
}


#pragma mark - Stepper Value Handling Methods
- (void)stepperValueChanged
{   // Get the stepper value and set it to the textField
    double stepperValue = _stepper1.value;
    _textField1.text = [NSString stringWithFormat:@"%.f", stepperValue];
}

- (void)multiplierStepperValueChanged
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
    

    _label1.text = [NSString stringWithFormat:@"%.f", stepperValue];
    lastStepperValue = stepperValue;    // Update the last stepperValue
}

- (void)adderStepperValueChanged
{   // Get the stepper value and set it to the textField
    double stepperValue = _stepper2.value;
    _label2.text = [NSString stringWithFormat:@"%.f", stepperValue];
}


#pragma mark - Compute Button Pressed
- (IBAction)computeButtonPressed:(id)sender
{
    // Make sure the last character has been validated for any textFields
    [self textField:_textField1 shouldChangeCharactersInRange:NSMakeRange(0, _textField1.text.length) replacementString:@""];
    [self textField:_textField2 shouldChangeCharactersInRange:NSMakeRange(0, _textField1.text.length) replacementString:@""];
    [self textField:_textField3 shouldChangeCharactersInRange:NSMakeRange(0, _textField1.text.length) replacementString:@""];
    [self textField:_textField4 shouldChangeCharactersInRange:NSMakeRange(0, _textField1.text.length) replacementString:@""];
    
    // Save any options
    [self getOptionsAndSave];
    
    if( [_inputText isEmpty] )
    {   // If text has not been input, prompt the user to input text
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Text" message:@"Please input text" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        BOOL valid_options = YES; // Tracks if the options are valid (or rather all have been set), default assume yes
        
         // The following methods do not have any options to set
        if( ( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs ) || ( _cryptoMethod == QCGCDAndInverse && td.inputArray.count > 1 ) )
            valid_options = YES;
        else
        {
//            BOOL valid_options = YES;
            
//            if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs )
//                valid_options = YES;
//            else
//            {
            
            // If the options array exist and is not empty
                if( _optionsAry && [_optionsAry count] > 0 )
                {
                    for( int x = 0; x < [_optionsAry count]; x++ )
                    {   // Loop through each of the options
                        if( [[_optionsAry objectAtIndex:x] isKindOfClass:[NSArray class]] )
                        {   // Check if the option is an array that it is not empty
                            if( [[_optionsAry objectAtIndex:x] count] == 0 )
                                valid_options = NO; // If any array in the options is empty then valid options is NO
                        }                        
                    }
                    
                }
                else
                    valid_options = NO;
//            }
        }
        
        if( valid_options )
        {   // If the options are valid run the appropriate method given input text and any options
            _outputText.textColor = [UIColor blackColor];
            switch ( _cryptoMethod )
            {
                case QCFrequencyCount:
                    [_outputText setText:[QCMethods frequencyCount:[_inputText text]]];
                    break;
                case QCRunTheAlphabet:
                    [_outputText setText:[QCMethods runTheAlphabet:[_inputText text]]];
                    break;
                case QCBiGraphs:
                    [_outputText setText:[QCMethods getBigraphs:[_inputText text]]];
                    break;
                case QCTriGraphs:
                    [_outputText setText:[QCMethods getTrigraphs:[_inputText text]]];
                    break;
                case QCNGraphs:
                    [_outputText setText:[QCMethods getNgraphs:[_inputText text] lengthOfNgraphs:[[_optionsAry objectAtIndex:0] intValue]]];
                    break;
                case QCAffineKnownPlaintextAttack:
                    [_outputText setText:[QCMethods affineKnownPlainttextAttack:[_inputText text] keyword:[_optionsAry objectAtIndex:0] shiftFirst:[[_optionsAry objectAtIndex:1] boolValue]]];
                    break;
                case QCAffineEncipher:
                    [_outputText setText:[QCMethods affineEncipher:[_inputText text] multiplicativeShift:[[_optionsAry objectAtIndex:0] intValue] additiveShift:[[_optionsAry objectAtIndex:1] intValue]]];
                    break;
                case QCAffineDecipher:
                    [_outputText setText:[QCMethods affineDecipher:[_inputText text] multiplicativeShift:[[_optionsAry objectAtIndex:0] intValue] additiveShift:[[_optionsAry objectAtIndex:1] intValue]]];
                    break;
                case QCSplitOffAlphabets:
                    [_outputText setText:[QCMethods stripOffTheAlphabets:[_inputText text] wordLength:[[_optionsAry objectAtIndex:0] intValue]]];
                    break;
                case QCPolyMonoCalculator:
                    [_outputText setText:[QCMethods polyMonoCalculator:[_inputText text] keywordSize:[[_optionsAry objectAtIndex:0] intValue]]];
                    break;
                case QCViginereEncipher:
                    [_outputText setText:[QCMethods viginereEncipher:[_inputText text] keyword:[_optionsAry objectAtIndex:0]]];
                    break;
                case QCViginereDecipher:
                    [_outputText setText:[QCMethods viginereDecipher:[_inputText text] keyword:[_optionsAry objectAtIndex:0]]];
                    break;
                case QCAutokeyCyphertextAttack:
                    [_outputText setText:[QCMethods autoKeyCyphertextAttack:[_inputText text] keywordLength:[[_optionsAry objectAtIndex:0] intValue]]];
                    break;
                case QCAutokeyPlaintextAttack:
                    [_outputText setText:[QCMethods autoKeyPlaintextAttack:[_inputText text] maxKeywordLength:[[_optionsAry objectAtIndex:0] intValue] lowerFriedmanCutoff:[[_optionsAry objectAtIndex:1] doubleValue] upperFriedmanCutoff:[[_optionsAry objectAtIndex:2] doubleValue]]];
                    break;
                case QCAutokeyDecipher:
                    [_outputText setText:[QCMethods autoKeyDecipher:[_inputText text] withKeyword:[_optionsAry objectAtIndex:0] plain:[[_optionsAry objectAtIndex:1 ] boolValue]]];
                    break;
                case QCGCDAndInverse:
                    if( [[_textField1 text] isEqualToString:@""] || [[_textField2 text] isEqualToString:@""] )
                    {   // Make sure they've filled in the mod and inverse of fields
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fill in Fields" message:@"Please fill in the Inverse of and Mod fields" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                    }
                    else
                    {   // If mod and inverse of fields are given run calculation
                        NSArray *results = [QCMethods GCDandInverse:[[_textField1 text] intValue] mod:[[_textField2 text] intValue]];
                        if( [results count] == 2 )
                        {
                            _textField3.text = [[results objectAtIndex:0] stringValue];
                            _textField4.text = [results objectAtIndex:1];
                        }
                        else
                        {
                            _textField3.text =[[results objectAtIndex:0] stringValue];
                            _textField4.text = @"Error";
                        }
                    }
                default:
                    break;
            }
        }
        else
        {   // If not valid options, prompt the user for valid options
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Options" message:@"Please select options first" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
            [alert show];
        }
    }
    
    [self saveText]; // Save the text
}

#pragma mark - Keyboard Notification Methods
// Register this view controller for keyboard notifications
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
    UIEdgeInsets contentInsets;
    if( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation] ) )
    {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    }
    else
    {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, 90.0, -80.0);
    }
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _scrollView.frame;
    aRect.size.height -= kbSize.height;
    
    CGPoint point = [_activeField convertPoint:_activeField.frame.origin toView:self.view];
    if (!CGRectContainsPoint(aRect, point) && _activeField.tag != 1)
    {
        CGPoint scrollPoint;
        if( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation] ) )
           scrollPoint = CGPointMake(0.0, point.y-kbSize.height*2-20);
        else
        {
            if( _cryptoMethod == QCGCDAndInverse )
                scrollPoint = CGPointMake(0.0, 175.0);
            else
                scrollPoint = CGPointMake(0.0, 352.0);
        }
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{   // When the keyboard is hidden scroll view back to normal
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    _scrollView.frame = self.view.frame;
    [_scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

@end

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
    TextData *td;
    NSMutableArray *optionsAry;
    UIView *activeField;
}
@property (nonatomic, strong) TextData *td;
@property (nonatomic, strong) CAIAppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *optionsAry;
@property (nonatomic, strong) UIView *activeField;
- (void)configureView;
- (void)setButtonTitles;
- (void)setOptionTitles;
- (void)getOptionsAndSave;
- (void)recallOptions;
- (void)saveText;
- (void)recallText;
- (void)registerForKeyboardNotifications;

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
@synthesize optionsViewMat2 = _optionsViewMat2;
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
        self.cryptoMethod = aCryptoMethod;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    td = [TextData textDataManager];
    self.appDelegate = (CAIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _optionsAry = [td.optionsList objectAtIndex:_cryptoMethod];
    
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_computeButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    
    _inputText.layer.cornerRadius = 5;
    _inputText.clipsToBounds = YES;
    
    _outputText.layer.cornerRadius = 5;
    _outputText.clipsToBounds = YES;
    
    _optionsViewMat.layer.cornerRadius = 5;
    _optionsViewMat.clipsToBounds = YES;
    
    _optionsViewMat2.layer.cornerRadius = 5;
    _optionsViewMat2.clipsToBounds = YES;
    
    [_inputText setPlaceholder:@"Input Text"];
    [_outputText setPlaceholder:@"Output Text"];

    [_switch1 setOn:NO];

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
    _splitViewController = svc;
    svc.toolbar.items = [NSArray arrayWithObjects:svc.menuButton, svc._flexSpace, svc._infoBtn, svc._smallSpace, svc._helpBtn, nil];
    self.popoverController = pc;
}

- (void)splitViewController:(MGSplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;
{
    _splitViewController = svc;
    if (barButtonItem) {
        svc.toolbar.items = [NSArray arrayWithObjects:svc._flexSpace, svc._infoBtn, svc._smallSpace, svc._helpBtn, nil];
	}
    self.popoverController = nil;
}

- (void)splitViewController:(MGSplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController
{
}

- (IBAction)toggleMasterView:(id)sender
{
	[_splitViewController toggleMasterView:sender];
	[self configureView];
}

#pragma mark - Rotation Methods
// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	_scrollView.bounds = self.view.frame;
    _scrollView.frame = self.view.frame;
}

#pragma mark - Set Buttons
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
    [td.optionsList replaceObjectAtIndex:_cryptoMethod withObject:_optionsAry];
}

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
//            [self formatFloat:sender];
            [self saveText];
            break;
        default:
            break;
    }
}

#pragma mark - Text View Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if( _cryptoMethod == QCGCDAndInverse )
    {
        
    }
    else
    {
        _activeField = textView;
        _scrollView.scrollEnabled = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if( _cryptoMethod == QCGCDAndInverse )
    {
        
    }
    else
    {
        [self saveText];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if( _cryptoMethod == QCGCDAndInverse )
    {
        
    }
    else
    {
        [self saveText];
        _scrollView.scrollEnabled = NO;
        _activeField = _inputText;
    }
}

#pragma mark - Text Field Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
    _scrollView.scrollEnabled = YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *badCharacters;
    
    if( textField.tag != 0 )
    {
        if( [string compare:@"."] == NSOrderedSame && [textField.text rangeOfString:@"." options:0 range:NSMakeRange(0, textField.text.length)].location != NSNotFound )
            return NO;
    }
    
    if( string != @"" )
    {
        if( _cryptoMethod == QCAutokeyPlaintextAttack && textField.tag != 0 && string != @"." )
            badCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@",?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        else if( _cryptoMethod == QCNGraphs || _cryptoMethod == QCSplitOffAlphabets || _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCAutokeyCyphertextAttack || _cryptoMethod == QCAutokeyPlaintextAttack || _cryptoMethod == QCGCDAndInverse )
        {
            badCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@".,?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0"];
            if ( string.length > 0 && ![badCharacters characterIsMember:[string characterAtIndex:0]] && textField.tag == 0 )
                [_stepper1 setValue:[[_textField1.text stringByAppendingString:string] doubleValue]];
            else if( string.length <= 0 && textField.tag == 0 )
                [_stepper1 setValue:[[_textField1.text substringToIndex:_textField1.text.length-1] doubleValue]];
        }
        else
            badCharacters = [NSCharacterSet characterSetWithCharactersInString:@".,?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•1234567890"];
        
        if( string.length > 0 && [badCharacters characterIsMember:[string characterAtIndex:0]] )
            return NO;
    }
        
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = _inputText;
    _scrollView.scrollEnabled = NO;
}

#pragma mark - Text Recall and Save Methods
- (void)saveText
{
    if( _cryptoMethod == QCGCDAndInverse )
    {        
        if( _textField3.text.length > 0 && _textField4.text.length > 0 )
            [td.outputArray replaceObjectAtIndex:_cryptoMethod withObject:[NSArray arrayWithObjects:_textField3.text, _textField4.text, nil]];
    }
    else
    {
        td.inputString = _inputText.text;
        [td.outputArray replaceObjectAtIndex:_cryptoMethod withObject:_outputText.text];
    }
}

- (void)recallText
{
    if( _cryptoMethod == QCGCDAndInverse )
    {        
        if( [[td.outputArray objectAtIndex:_cryptoMethod] isKindOfClass:[NSArray class]] )
        {
            _textField3.text = [[td.outputArray objectAtIndex:_cryptoMethod] objectAtIndex:0];
            _textField4.text = [[td.outputArray objectAtIndex:_cryptoMethod] objectAtIndex:1];
        }
    }
    else
    {
        _inputText.text = td.inputString;
        [_outputText setText:[td.outputArray objectAtIndex:_cryptoMethod]];
    }
}


#pragma mark - Stepper Value Handling Methods
- (void)stepperValueChanged
{
    double stepperValue = _stepper1.value;
    _textField1.text = [NSString stringWithFormat:@"%.f", stepperValue];
}

- (void)multiplierStepperValueChanged
{
    double stepperValue = _stepper1.value;
    if( stepperValue == 13 )
    {
        if ( stepperValue - lastStepperValue >= 0 )
            stepperValue = 15;
        else
            stepperValue = 11;
        
        [_stepper1 setValue:stepperValue];
    }
    

    _label1.text = [NSString stringWithFormat:@"%.f", stepperValue];
    lastStepperValue = stepperValue;
}

- (void)adderStepperValueChanged
{
    double stepperValue = _stepper2.value;
    _label2.text = [NSString stringWithFormat:@"%.f", stepperValue];
}


#pragma mark - Compute Button Pressed
- (IBAction)computeButtonPressed:(id)sender
{
    [self textField:_textField1 shouldChangeCharactersInRange:NSMakeRange(0, _textField1.text.length) replacementString:@""];
    [self textField:_textField2 shouldChangeCharactersInRange:NSMakeRange(0, _textField1.text.length) replacementString:@""];
    [self textField:_textField3 shouldChangeCharactersInRange:NSMakeRange(0, _textField1.text.length) replacementString:@""];
    [self textField:_textField4 shouldChangeCharactersInRange:NSMakeRange(0, _textField1.text.length) replacementString:@""];
    [self getOptionsAndSave];
    
    if( [_inputText isEmpty] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Text" message:@"Please input text" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        BOOL valid_options = YES;
        
        if( ( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs ) || ( _cryptoMethod == QCGCDAndInverse && td.inputArray.count > 1 ) )
            valid_options = YES;
        else
        {
            BOOL valid_options = YES;
            
            if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs )
                valid_options = YES;
            else
            {
                if( _optionsAry && [_optionsAry count] > 0 )
                {
                    for( int x = 0; x < [_optionsAry count]; x++ )
                    {
                        if( [[_optionsAry objectAtIndex:x] isKindOfClass:[NSArray class]] )
                        {
                            if( [[_optionsAry objectAtIndex:x] count] == 0 )
                                valid_options = NO;
                        }                        
                    }
                    
                }
                else
                    valid_options = NO;
            }
        }
        
        if( valid_options )
        {
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
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fill in Fields" message:@"Please fill in the Inverse of and Mod fields" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                    }
                    else
                    {
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
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Options" message:@"Please select options first" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
            [alert show];
        }
    }
    
    [self saveText];
}

#pragma mark - Keyboard Notification Methods
// Call this method somewhere in your view controller setup code.
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
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    _scrollView.frame = self.view.frame;
    [_scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

#pragma mark - Format Floats from fields
- (IBAction)formatFloat:(id)sender
{
    if( (UITextField *)sender )
    {
        NSString *inputString = [(UITextField *)sender text];
        NSMutableString *mutableString = [[NSMutableString alloc] initWithString:inputString];
        NSCharacterSet *badCharacters;
        
        if( ((UITextField *)sender).tag != 0 )
        {
            if( inputString.length > 1 )
            {
                if( [inputString characterAtIndex:inputString.length-1] == '.' && [inputString rangeOfString:@"." options:0 range:NSMakeRange(0, inputString.length-2)].location != NSNotFound )
                    [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length-1, 1)];
            }
            inputString = mutableString;
        }
        
        if( _cryptoMethod == QCAutokeyPlaintextAttack && inputString.length > 1 && ((UITextField *)sender).tag !=0 && [inputString rangeOfString:@"." options:0 range:NSMakeRange(0, inputString.length)].location != NSNotFound )
            badCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@",?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        else if( _cryptoMethod == QCNGraphs || _cryptoMethod == QCSplitOffAlphabets || _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCAutokeyCyphertextAttack || _cryptoMethod == QCAutokeyPlaintextAttack || _cryptoMethod == QCGCDAndInverse )
        {
            badCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@".,?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
            [_stepper1 setValue:[inputString doubleValue]];
        }
        else
            badCharacters = [NSCharacterSet characterSetWithCharactersInString:@".,?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•1234567890"];
        
        inputString = [NSMutableString stringWithString:[[inputString componentsSeparatedByCharactersInSet:badCharacters] componentsJoinedByString:@""]];
        [(UITextField *)sender setText:inputString];
    }
}

//- (void)infoButtonPressed
//{
//    InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
//    [_splitViewController displayInfoPopover:infoViewController];
//}

@end

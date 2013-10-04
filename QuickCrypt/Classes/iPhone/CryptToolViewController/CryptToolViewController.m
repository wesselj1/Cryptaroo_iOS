//
//  CryptToolViewController.m
//  QuickCrypt
//
//  Created by build on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CryptToolViewController.h"
#import "OptionsViewController.h"
#import "UIViewController+overView.h"

@interface CryptToolViewController ()
{
    NSMutableArray *options;        // Array of the options this crypto method
    NSMutableArray *optionTitles;   // Array of the titles for the options
    TextData *td;                   // Instance of textData class
}
@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, strong) NSMutableArray *optionTitles;
@property (nonatomic, strong) TextData *td;
@property (nonatomic, strong) UIView *curtainView;

- (void)setButtonTitles;    // Sets the title of the compute button appropriately
- (void)infoButtonPressed;  // Present the info view when info button pressed

@end


@implementation CryptToolViewController

@synthesize backgroundButton = _backgroundButton;
@synthesize inputText = _inputText;
@synthesize options = _options;
@synthesize optionTitles = _optionTitles;
@synthesize outputText = _outputText;
@synthesize computeButton = _computeButton;
@synthesize optionButton = _optionButton;
@synthesize cryptoMethod = _cryptoMethod;
@synthesize divider = _divider;
@synthesize buttonDivider = _buttonDivider;
@synthesize inputTextTopConstraint_7 = _inputTextTopConstraint_7;
@synthesize td;

- (id)initWithCryptoType:(QCCryptoMethod)method
{
    if ((self = [super initWithNibName:@"CryptToolViewController" bundle:nil])) {
        _cryptoMethod = method;
        _options = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    td = [TextData textDataManager];                            // Get an instance of the textData class
    _options = [td.optionsList objectAtIndex:_cryptoMethod];    // Pull the options from the textData class for this crypto method
    
    // Set the divider color
    _divider.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
    _buttonDivider.backgroundColor = [UIColor colorWithWhite:102/255.0 alpha:1.0];
    
    // The following methods do not have options to set
    if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs )
        _optionButton.enabled = NO;
    
    [_inputText setFont:[UIFont fontWithName:@"CourierNewPSMT" size:16.0]];
    [_inputText setTextColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]];
    [_outputText setFont:[UIFont fontWithName:@"CourierNewPSMT" size:16.0]];
    [_outputText setTextColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]];
    
    
    // Set the placeholders for our textViews
    [_inputText setPlaceholder:@"INPUT TEXT"];
    [_outputText setPlaceholder:@"OUTPUT TEXT"];
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [_inputText setTintColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
        [_outputText setTintColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    }
    
    // Recall the input and output texts from textData
    _inputText.text = td.inputString;
    [_outputText setText:[td.outputArray objectAtIndex:_cryptoMethod]];
    
    // Set the back button for the navbar
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [back setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"Fairview-SmallCaps" size:20.0]} forState:UIControlStateNormal];
    [self.navigationItem setBackBarButtonItem:back];
    
    // Create the info button
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoBtn addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        space.width = 0.0f;
    } else {
        space.width = 10.0f;
    }
    self.navigationItem.rightBarButtonItems = @[space, infoBarButtonItem];
    
//    // If iOS 6, set appropriate constraint for inputText
//    if(SYSTEM_VERSION_LESS_THAN(@"7.0")) {
//        [self.view removeConstraint:_inputTextTopConstraint_7];
//        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_inputText);
//        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_inputText]"
//                                                options:0
//                                                metrics:nil
//                                                  views:viewsDict];
//        [self.view addConstraints:constraints];
//        
//    }

    [self textViewDidChange:_inputText];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setButtonTitles];  // Set the compute button title
    _options = [td.optionsList objectAtIndex:_cryptoMethod];  // Get the options for this crypto method
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    // If the view is going to be removed save the input and output texts
    [td.outputArray replaceObjectAtIndex:_cryptoMethod withObject:[_outputText text]];
    td.inputString = [NSString stringWithString:[_inputText text]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissKeyboard:(id)sender
{
    [_inputText resignFirstResponder];
    [_outputText resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if( [_inputText.text isEqualToString:@""] )
    {
        [_inputText setPlaceholder:@"Input Text"];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // If they hit the return button on the keyboard, dismiss the keyboard
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES; // Any other key will allow text change
}

- (void)textViewDidChange:(UITextView *)textView
{
    if( textView == _inputText )
    {
        if( [textView.text isEqualToString:@""] || [self isStringOnlyWhiteSpace:textView.text] )
        {
            [_computeButton setEnabled:NO];
        }
        else
        {
            [_computeButton setEnabled:YES];
        }
    }
}

- (IBAction)setOptionsPressed:(id)sender
{
    // If the method has options present the options view controller for the crypto method with the options array we ahve
    if( _cryptoMethod != QCFrequencyCount && _cryptoMethod != QCRunTheAlphabet && _cryptoMethod != QCBiGraphs && _cryptoMethod != QCTriGraphs )
    {
        OptionsViewController *optionsViewController;
        
        // Make sure the options array isn't empty
        if ( [td.optionsList objectAtIndex:_cryptoMethod] != nil )
            _options = [NSMutableArray arrayWithArray:[td.optionsList objectAtIndex:_cryptoMethod]];
        
        switch ( _cryptoMethod )
        {
            case QCNGraphs:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet1" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCAffineKnownPlaintextAttack:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet2" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCAffineEncipher:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet3" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCAffineDecipher:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet3" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCSplitOffAlphabets:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet1" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCPolyMonoCalculator:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet1" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCViginereEncipher:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet4" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCViginereDecipher:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet4" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCAutokeyCyphertextAttack:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet1" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCAutokeyPlaintextAttack:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet5" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            case QCAutokeyDecipher:
                optionsViewController = [[OptionsViewController alloc] initWithNibName:@"OptionsSet2" bundle:nil forMethod:_cryptoMethod withOptions:_options];
                break;
            default:
                break;
        }
        optionsViewController.title = @"Options";
        optionsViewController.delegate = self;
//        [self.navigationController pushViewController:optionsViewController animated:YES];
        
//        optionsViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//        [self presentViewController:optionsViewController animated:YES completion:nil];
        
        [self addCurtainView];
        [self.navigationController addChildViewController:optionsViewController];
        [self.navigationController.view addSubview:optionsViewController.view];
        optionsViewController.view.center = self.view.center;
        
        if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
            optionsViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y-20);
        } else {
            optionsViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y+20);
        }
    }
    else 
    {   // If no options, tell user there are no options for this method
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Options" message:@"There are no options for this method" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)computeButtonPressed:(id)sender
{
    if( [_inputText isEmpty] )
    {   // If there is no input text, prompt the user to enter text
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Text" message:@"Please input text" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        BOOL valid_options = YES; // Assume options are valid
        
        if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs )
            valid_options = YES;  // Above methods have no options to set
        else
        {
            // Make sure there are options and that if a particular option is an array that the array is not empty
            if( _options && [_options count] > 0 )
            {
                for( int x = 0; x < [_options count]; x++ )
                {
                    if( [[_options objectAtIndex:x] isKindOfClass:[NSArray class]] )
                    {
                        if( [[_options objectAtIndex:x] count] == 0 )
                            valid_options = NO; // If the array is empty, no valid options
                    }                        
                }

            }
            else // If the options array is empty, there are not valid options
                valid_options = NO;
        }
        
        // If there are valid options then run the appropriate method given the text and provided options
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
                    [_outputText setText:[QCMethods getNgraphs:[_inputText text] lengthOfNgraphs:[[_options objectAtIndex:0] intValue]]];
                    break;
                case QCAffineKnownPlaintextAttack:
                    [_outputText setText:[QCMethods affineKnownPlainttextAttack:[_inputText text] keyword:[_options objectAtIndex:0] shiftFirst:[[_options objectAtIndex:1] boolValue]]];
                    break;
                case QCAffineEncipher:
                    [_outputText setText:[QCMethods affineEncipher:[_inputText text] multiplicativeShift:[[_options objectAtIndex:0] intValue] additiveShift:[[_options objectAtIndex:1] intValue]]];
                    break;
                case QCAffineDecipher:
                    [_outputText setText:[QCMethods affineDecipher:[_inputText text] multiplicativeShift:[[_options objectAtIndex:0] intValue] additiveShift:[[_options objectAtIndex:1] intValue]]];
                    break;
                case QCSplitOffAlphabets:
                    [_outputText setText:[QCMethods stripOffTheAlphabets:[_inputText text] wordLength:[[_options objectAtIndex:0] intValue]]];
                    break;
                case QCPolyMonoCalculator:
                    [_outputText setText:[QCMethods polyMonoCalculator:[_inputText text] keywordSize:[[_options objectAtIndex:0] intValue]]];
                    break;
                case QCViginereEncipher:
                    [_outputText setText:[QCMethods viginereEncipher:[_inputText text] keyword:[_options objectAtIndex:0]]];
                    break;
                case QCViginereDecipher:
                    [_outputText setText:[QCMethods viginereDecipher:[_inputText text] keyword:[_options objectAtIndex:0]]];
                    break;
                case QCAutokeyCyphertextAttack:
                    [_outputText setText:[QCMethods autoKeyCyphertextAttack:[_inputText text] keywordLength:[[_options objectAtIndex:0] intValue]]];
                    break;
                case QCAutokeyPlaintextAttack:
                    [_outputText setText:[QCMethods autoKeyPlaintextAttack:[_inputText text] maxKeywordLength:[[_options objectAtIndex:0] intValue] lowerFriedmanCutoff:[[_options objectAtIndex:1] doubleValue] upperFriedmanCutoff:[[_options objectAtIndex:2] doubleValue]]];
                    break;
                case QCAutokeyDecipher:
                    [_outputText setText:[QCMethods autoKeyDecipher:[_inputText text] withKeyword:[_options objectAtIndex:0] plain:[[_options objectAtIndex:1 ] boolValue]]];
                    break;
                default:
                    break;
            }
        }
        else
        {   // If not valid options, ask the user to select the options
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Options" message:@"Please select options first" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)setButtonTitles
{   // Set the computer button title appropriate for the method
    if( _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs || _cryptoMethod == QCNGraphs )
    {
        [_computeButton setTitle: @"GET" forState: UIControlStateNormal];
        [_computeButton setTitle: @"GET" forState: UIControlStateApplication];
        [_computeButton setTitle: @"GET" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCAffineKnownPlaintextAttack || _cryptoMethod == QCAutokeyCyphertextAttack || _cryptoMethod == QCAutokeyPlaintextAttack )
    {
        [_computeButton setTitle: @"EXECUTE" forState: UIControlStateNormal];
        [_computeButton setTitle: @"EXECUTE" forState: UIControlStateApplication];
        [_computeButton setTitle: @"EXECUTE" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCAffineDecipher || _cryptoMethod == QCViginereDecipher || _cryptoMethod == QCAutokeyDecipher )
    {
        [_computeButton setTitle: @"DECIPHER" forState: UIControlStateNormal];
        [_computeButton setTitle: @"DECIPHER" forState: UIControlStateApplication];
        [_computeButton setTitle: @"DECIPHER" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCAffineEncipher || _cryptoMethod == QCViginereEncipher )
    {
        [_computeButton setTitle: @"ENCIPHER" forState: UIControlStateNormal];
        [_computeButton setTitle: @"ENCIPHER" forState: UIControlStateApplication];
        [_computeButton setTitle: @"ENCIPHER" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet )
    {
        [_computeButton setTitle: @"GO" forState: UIControlStateNormal];
        [_computeButton setTitle: @"GO" forState: UIControlStateApplication];
        [_computeButton setTitle: @"GO" forState: UIControlStateHighlighted];
    }
    else if( _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCGCDAndInverse )
    {
        [_computeButton setTitle: @"CALCULATE" forState: UIControlStateNormal];
        [_computeButton setTitle: @"CALCULATE" forState: UIControlStateApplication];
        [_computeButton setTitle: @"CALCULATE" forState: UIControlStateHighlighted];
    }
    else
    {
        [_computeButton setTitle: @"SPLIT" forState: UIControlStateNormal];
        [_computeButton setTitle: @"SPLIT" forState: UIControlStateApplication];
        [_computeButton setTitle: @"SPLIT" forState: UIControlStateHighlighted];
    }
}


#pragma mark - OptionsViewControllerDelegate Methods
- (void)dismissOptionsViewController:(OptionsViewController *)viewController
{
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    [self removeCurtainView];
}

- (void)dismissandApplyOptionsViewController:(OptionsViewController *)viewController
{
    _options = [td.optionsList objectAtIndex:_cryptoMethod];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    [self removeCurtainView];
}

#pragma mark - HelpViewControllerDelegate Methods
- (void)dismissHelpViewController:(HelpViewController *)viewController {
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [viewController.view removeFromSuperview];
    } else {
        [viewController.rootView removeFromSuperview];
    }
    [viewController removeFromParentViewController];
    [self removeCurtainView];
}

- (void)removeCurtainView
{
    [_curtainView removeFromSuperview];
    _curtainView = nil;
}

- (void)addCurtainView
{
    _curtainView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    _curtainView.exclusiveTouch = YES;
    _curtainView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    [self.navigationController.view addSubview:_curtainView];
}

- (void)infoButtonPressed
{   // If info button is pressed, in this case we will present a help blurb about the method
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HelpInfo" ofType:@"plist"];
//    NSDictionary *helpDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    NSArray *helpArray = [NSArray arrayWithArray:[helpDict valueForKey:@"QCHelpStrings"]];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:[helpArray objectAtIndex:_cryptoMethod] delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
//    [alert show];
    
    HelpViewController *helpViewController = [[HelpViewController alloc] init];
    helpViewController.delegate = self;
    helpViewController.cryptoMethod = self.cryptoMethod;
    
    [self addCurtainView];
    [self.navigationController addChildViewController:helpViewController];
    [self.navigationController.view addSubview:helpViewController.view];
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        helpViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y-20);
    } else {
        helpViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y+20);
    }
    
}

- (BOOL)isStringOnlyWhiteSpace:(NSString *)string
{
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [string stringByTrimmingCharactersInSet:whiteSpace];
    if( trimmed.length == 0 )
        return YES;
    return NO;
}


@end

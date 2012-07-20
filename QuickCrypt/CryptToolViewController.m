//
//  CryptToolViewController.m
//  QuickCrypt
//
//  Created by build on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CryptToolViewController.h"
#import "OptionsViewController.h"

@interface CryptToolViewController ()
{
    NSMutableArray *options;
    NSMutableArray *optionTitles;
    TextData *td;
}
@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, strong) NSMutableArray *optionTitles;
@property (nonatomic, strong) TextData *td;

- (void)setButtonTitles;
- (void)infoButtonPressed;

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
    td = [TextData textDataManager];
    _options = [td.optionsList objectAtIndex:_cryptoMethod];
    
    [super viewDidLoad];
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_computeButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    
    UIImage *whiteButtonImage = [[UIImage imageNamed:@"whiteButton.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_optionButton setBackgroundImage:whiteButtonImage forState:UIControlStateNormal];
    
    if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs )
        _optionButton.enabled = NO;
    
    _inputText.layer.cornerRadius = 5;
    _inputText.clipsToBounds = YES;
    
    _outputText.layer.cornerRadius = 5;
    _outputText.clipsToBounds = YES;
    
    [_inputText setPlaceholder:@"Input Text"];
    [_outputText setPlaceholder:@"Output Text"];
    
    
    _inputText.text = td.inputString;
    [_outputText setText:[td.outputArray objectAtIndex:_cryptoMethod]];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:back];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    [infoBtn addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self setButtonTitles];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setButtonTitles];
    _options = [td.optionsList objectAtIndex:_cryptoMethod];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if( _inputText.tag == 0 )
    {
        _inputText.textColor = [UIColor blackColor];
        _inputText.text = @"";
        _inputText.tag = 1;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if( [_inputText.text isEqualToString:@""] )
    {
        _inputText.text = @"Input text";
        _inputText.textColor = [UIColor lightGrayColor];
        _inputText.tag = 0;
    }
    //[td.outputArray replaceObjectAtIndex:_cryptoMethod withObject:[_outputText text]];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)setOptionsPressed:(id)sender
{
    if( _cryptoMethod != QCFrequencyCount && _cryptoMethod != QCRunTheAlphabet && _cryptoMethod != QCBiGraphs && _cryptoMethod != QCTriGraphs )
    {
        OptionsViewController *optionsViewController;
        if ( [td.optionsList objectAtIndex:_cryptoMethod] != @"")
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
        [self.navigationController pushViewController:optionsViewController animated:YES];
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Options" message:@"There are no options for this method" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)computeButtonPressed:(id)sender
{
    if( [_inputText isEmpty] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Text" message:@"Please input text" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        BOOL valid_options = YES;
        
        if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs )
            valid_options = YES;
        else
        {
            if( _options && [_options count] > 0 )
            {
                for( int x = 0; x < [_options count]; x++ )
                {
                    if( [[_options objectAtIndex:x] isKindOfClass:[NSArray class]] )
                    {
                        if( [[_options objectAtIndex:x] count] == 0 )
                            valid_options = NO;
                    }                        
                }

            }
            else
                valid_options = NO;
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
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Options" message:@"Please select options first" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
            [alert show];
        }
    }
}

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

- (void)infoButtonPressed
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HelpInfo" ofType:@"plist"];
    NSDictionary *helpDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *helpArray = [NSArray arrayWithArray:[helpDict valueForKey:@"QCHelpStrings"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:[helpArray objectAtIndex:_cryptoMethod] delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
    [alert show];
}


@end

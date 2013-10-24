//
//  DetailViewController.m
//  QuickCrypt
//
//  Created by build on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "InfoViewController.h"
#import "AppDelegate.h"
#import "KSCustomPopoverBackgroundView.h"
#import "MBProgressHUD.h"

@interface DetailViewController ()
{
    double lastStepperValue; // Used to check if increment or decrement of multiplier stepper when setting affine options
    TextData *td;               // Reference to our textData singleton
    NSArray *optionsAry;        // Array to hold all the options
    UIView *activeField;        /* The currently active field, used for finding the point where the active field is to scroll point in view
                                 when keyboard is displayed */
}
@property (nonatomic, strong) TextData *td;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *optionsAry;
@property (nonatomic, strong) UIView *activeField;
@property (nonatomic, strong) UIPopoverController *infoPopover;

@property (nonatomic, strong) UIBarButtonItem *flexSpace;
@property (nonatomic, strong) UIBarButtonItem *helpButton;
@property (nonatomic, strong) UIBarButtonItem *infoButton;
@property (nonatomic, strong) UIBarButtonItem *rightSpace;
@property (nonatomic, strong) UIBarButtonItem *smallSpace;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *inputHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *outputHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *inputWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *outputWidth;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonWidth;
@property (nonatomic, strong) UIView *curtainView;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic) dispatch_queue_t cryptQueue;

@property (nonatomic) BOOL redisplayHelp;
                   
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
@synthesize rootViewController = _rootViewController;
@synthesize methodTitle = _methodTitle;

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
@synthesize label3 = _label3;
@synthesize label4 = _label4;
@synthesize navController = _navController;
@synthesize multiplicativeLabel = _multiplicativeLabel;
@synthesize additiveLabel = _additiveLabel;

@synthesize scrollView = _scrollView;
@synthesize activeField = _activeField;
@synthesize divider1 = _divider1;
@synthesize divider2 = _divider2;

#pragma mark - View Lifecycle Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cryptoMethod:(QCCryptoMethod)aCryptoMethod
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cryptoMethod = aCryptoMethod; // Set what the current crypto method is
        self.redisplayHelp = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cryptQueue = dispatch_queue_create("cryptQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    self.navigationController.navigationBar.translucent = NO;
    [self setTitleForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    
    // Get references to our textData singleton and the application delegate
    td = [TextData textDataManager];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
    
    _divider1.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
    _divider2.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
    
    // Pull the array of options for this crypto method from our textData instance
    _optionsAry = [td.optionsList objectAtIndex:_cryptoMethod];
    
    // Set the back button for the navbar
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [_menuButton setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"Fairview-SmallCaps" size:28.0]} forState:UIControlStateNormal];
    } else {
        [_menuButton setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"Fairview-SmallCaps" size:20.0]} forState:UIControlStateNormal];
    }
    
    // Create an info/about button
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *infoBtnA = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    [infoBtn addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.infoButton = infoBtnA;
    
    // Create a help button
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    helpButton.frame = CGRectMake(0, 0, 20, 20);
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [helpButton setImage:[UIImage imageNamed:@"HelpButton.png"] forState:UIControlStateNormal];
        helpButton.showsTouchWhenHighlighted = NO;
    } else {
        [helpButton setImage:[UIImage imageNamed:@"UIButtonBarHelp2.png"] forState:UIControlStateNormal];
        helpButton.showsTouchWhenHighlighted = YES;
    }
    [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *helpButtonA = [[UIBarButtonItem alloc] initWithCustomView:helpButton];
    self.helpButton = helpButtonA;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 20.0;
    
    UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        rightSpace.width = 7.0;
    } else {
        rightSpace.width = 18.0;
    }
    
    self.navigationItem.rightBarButtonItems = @[rightSpace, _infoButton, space, _helpButton];
    
    if( _cryptoMethod != QCFrequencyCount ) {
        if( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ) {
            self.navigationItem.leftBarButtonItem = nil;
        } else {
            self.navigationItem.leftBarButtonItem = _menuButton;
        }
    }
    
    [self setFonts];
    
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

    [_switch1 setOn:NO]; // By default switch option should be OFF
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
        [_stepper1 setMaximumValue:INT32_MAX];
    }
    [[UIStepper appearance] setTintColor:[UIColor colorWithRed:255/255.0 green:190/255.0 blue:100/255.0 alpha:1.0]];
    
    
    _multiplicativeLabel.textColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0];
    _additiveLabel.textColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0];

    
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
    
    self.navigationItem.hidesBackButton = YES;
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self saveText];
    [self getOptionsAndSave];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    if( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ) {
        _inputHeight.constant = 195;
        if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs ) {
            _outputHeight.constant = 459;
        } else if( _cryptoMethod == QCAffineEncipher || _cryptoMethod == QCAffineDecipher ) {
            _outputHeight.constant = 387;
        } else if( _cryptoMethod == QCAutokeyPlaintextAttack ) {
            _outputHeight.constant = 359;
        } else {
            _outputHeight.constant = 396;
        }
        _inputWidth.constant = 703;
        _outputWidth.constant = 703;
        _buttonWidth.constant = 703;
    } else {
        _inputHeight.constant = 260;
        if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs ) {
            _outputHeight.constant = 650;
        } else if( _cryptoMethod == QCAffineEncipher || _cryptoMethod == QCAffineDecipher ) {
            _outputHeight.constant = 577;
        } else if( _cryptoMethod == QCAutokeyPlaintextAttack ) {
            _outputHeight.constant = 550;
        } else {
            _outputHeight.constant = 587;
        }
        _inputWidth.constant = 768;
        _outputWidth.constant = 768;
        _buttonWidth.constant = 768;
    }
    [_outputText setNeedsDisplay];
    [_inputText setNeedsDisplay];
    [_computeButton setNeedsDisplay];
}

// Set the toolbar title dependent on device orientation (for iPad)
- (void)setTitleForOrientation:(UIInterfaceOrientation)orientation
{
    if( UIDeviceOrientationIsPortrait(orientation) )
    {   // If the device is in portrait the master view will be hidden so add the label of the current method to the label
        if( _methodTitle > 0 ) {
            self.title = [NSString stringWithFormat:@"CRYPTAROO - %@", _methodTitle];
        } else {
            self.title = [NSString stringWithFormat:@"CRYPTAROO - FREQUENCY COUNT"];
        }
    }
    else
    {   // If in landscape just set the title to Cryptaroo
        if( _methodTitle > 0 ) {
            self.title = [NSString stringWithFormat:@"%@", _methodTitle];
        } else {
            self.title = [NSString stringWithFormat:@"FREQUENCY COUNT"];
        }
    }
}

- (void)placeMenuButtonForInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ) {
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        self.navigationItem.leftBarButtonItem = _menuButton;
    }
}

#pragma mark - UISplitViewControllerDelegate Methods
- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    _splitViewController = svc;
    barButtonItem.title = @"Menu";
    _menuButton = barButtonItem;
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [_menuButton setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"Fairview-SmallCaps" size:28.0]} forState:UIControlStateNormal];
    } else {
        [_menuButton setTitleTextAttributes:@{UITextAttributeFont: [UIFont fontWithName:@"Fairview-SmallCaps" size:20.0]} forState:UIControlStateNormal];
    }
    self.navigationItem.leftBarButtonItem = barButtonItem;
    [self setPopoverController:pc];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = nil;
    [self setPopoverController:nil];
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
	_scrollView.bounds = self.view.bounds;
    _scrollView.frame = self.view.frame;

    [self.view setNeedsUpdateConstraints];
    
    if( _redisplayHelp ) {
        [self helpButtonPressed];
        self.redisplayHelp = NO;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if( !UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ) {
        _inputHeight.constant = 195;
        if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs ) {
            _outputHeight.constant = 459;
        } else if( _cryptoMethod == QCAffineEncipher || _cryptoMethod == QCAffineDecipher ) {
            _outputHeight.constant = 387;
        } else if( _cryptoMethod == QCAutokeyPlaintextAttack ) {
            _outputHeight.constant = 358;
        } else {
            _outputHeight.constant = 396;
        }
    } else {
        _inputHeight.constant = 260;
        if( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs ) {
            _outputHeight.constant = 650;
        } else if( _cryptoMethod == QCAffineEncipher || _cryptoMethod == QCAffineDecipher ) {
            _outputHeight.constant = 577;
        } else if( _cryptoMethod == QCAutokeyPlaintextAttack ) {
            _outputHeight.constant = 547;
        } else {
            _outputHeight.constant = 587;
        }
    }
    [_outputText setNeedsDisplay];
    [_inputText setNeedsDisplay];
    [_computeButton setNeedsDisplay];
    
    if( _cryptoMethod != QCFrequencyCount ) {
        [self placeMenuButtonForInterfaceOrientation:toInterfaceOrientation];
    }
    
    [self setTitleForOrientation:toInterfaceOrientation];
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
            _label1.text = @"Length of NGraphs";
            break;
        case QCAffineKnownPlaintextAttack:
        {
            _label1.text = @"Keyword";
            _label2.text = @"Shift First";
        }
            break;
        case QCAffineEncipher:
        {
            _multiplicativeLabel.text = @"1";    // TO DO: Pull these values from cached
            _additiveLabel.text = @"0";
        }
            break;
        case QCAffineDecipher:
        {
            _multiplicativeLabel.text = @"1";    // TO DO: Pull these values from cached
            _additiveLabel.text = @"0";
        }
            break;
        case QCSplitOffAlphabets:
            _label1.text = @"Wordlength";
            break;
        case QCPolyMonoCalculator:
            _label1.text = @"Keyword Size";
            break;
        case QCViginereEncipher:
            _label1.text = @"Keyword";
            break;
        case QCViginereDecipher:
            _label1.text = @"Keyword";
            break;
        case QCAutokeyCyphertextAttack:
            _label1.text = @"Keyword Length";
            break;
        case QCAutokeyPlaintextAttack:
        {
            _label1.text = @"Max Keyword Length";
            _label2.text = @"Friedman Range";
        }
            break;
        case QCAutokeyDecipher:
        {
            _label1.text = @"Keyword";
            _label2.text = @"Include PlainText in Key";
        }
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
    
    if( _label3 )
    {
        [_label3 setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:28.0]];
        [_label3 setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    }
    
    if( _label4 )
    {
        [_label4 setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:28.0]];
        [_label4 setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    }
    
    if( _additiveLabel )
    {
        [_additiveLabel setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:28.0]];
        [_additiveLabel setTextColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]];
    }
    
    if( _multiplicativeLabel )
    {
        [_multiplicativeLabel setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:28.0]];
        [_multiplicativeLabel setTextColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]];
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
                _multiplicativeLabel.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_label1.text intValue]];
                _additiveLabel.text = [_optionsAry objectAtIndex:1];
                [_stepper2 setValue:[_label2.text intValue]];
                break;
            case QCAffineDecipher:
                _multiplicativeLabel.text = [_optionsAry objectAtIndex:0];
                [_stepper1 setValue:[_label1.text intValue]];
                _additiveLabel.text = [_optionsAry objectAtIndex:1];
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
            _optionsAry = [NSArray arrayWithObjects:_multiplicativeLabel.text, _additiveLabel.text, nil];
            break;
        case QCAffineDecipher:
           _optionsAry = [NSArray arrayWithObjects:_multiplicativeLabel.text, _additiveLabel.text, nil];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if( _cryptoMethod == QCAutokeyPlaintextAttack ) {
        if( textField == _textField1 ) {
            [_textField2 becomeFirstResponder];
        } else if( textField == _textField2 ) {
            [_textField3 becomeFirstResponder];
        } if( textField == _textField3 ) {
            [textField resignFirstResponder];
        }
    } else if( _cryptoMethod == QCGCDAndInverse ) {
        if( textField == _textField1 ) {
            [_textField2 becomeFirstResponder];
        } else if( textField == _textField2 ) {
            [_textField2 resignFirstResponder];
        }
    } else {
        [textField resignFirstResponder];
    }
    return NO;
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
        else if( [string compare:@"."] == NSOrderedSame ) {
            return YES;
        }
    }
    
    if( ![string isEqualToString:@""] ) // Make sure incoming character is not blank
    {
        // If they are editing one of the two float fields and not entering a period (already handled that above), allow only numbers
        if( _cryptoMethod == QCAutokeyPlaintextAttack && textField.tag != 0 && ![string isEqualToString:@"."] )
            badCharacters = [NSMutableCharacterSet characterSetWithCharactersInString:@",?\"!@#$%^&*()-+/\\<>\'~`[]|{}=:;_€£¥•ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        
        // Else if it is one of the integer fields only only integers
        else if( (_cryptoMethod == QCNGraphs || _cryptoMethod == QCSplitOffAlphabets || _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCAutokeyCyphertextAttack || _cryptoMethod == QCAutokeyPlaintextAttack || _cryptoMethod == QCGCDAndInverse) && textField.tag == 0 )
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
    
    if ( _cryptoMethod == QCNGraphs || _cryptoMethod == QCSplitOffAlphabets || _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCAutokeyCyphertextAttack || _cryptoMethod == QCAutokeyPlaintextAttack ) {
        if ( _textField1.text.intValue == 0 ) {
            _textField1.text = @"1";
        } else {
            _textField1.text = [NSString stringWithFormat:@"%d", _textField1.text.intValue];
        }
    } else if ( _cryptoMethod == QCGCDAndInverse ) {
        _textField1.text = [NSString stringWithFormat:@"%d", _textField1.text.intValue];
        if( _textField2.text.intValue == 0 ) {
            _textField2.text = @"1";
        }
        _textField2.text = [NSString stringWithFormat:@"%d", _textField2.text.intValue];
    }
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
        if( [[td.outputArray objectAtIndex:_cryptoMethod] isKindOfClass:[NSArray class]] && [[td.outputArray objectAtIndex:_cryptoMethod] count] > 0 )
        {
            _textField3.text = [[td.outputArray objectAtIndex:_cryptoMethod] objectAtIndex:0];
            _textField4.text = [[td.outputArray objectAtIndex:_cryptoMethod] objectAtIndex:1];
        } else {
            _textField3.text = @"1";
            _textField4.text = @"1";
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
    

    _multiplicativeLabel.text = [NSString stringWithFormat:@"%.f", stepperValue];
    lastStepperValue = stepperValue;    // Update the last stepperValue
}

- (void)adderStepperValueChanged
{   // Get the stepper value and set it to the textField
    double stepperValue = _stepper2.value;
    _additiveLabel.text = [NSString stringWithFormat:@"%.f", stepperValue];
}


#pragma mark - Compute Button Pressed
- (IBAction)computeButtonPressed:(id)sender
{
    // Make sure the last character has been validated for any textFields
    [self textField:_textField1 shouldChangeCharactersInRange:NSMakeRange(0, _textField1.text.length) replacementString:@""];
    [self textField:_textField2 shouldChangeCharactersInRange:NSMakeRange(0, _textField2.text.length) replacementString:@""];
    [self textField:_textField3 shouldChangeCharactersInRange:NSMakeRange(0, _textField3.text.length) replacementString:@""];
    [self textField:_textField4 shouldChangeCharactersInRange:NSMakeRange(0, _textField4.text.length) replacementString:@""];
    [_activeField resignFirstResponder];
    
    // Save any options
    [self getOptionsAndSave];
    
    if( [_inputText.text isEqualToString:@""] )
    {   // If text has not been input, prompt the user to input text
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Text" message:@"Please input text" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        BOOL valid_options = YES; // Tracks if the options are valid (or rather all have been set), default assume yes
        
         // The following methods do not have any options to set
        if( ( _cryptoMethod == QCFrequencyCount || _cryptoMethod == QCRunTheAlphabet || _cryptoMethod == QCBiGraphs || _cryptoMethod == QCTriGraphs ) || ( _cryptoMethod == QCGCDAndInverse ) ) {
            valid_options = YES;
        } else if ( _cryptoMethod == QCAffineKnownPlaintextAttack || _cryptoMethod == QCViginereEncipher || _cryptoMethod == QCViginereDecipher || _cryptoMethod == QCAutokeyDecipher ) {
            if ( _textField1.text.length == 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Options" message:@"Please input a keyword." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                valid_options = NO;
            }
        } else if ( _cryptoMethod == QCNGraphs || _cryptoMethod == QCSplitOffAlphabets || _cryptoMethod == QCPolyMonoCalculator || _cryptoMethod == QCAutokeyCyphertextAttack ) {
            if ( _textField1.text.intValue == 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Options"
                                                                message:[NSString stringWithFormat:@"Please input a %@ greater than 0", [_label1.text substringToIndex:_label1.text.length-1]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Okay"
                                                      otherButtonTitles:nil];
                [alert show];
                valid_options = NO;
            }
        } else if ( _cryptoMethod == QCAutokeyPlaintextAttack ) {
            if ( _textField1.text.intValue == 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Options"
                                                                message:[NSString stringWithFormat:@"Please input a %@ greater than 0", [_label1.text substringToIndex:_label1.text.length-1]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Okay"
                                                      otherButtonTitles:nil];
                [alert show];
                valid_options = NO;
            } else {
                BOOL validRange = YES;
                NSPredicate *isFloat = [NSPredicate predicateWithFormat:@"SELF matches '\\\\d*\\\\Q.\\\\E?\\\\d*'"];
                if( ![isFloat evaluateWithObject:_textField2.text] || ![isFloat evaluateWithObject:_textField3.text] ) {
                    validRange = NO;
                } else if( _textField2.text.floatValue > _textField3.text.floatValue ) {
                    validRange = NO;
                }
                
                if( !validRange ) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Options"
                                                                    message:[NSString stringWithFormat:@"Please input a valid %@.", [_label2.text substringToIndex:_label2.text.length-1]]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Okay"
                                                          otherButtonTitles:nil];
                    [alert show];
                    valid_options = NO;
                }
            }
        }
        else
        {            
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
        }
        
        
        if( valid_options )
        {   // If the options are valid run the appropriate method given input text and any options
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showProgressHUDWithLabel:@"Working..."];
            });
            
            NSString __block *result;
            NSArray __block *results;
            dispatch_async(_cryptQueue, ^{
                switch ( _cryptoMethod )
                {
                    case QCFrequencyCount:
                        result = [QCMethods frequencyCount:[_inputText text]];
                        break;
                    case QCRunTheAlphabet:
                        result = [QCMethods runTheAlphabet:[_inputText text]];
                        break;
                    case QCBiGraphs:
                        result = [QCMethods getBigraphs:[_inputText text]];
                        break;
                    case QCTriGraphs:
                        result = [QCMethods getTrigraphs:[_inputText text]];
                        break;
                    case QCNGraphs:
                        result = [QCMethods getNgraphs:[_inputText text] lengthOfNgraphs:[[_optionsAry objectAtIndex:0] intValue]];
                        break;
                    case QCAffineKnownPlaintextAttack:
                        result = [QCMethods affineKnownPlainttextAttack:[_inputText text] keyword:[_optionsAry objectAtIndex:0] shiftFirst:[[_optionsAry objectAtIndex:1] boolValue]];
                        break;
                    case QCAffineEncipher:
                        result = [QCMethods affineEncipher:[_inputText text] multiplicativeShift:[[_optionsAry objectAtIndex:0] intValue] additiveShift:[[_optionsAry objectAtIndex:1] intValue]];
                        break;
                    case QCAffineDecipher:
                        result = [QCMethods affineDecipher:[_inputText text] multiplicativeShift:[[_optionsAry objectAtIndex:0] intValue] additiveShift:[[_optionsAry objectAtIndex:1] intValue]];
                        break;
                    case QCSplitOffAlphabets:
                        result = [QCMethods stripOffTheAlphabets:[_inputText text] wordLength:[[_optionsAry objectAtIndex:0] intValue]];
                        break;
                    case QCPolyMonoCalculator:
                        result = [QCMethods polyMonoCalculator:[_inputText text] keywordSize:[[_optionsAry objectAtIndex:0] intValue]];
                        break;
                    case QCViginereEncipher:
                        result = [QCMethods viginereEncipher:[_inputText text] keyword:[_optionsAry objectAtIndex:0]];
                        break;
                    case QCViginereDecipher:
                        result = [QCMethods viginereDecipher:[_inputText text] keyword:[_optionsAry objectAtIndex:0]];
                        break;
                    case QCAutokeyCyphertextAttack:
                        result = [QCMethods autoKeyCyphertextAttack:[_inputText text] keywordLength:[[_optionsAry objectAtIndex:0] intValue]];
                        break;
                    case QCAutokeyPlaintextAttack:
                        result = [QCMethods autoKeyPlaintextAttack:[_inputText text] maxKeywordLength:[[_optionsAry objectAtIndex:0] intValue] lowerFriedmanCutoff:[[_optionsAry objectAtIndex:1] doubleValue] upperFriedmanCutoff:[[_optionsAry objectAtIndex:2] doubleValue]];
                        break;
                    case QCAutokeyDecipher:
                        result = [QCMethods autoKeyDecipher:[_inputText text] withKeyword:[_optionsAry objectAtIndex:0] plain:[[_optionsAry objectAtIndex:1 ] boolValue]];
                        break;
                    case QCGCDAndInverse:
                        results = [QCMethods GCDandInverse:[[_textField1 text] intValue] mod:[[_textField2 text] intValue]];
                    default:
                        break;
                }
            });
            
            dispatch_async(_cryptQueue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if( _cryptoMethod == QCGCDAndInverse ) {
                        if( [results count] == 2 ) {
                            // If there are results for both GCD and Inverse provide them
                            _textField3.text = [[results objectAtIndex:0] stringValue];
                            _textField4.text = [results objectAtIndex:1];
                        }
                        else {
                            // If there are not results for both of them, an error has occured
                            /* NOTE: Error is due to Gary's method of getting GCD and Inverse in QCMethods, would like to fix in future update */
                            _textField3.text = @"Error";
                            _textField4.text = @"Error";
                        }
                    } else {
                        [_outputText setText:result];
                    }
                    [self hideProgressHUD];
                });
            });

        }
        else
        {   // If not valid options, prompt the user for valid options
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Options" message:@"Please select options first" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
//            [alert show];
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
    if( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation] ) ) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    }
    else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width, 0.0);
    }
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _scrollView.frame;
    if( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation] ) ) {
        aRect.size.height -= kbSize.height;
    } else {
        aRect.size.height -= kbSize.width;
    }
    
    CGPoint point = [_activeField convertPoint:_activeField.frame.origin toView:self.view];
    if (!CGRectContainsPoint(aRect, point))
    {
        CGPoint scrollPoint;
        if( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation] ) )
           scrollPoint = CGPointMake(0.0, kbSize.height);
        else
        {
            if( _cryptoMethod == QCGCDAndInverse ) {
                scrollPoint = CGPointMake(0.0, 175.0);
            }
            else {
                if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
                    scrollPoint = CGPointMake(0.0, kbSize.width);
                } else {
                    scrollPoint = CGPointMake(0.0, kbSize.width);
                }
                
            }
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

// When the info/about button is pressed
- (void)infoButtonPressed
{   // Create the info popover view and display it
    InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    _infoPopover = [[UIPopoverController alloc] initWithContentViewController:infoViewController];
    [_infoPopover setPopoverContentSize:CGSizeMake(320, 460)];
    
    CGRect rect = _infoButton.customView.frame;
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0" ) ) {
        rect.origin.y -= 44;
        rect.origin.x -= 3;
    } else {
        rect.origin.y -= 44;
        rect.origin.x += 7;
        _infoPopover.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];
    }
    
    [_infoPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

// When the help button is pressed
- (void)helpButtonPressed
{
    HelpViewController *helpViewController = [[HelpViewController alloc] init];
    helpViewController.delegate = self;
    helpViewController.cryptoMethod = self.cryptoMethod;
    
    if( !_redisplayHelp ) {
        [self addCurtainView];
    }
    [self.splitViewController addChildViewController:helpViewController];
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    double rotation = 0;
    switch (currentOrientation) {
        case UIDeviceOrientationPortrait:
            rotation = 0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotation = -M_PI;
            break;
        case UIDeviceOrientationLandscapeLeft:
            rotation = M_PI_2;
            break;
        case UIDeviceOrientationLandscapeRight:
            rotation = -M_PI_2;
            break;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
    [helpViewController.view setTransform:transform];
    [self.curtainView addSubview:helpViewController.view];
    
    helpViewController.view.center = [UIApplication sharedApplication].keyWindow.center;
    
}

- (void)dismissHelpViewController:(HelpViewController *)viewController redisplay:(BOOL)redisplay {
    self.redisplayHelp = redisplay;
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [viewController.view removeFromSuperview];
    } else {
        [viewController.rootView removeFromSuperview];
    }
    [viewController removeFromParentViewController];
    
    if( !redisplay ) {
        [self removeCurtainView];
    }
}

- (void)removeCurtainView
{
    [_curtainView removeFromSuperview];
    _curtainView = nil;
}

- (void)addCurtainView
{
    _curtainView = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    _curtainView.exclusiveTouch = YES;
    _curtainView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_curtainView];
}


#pragma mark - Other Methods
#pragma mark - Other Methods
- (void)showProgressHUDWithLabel:(NSString *)string {
    self.hud = [[MBProgressHUD alloc] initWithView:self.splitViewController.view];
    _hud.labelText = string;
    [self addCurtainView];
    [self.splitViewController.view addSubview:_hud];
    [_hud show:YES];
}

- (void)hideProgressHUD {
    [_hud removeFromSuperview];
    [self removeCurtainView];
    self.hud = nil;
}

@end

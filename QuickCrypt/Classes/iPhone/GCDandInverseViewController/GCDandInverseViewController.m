//
//  GCDandInverseViewControllerViewController.m
//  QuickCrypt
//
//  Created by build on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GCDandInverseViewController.h"

@interface GCDandInverseViewController ()

@property (nonatomic, strong) TextData *td;
@property (nonatomic, strong) UIView *curtainView;

- (void)infoButtonPressed;

@end

@implementation GCDandInverseViewController

@synthesize td;
@synthesize inverseOfField = _inverseOfField;
@synthesize modField = _modField;
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize label3 = _label3;
@synthesize label4 = _label4;
@synthesize gcd = _gcd;
@synthesize inverse = _inverse;
@synthesize caclculate = _calculate;


#pragma mark - View Lifecycle Methods
- (id)init
{
    self = [super initWithNibName:@"GCDandInverseViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    td = [TextData textDataManager]; // Get an instance of our textData class
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont: [[Fonts fontManager] fairviewRegularWithFontSize:30.0],
                                                           UITextAttributeTextColor: [UIColor whiteColor],
                                                           UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)]}];
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:2.0 forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:190/255.0 blue:100/255.0 alpha:1.0];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:245/255.0 green:161/255.0 blue:60/255.0 alpha:1.0]];
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-2.0 forBarMetrics:UIBarMetricsDefault];
    }
    
    // If the options inverseOf and mod exist load them
    if( [td.optionsList objectAtIndex:QCGCDAndInverse] && [[td.optionsList objectAtIndex:QCGCDAndInverse] count] > 0 )
    {
        _inverseOfField.text = [[td.optionsList objectAtIndex:QCGCDAndInverse] objectAtIndex:0];
        _modField.text = [[td.optionsList objectAtIndex:QCGCDAndInverse] objectAtIndex:1];
    }
    
    // If there are results already for GCDandInverse load them
    if( [[td.outputArray objectAtIndex:QCGCDAndInverse] isKindOfClass:[NSArray class]] && [[td.outputArray objectAtIndex:QCGCDAndInverse] count] > 0 )
    {
        _gcd.text = [[td.outputArray objectAtIndex:QCGCDAndInverse] objectAtIndex:0];
        _inverse.text = [[td.outputArray objectAtIndex:QCGCDAndInverse] objectAtIndex:1];
    }
    else
    {   // If no results default to 0
        _gcd.text = @"1";
        _inverse.text = @"1";
    }
    
    DoneCancelNumberPadToolbar *toolbar = [[DoneCancelNumberPadToolbar alloc] initWithTextField:_inverseOfField];
    toolbar.doneButton.title = @"Next";
    toolbar.toolbarDelegate = self;
    _inverseOfField.inputAccessoryView = toolbar;
    
    toolbar = [[DoneCancelNumberPadToolbar alloc] initWithTextField:_modField];
    toolbar.toolbarDelegate = self;
    _modField.inputAccessoryView = toolbar;
    
    // Set up labels
    [_label1 setFont:[UIFont fontWithName:@"Fairview-SmallCaps" size:28.0]];
    [_label1 setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    
    [_label2 setFont:[UIFont fontWithName:@"Fairview-SmallCaps" size:28.0]];
    [_label2 setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    
    [_label3 setFont:[UIFont fontWithName:@"Fairview-SmallCaps" size:28.0]];
    [_label3 setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    
    [_label4 setFont:[UIFont fontWithName:@"Fairview-SmallCaps" size:28.0]];
    [_label4 setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]];
    
    // Create the computer button
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_calculate setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    
    
    // Create an info button and add it to the navigation bar
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

}

- (void)viewWillDisappear:(BOOL)animated
{   // When the view disappears save the output results and the given options
    [super viewWillDisappear:YES];
    [td.outputArray replaceObjectAtIndex:QCGCDAndInverse withObject:[NSArray arrayWithObjects:[_gcd text], [_inverse text], nil]];
    [td.optionsList replaceObjectAtIndex:QCGCDAndInverse withObject:[NSArray arrayWithObjects:[_inverseOfField text], [_modField text], nil]];
}


#pragma mark - Rotation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Caclulate Method
- (IBAction)calculateButtonPressed:(id)sender
{
    if( [[_inverseOfField text] isEqualToString:@""] || [[_modField text] isEqualToString:@""] )
    {   // If the inverseOf and mod fields are emptpy, ask user to fill in
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fill in Fields" message:@"Please fill in the Inverse of and Mod fields" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
    else
    {   // Get the results from method
        NSArray *results = [QCMethods GCDandInverse:[[_inverseOfField text] intValue] mod:[[_modField text] intValue]];
        if( [results count] == 2 )
        {   // If there are results for both GCD and Inverse provide them
            _gcd.text = [[results objectAtIndex:0] stringValue];
            _inverse.text = [results objectAtIndex:1];
        }
        else
        {   // If there are not results for both of them, an error has occured
            /* NOTE: Error is due to Gary's method of getting GCD and Inverse in QCMethods, would like to fix in future update */
            _gcd.text = @"Error";
            _inverse.text = @"Error";
        }
    }
}

- (void)dismissKeyboard:(id)sender
{
    [_inverseOfField resignFirstResponder];
    [_modField resignFirstResponder];
}


#pragma mark - Methods for Buttons in NavBar
- (void)infoButtonPressed
{   // If the info button is pressed display the help blurb for GCDandInverse
    HelpViewController *helpViewController = [[HelpViewController alloc] init];
    helpViewController.delegate = self;
    helpViewController.cryptoMethod = QCGCDAndInverse;
    
    [self addCurtainView];
    [self.navigationController addChildViewController:helpViewController];
    [self.navigationController.view addSubview:helpViewController.view];
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        helpViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y-20);
    } else {
        helpViewController.view.center = CGPointMake(self.view.center.x, self.view.center.y+20);
    }
}

#pragma mark - HelpViewControllerDelegate Methods
- (void)dismissHelpViewController:(HelpViewController *)viewController redisplay:(BOOL)redisplay {
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
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

#pragma mark - DoneCancelNumberPadToolbarDelegate Methods
- (void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickDone:(UITextField *)textField {
    if( textField == _inverseOfField ) {
        [_modField becomeFirstResponder];
    } else if( textField == _modField ) {
        [_modField resignFirstResponder];
    }
}


@end

//
//  GCDandInverseViewControllerViewController.m
//  QuickCrypt
//
//  Created by build on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GCDandInverseViewController.h"

@interface GCDandInverseViewController ()
{
    TextData *td;
}

@property (nonatomic, strong) TextData *td;

- (void)infoButtonPressed;

@end

@implementation GCDandInverseViewController

@synthesize td;
@synthesize optionsViewMat = _optionsViewMat;
@synthesize inverseOfField = _inverseOfField;
@synthesize modField = _modField;
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize label3 = _label3;
@synthesize label4 = _label4;
@synthesize gcd = _gcd;
@synthesize inverse = _inverse;
@synthesize caclculate = _calculate;

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
    
    // add observer for the respective notifications (depending on the os version)
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardDidShow:) 
													 name:UIKeyboardDidShowNotification 
												   object:nil];		
	} else {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
	}

    
    td = [TextData textDataManager];
    if( [td.optionsList objectAtIndex:QCGCDAndInverse] && [[td.optionsList objectAtIndex:QCGCDAndInverse] count] > 0 )
    {
        _inverseOfField.text = [[td.optionsList objectAtIndex:QCGCDAndInverse] objectAtIndex:0];
        _modField.text = [[td.optionsList objectAtIndex:QCGCDAndInverse] objectAtIndex:1];
    }
    
    if( [[td.outputArray objectAtIndex:QCGCDAndInverse] isKindOfClass:[NSArray class]] && [[td.outputArray objectAtIndex:QCGCDAndInverse] count] > 0 )
    {
        _gcd.text = [[td.outputArray objectAtIndex:QCGCDAndInverse] objectAtIndex:0];
        _inverse.text = [[td.outputArray objectAtIndex:QCGCDAndInverse] objectAtIndex:1];
    }
    else
    {
        _gcd.text = @"0";
        _inverse.text = @"0";
    }
    
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [_calculate setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    
    _optionsViewMat.layer.cornerRadius = 5;
    _optionsViewMat.clipsToBounds = YES;
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    [infoBtn addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [td.outputArray replaceObjectAtIndex:QCGCDAndInverse withObject:[NSArray arrayWithObjects:[_gcd text], [_inverse text], nil]];
    [td.optionsList replaceObjectAtIndex:QCGCDAndInverse withObject:[NSArray arrayWithObjects:[_inverseOfField text], [_modField text], nil]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissKeyboard:(id)sender
{
    [_inverseOfField resignFirstResponder];
    [_modField resignFirstResponder];
}

- (IBAction)calculateButtonPressed:(id)sender
{
    if( [[_inverseOfField text] isEqualToString:@""] || [[_modField text] isEqualToString:@""] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fill in Fields" message:@"Please fill in the Inverse of and Mod fields" delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSArray *results = [QCMethods GCDandInverse:[[_inverseOfField text] intValue] mod:[[_modField text] intValue]];
        if( [results count] == 2 )
        {
            _gcd.text = [[results objectAtIndex:0] stringValue];
            _inverse.text = [results objectAtIndex:1];
        }
        else
        {
            _gcd.text = @"Error";
            _inverse.text = @"Error";
        }
    }
}

- (void)addButtonToKeyboard {
	// create custom button
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	doneButton.adjustsImageWhenHighlighted = NO;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
		[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
	} else {        
		[doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
	}
	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:doneButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				[keyboard addSubview:doneButton];
		}
	}
}

- (void)keyboardWillShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
		[self addButtonToKeyboard];
	}
}

- (void)keyboardDidShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[self addButtonToKeyboard];
    }
}


- (void)doneButton:(id)sender {
    [_inverseOfField resignFirstResponder];
    [_modField resignFirstResponder];
}

- (void)infoButtonPressed
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HelpInfo" ofType:@"plist"];
    NSDictionary *helpDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *helpArray = [NSArray arrayWithArray:[helpDict valueForKey:@"QCHelpStrings"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title message:[helpArray objectAtIndex:QCGCDAndInverse] delegate:nil cancelButtonTitle:@"Okay"otherButtonTitles:nil];
    [alert show];
}


@end

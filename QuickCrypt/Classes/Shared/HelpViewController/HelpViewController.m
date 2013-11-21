//
//  HelpViewController.m
//  QuickCrypt
//
//  Created by Joey Wessel on 10/3/13.
//
//

#import "HelpViewController.h"
#import "Fonts.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)init {
    if( self = [super initWithNibName:@"HelpViewController" bundle:nil] ) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        [_helpLabelBackground setBackgroundColor:[UIColor colorWithRed:255/255.0 green:190/255.0 blue:100/255.0 alpha:1.0]];
        [_helpLabel setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:32.0]];
        _helpLabel.text = @"NEED SOME HELP?";
    } else {
        UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:_helpLabelBackground.frame];
        [bar setTintColor:[UIColor colorWithRed:245/255.0 green:161/255.0 blue:60/255.0 alpha:1.0]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
        [label setFont:[[Fonts fontManager] fairviewRegularWithFontSize:32.0]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = @"NEED SOME HELP?";
        [bar addSubview:label];
    
        [self.view addSubview:bar];
    }
    
    [_helpText setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:28.0]];
    [_helpText setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0]];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HelpInfo" ofType:@"plist"];
    NSDictionary *helpDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *helpArray = [NSArray arrayWithArray:[helpDict valueForKey:@"QCHelpStrings"]];
    _helpText.text = helpArray[_cryptoMethod];
    
    _okayButton.titleLabel.font = [[Fonts fontManager] fairviewRegularWithFontSize:28.0];
    
    if( SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7.0") ) {
        [self setView:_rootView];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
        return YES;
    } else {
        return NO;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    double rotation = 0;
//    switch (toInterfaceOrientation) {
//        case UIDeviceOrientationPortrait:
//            rotation = 0;
//            break;
//        case UIDeviceOrientationPortraitUpsideDown:
//            rotation = -M_PI;
//            break;
//        case UIDeviceOrientationLandscapeLeft:
//            rotation = M_PI_2;
//            break;
//        case UIDeviceOrientationLandscapeRight:
//            rotation = -M_PI_2;
//            break;
//    }
//    CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
//    [self.view setTransform:transform];
    if( [_delegate respondsToSelector:@selector(dismissHelpViewController:redisplay:)] ) {
        [_delegate dismissHelpViewController:self redisplay:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okayButtonTapped:(id)sender {
    if( [_delegate respondsToSelector:@selector(dismissHelpViewController:redisplay:)] ) {
        [_delegate dismissHelpViewController:self redisplay:NO];
    }
}
@end

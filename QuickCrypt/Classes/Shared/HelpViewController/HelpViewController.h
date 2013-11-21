//
//  HelpViewController.h
//  QuickCrypt
//
//  Created by Joey Wessel on 10/3/13.
//
//

#import <UIKit/UIKit.h>
#import "QCButton.h"

@protocol HelpViewControllerDelegate;

@interface HelpViewController : UIViewController

@property (weak) id<HelpViewControllerDelegate> delegate;

@property QCCryptoMethod cryptoMethod;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UIView *helpLabelBackground;
@property (weak, nonatomic) IBOutlet UILabel *helpText;
@property (weak, nonatomic) IBOutlet QCButton *okayButton;
@property (weak, nonatomic) IBOutlet UIView *rootView;

- (IBAction)okayButtonTapped:(id)sender;

@end



@protocol HelpViewControllerDelegate <NSObject>

@required
- (void)dismissHelpViewController:(HelpViewController *)controller redisplay:(BOOL)redisplay;

@end

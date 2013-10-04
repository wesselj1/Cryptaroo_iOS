//
//  DoneCancelNumberPadToolbar.h
//  QuickCrypt
//
//  Created by Joey Wessel on 10/4/13.
//
//

#import <UIKit/UIKit.h>

@class DoneCancelNumberPadToolbar;

@protocol DoneCancelNumberPadToolbarDelegate <NSObject>

-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickDone:(UITextField *)textField;
-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller didClickCancel:(UITextField *)textField;

@end


@interface DoneCancelNumberPadToolbar : UIToolbar

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) id <DoneCancelNumberPadToolbarDelegate> toolbarDelegate;

- (id) initWithTextField:(UITextField *)textField;

@end
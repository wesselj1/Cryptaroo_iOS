//
//  DoneCancelNumberPadToolbar.m
//  QuickCrypt
//
//  Created by Joey Wessel on 10/4/13.
//
//

#import "DoneCancelNumberPadToolbar.h"

@implementation DoneCancelNumberPadToolbar

- (id) initWithTextField:(UITextField *)aTextField
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 50)];
    if (self) {
        _textField = aTextField;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
        UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
            self.translucent = NO;
            self.barTintColor = [UIColor colorWithRed:179/255.0 green:182/255.0 blue:185/255.0 alpha:1.0];
            rightSpace.width = 13.0;
        } else {
            self.tintColor = [UIColor colorWithRed:201/255.0 green:204/255.0 blue:209/255.0 alpha:1.0];
            doneButton.tintColor = [UIColor colorWithRed:75/255.0 green:155/255.0 blue:255/255.0 alpha:1.0];
            rightSpace.width = 0.0;
        }
        
        self.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      doneButton, rightSpace];

        
        [self sizeToFit];
        
    }
    return self;
}

- (void)cancelNumberPad {
    [_textField resignFirstResponder];
    _textField.text = @"";
    if( [_toolbarDelegate respondsToSelector:@selector(doneCancelNumberPadToolbarDelegate:didClickCancel:)] ) {
        [_toolbarDelegate doneCancelNumberPadToolbarDelegate:self didClickCancel:_textField];
    }
}

- (void)doneWithNumberPad {
    [_textField resignFirstResponder];
    if( [_toolbarDelegate respondsToSelector:@selector(doneCancelNumberPadToolbarDelegate:didClickDone:)] ) {
        [_toolbarDelegate doneCancelNumberPadToolbarDelegate:self didClickDone:_textField];
    }
}

@end

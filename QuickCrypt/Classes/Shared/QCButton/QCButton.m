//
//  QCButton.m
//  QuickCrypt
//
//  Created by Joey Wessel on 7/28/13.
//
//

#import "QCButton.h"
#import "Fonts.h"

@implementation QCButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self setBackgroundImage:[[UIImage imageNamed:@"qc_button.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0] forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:@"qc_button_pressed.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[[UIImage imageNamed:@"qc_button_disabled.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:0] forState:UIControlStateDisabled];
    
    [self setTitleColor:[UIColor colorWithWhite:232/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:85/255.0 alpha:1.0] forState:UIControlStateDisabled];
    
    [self.titleLabel setFont:[[Fonts fontManager] fairviewRegularWithFontSize:30.0]];
}

@end

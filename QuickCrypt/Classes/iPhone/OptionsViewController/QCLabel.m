//
//  QCLabel.m
//  QuickCrypt
//
//  Created by Joey Wessel on 7/29/13.
//
//

#import "QCLabel.h"
#import "Fonts.h"

@implementation QCLabel

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
    [super drawRect:rect];
    // Drawing code
    [self setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:28.0]];
    [self setTextColor:[UIColor colorWithWhite:170/255.0 alpha:1.0]];
}

- (void)setFontSize:(float)size
{
    [self setFont:[[Fonts fontManager] fairviewSmallCapsWithFontSize:size]];
}

@end

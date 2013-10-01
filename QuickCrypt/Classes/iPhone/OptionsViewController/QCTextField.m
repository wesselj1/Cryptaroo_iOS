//
//  QCTextField.m
//  QuickCrypt
//
//  Created by Joey Wessel on 8/22/13.
//
//

#import "QCTextField.h"

@implementation QCTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.inputView.backgroundColor = [UIColor blackColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1.0];
    self.font = [UIFont fontWithName:@"FairView-Regular" size:28.0f];
    self.textColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0];
}

@end

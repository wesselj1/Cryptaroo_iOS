//
//  Fonts.m
//  QuickCrypt
//
//  Created by Joey Wessel on 7/27/13.
//
//

#import "Fonts.h"

static Fonts *fonts = nil;

@implementation Fonts

+ (id)fontManager
{
    @synchronized(self)
    {   // If there is not already an instance of TextData, create one
        if(fonts == nil)
            fonts = [[self alloc] init];
    }
    return fonts;
}

- (id)init
{
    if( self = [super init] )
    {
        _fairview_regular = [UIFont fontWithName:@"Fairview-Regular" size:38.0];
        _fairview_smallcaps = [UIFont fontWithName:@"Fairview-SmallCaps" size:38.0];
    }
    return self;
}

- (UIFont *)fairviewRegularWithFontSize:(float)size
{
    return [UIFont fontWithName:@"Fairview-Regular" size:size];
}

- (UIFont *)fairviewSmallCapsWithFontSize:(float)size
{
    return [UIFont fontWithName:@"Fairview-SmallCaps" size:size];
}

@end

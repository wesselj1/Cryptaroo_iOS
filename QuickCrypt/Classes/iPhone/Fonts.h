//
//  Fonts.h
//  QuickCrypt
//
//  Created by Joey Wessel on 7/27/13.
//
//

#import <Foundation/Foundation.h>

@interface Fonts : NSObject

@property (nonatomic, strong) UIFont *fairview_regular;
@property (nonatomic, strong) UIFont *fairview_smallcaps;

+ (id)fontManager;

- (UIFont *)fairviewRegularWithFontSize:(float)size;
- (UIFont *)fairviewSmallCapsWithFontSize:(float)size;

@end

//
//  UITableViewCell+UITableViewCell_FixUITableViewCellAutolayout.m
//  QuickCrypt
//
//  Created by Joey Wessel on 7/28/13.
//
//

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UITableViewCell (FixUITableViewCellAutolayout)

+ (void)load
{
    Method existing = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method new = class_getInstanceMethod(self, @selector(_autolayout_replacementLayoutSubviews));
    
    method_exchangeImplementations(existing, new);
}

- (void)_autolayout_replacementLayoutSubviews
{
    [super layoutSubviews];
    [self _autolayout_replacementLayoutSubviews]; // not recursive due to method swizzling
    [super layoutSubviews];
}

@end

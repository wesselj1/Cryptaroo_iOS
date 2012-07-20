//
//  HelpData.h
//  QuickCrypt
//
//  Created by build on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpData : NSObject
{
    NSMutableArray *helpStrings;
}

@property (nonatomic, strong) NSMutableArray *helpStrings;

+(id)helpDataManager;

@end

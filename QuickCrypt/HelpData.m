//
//  HelpData.m
//  QuickCrypt
//
//  Created by build on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpData.h"

static HelpData *helpData = nil;

@implementation HelpData

@synthesize helpStrings;

+ (id)helpDataManager
{
    @synchronized(self)
    {
        if(helpData == nil)
            helpData = [[self alloc] init];
    }
    return helpData;
}

- (id)init
{
    if (( self = [super init] ))
        helpStrings = [[NSMutableArray alloc] init];
    return self;
}

@end

//
//  TextData.m
//  QuickCrypt
//
//  Created by build on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextData.h"

static TextData *textData = nil;

@implementation TextData

@synthesize outputArray;
@synthesize inputString;
@synthesize optionsList;
@synthesize inputArray;

+ (id)textDataManager
{
    @synchronized(self)
    {
        if(textData == nil)
            textData = [[self alloc] init];
    }
    return textData;
}

- (id)init
{
    if (( self = [super init] ))
    {
        inputString = @"";
        inputArray = [[NSMutableArray alloc] init];
        outputArray = [[NSMutableArray alloc] init];
        optionsList = [[NSMutableArray alloc] init];
        
        [optionsList addObjectsFromArray:[NSArray arrayWithObjects:
                                          [[NSArray alloc] init], 
                                          [[NSArray alloc] init], 
                                          [[NSArray alloc] init], 
                                          [[NSArray alloc] init], 
                                          [NSArray arrayWithObject:@"1"], 
                                          [NSArray arrayWithObjects:@"the", [NSNumber numberWithBool:NO], nil],
                                          [[NSArray alloc] init],
                                          [[NSArray alloc] init],
                                          [NSArray arrayWithObject:@"1"],
                                          [NSArray arrayWithObject:@"1"],
                                          [[NSArray alloc] init],
                                          [[NSArray alloc] init],
                                          [NSArray arrayWithObject:@"1"],
                                          [NSArray arrayWithObjects:@"1", @"0.055", @"2.0", nil],
                                          [NSArray arrayWithObjects:@"", [NSNumber numberWithBool:NO], nil],
                                          [NSArray arrayWithObjects:@"1", @"26", nil], nil]];
        
        for( int i = 0; i < 16; i++ )
            [outputArray addObject:@""];
    }
    return self;
}

@end

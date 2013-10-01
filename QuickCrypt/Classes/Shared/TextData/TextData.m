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

+ (id)textDataManager
{
    @synchronized(self)
    {   // If there is not already an instance of TextData, create one
        if(textData == nil)
            textData = [[self alloc] init];
    }
    return textData;
}

- (id)init
{
    if (( self = [super init] ))
    {
        // Initialize strings and arrays
        inputString = @"";
        outputArray = [[NSMutableArray alloc] init];
        optionsList = [[NSMutableArray alloc] init];
        
        
        // Prepare the default options list
        [optionsList addObjectsFromArray:[NSArray arrayWithObjects:
                                          [[NSArray alloc] init], 
                                          [[NSArray alloc] init], 
                                          [[NSArray alloc] init], 
                                          [[NSArray alloc] init], 
                                          [NSArray arrayWithObject:@"1"], 
                                          [NSArray arrayWithObjects:@"the", [NSNumber numberWithBool:NO], nil],
                                          [NSArray arrayWithObjects:@"1", @"0", nil],
                                          [NSArray arrayWithObjects:@"1", @"0", nil],
                                          [NSArray arrayWithObject:@"1"],
                                          [NSArray arrayWithObject:@"1"],
                                          [[NSArray alloc] init],
                                          [[NSArray alloc] init],
                                          [NSArray arrayWithObject:@"1"],
                                          [NSArray arrayWithObjects:@"1", @"0.055", @"2.0", nil],
                                          [NSArray arrayWithObjects:@"", [NSNumber numberWithBool:NO], nil],
                                          [NSArray arrayWithObjects:@"1", @"26", nil], nil]];
        
        // Fill output array with empty strings for initial TextData instance
        for( int i = 0; i < 16; i++ )
            [outputArray addObject:@""];
    }
    return self;
}

@end

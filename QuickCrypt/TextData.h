//
//  TextData.h
//  QuickCrypt
//
//  Created by build on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextData : NSObject
{
    NSMutableArray *outputArray;
    NSString *inputString;
    NSMutableArray *optionsList; // Contains list of options for each QCMethodType
    NSMutableArray *inputArray;
}

@property (nonatomic, strong) NSMutableArray *outputArray;
@property (nonatomic, strong) NSString *inputString;
@property (nonatomic, strong) NSMutableArray *optionsList;
@property (nonatomic, strong) NSMutableArray *inputArray; // Array of input for GCDandInverse method

+ (id)textDataManager;

@end

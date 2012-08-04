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
    NSMutableArray *outputArray; // The array of output text for each QCMethodType's screen
    NSString *inputString;       // The input string from the user. Persistent across each method.
    NSMutableArray *optionsList; // Contains list of options for each QCMethodType
}

@property (nonatomic, strong) NSMutableArray *outputArray;
@property (nonatomic, strong) NSString *inputString;
@property (nonatomic, strong) NSMutableArray *optionsList;

+ (id)textDataManager;

@end

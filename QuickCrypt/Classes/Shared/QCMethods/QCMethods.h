//
//  QCMethods.h
//  QuickCrypt
//
//  Created by build on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  NOTE: This class is nearly a literal translation of Gary Watson's methods used in CryptoHelper.
//  Therefore there will not be much documentation at all beyond identifying the methods.
//
//  The algorithm Gary uses for getting the GCD and inverse of a integer in a particular modulus field is
//  not entirely correct and has some errors. In the future I would like to resolve this issue with a
//  new algorithm or correcting Gary's.

#import <Foundation/Foundation.h>

typedef enum 
{   // Currently these are the supported cryptographic functions of the app
    QCFrequencyCount = 0,
    QCRunTheAlphabet,
    QCBiGraphs,
    QCTriGraphs,
    QCNGraphs,
    QCAffineKnownPlaintextAttack,
    QCAffineEncipher,
    QCAffineDecipher,
    QCSplitOffAlphabets,
    QCPolyMonoCalculator,
    QCViginereEncipher,
    QCViginereDecipher,
    QCAutokeyCyphertextAttack,
    QCAutokeyPlaintextAttack,
    QCAutokeyDecipher,
    QCGCDAndInverse,
} QCCryptoMethod;

BOOL memoryCritical;

@interface QCMethods : NSObject

+ (NSString *)frequencyCount:(NSString *)inputtext;
+ (NSString *)runTheAlphabet:(NSString *)inputtext;
+ (NSString *)getBigraphs:(NSString *)inputtext;
+ (NSString *)getTrigraphs:(NSString *)inputtext;
+ (NSString *)getNgraphs:(NSString *)inputtext lengthOfNgraphs:(int)length;
+ (NSString *)affineKnownPlainttextAttack:(NSString *)inputtext keyword:(NSString *)keyword shiftFirst:(BOOL)shiftFirst;
+ (NSString *)affineEncipher:(NSString *)inputtext multiplicativeShift:(int)multiplier additiveShift:(int)additive;
+ (NSString *)affineDecipher:(NSString *)inputtext multiplicativeShift:(int)multiplier additiveShift:(int)additive;
+ (NSString *)stripOffTheAlphabets:(NSString *)inputtext wordLength:(int)length;
+ (NSString *)polyMonoCalculator:(NSString *)inputtext keywordSize:(int)size;
+ (NSString *)viginereEncipher:(NSString *)inputtext keyword:(NSString *)keyword;
+ (NSString *)viginereDecipher:(NSString *)inputtext keyword:(NSString *)keyword;
+ (NSString *)autoKeyCyphertextAttack:(NSString *)inputtext keywordLength:(int)length;
+ (NSString *)autoKeyPlaintextAttack:(NSString *)inputtext maxKeywordLength:(int)length lowerFriedmanCutoff:(double)lower upperFriedmanCutoff:(double)upper;
+ (NSString *)autoKeyDecipher:(NSString *)inputtext withKeyword:(NSString *)keyword plain:(BOOL)plaintext;
+ (NSArray *)GCDandInverse:(int)number mod:(int)modulus;

@end

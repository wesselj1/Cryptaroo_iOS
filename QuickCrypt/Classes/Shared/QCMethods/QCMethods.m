//
//  QCMethods.m
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

#import "QCMethods.h"
#import <math.h>

@interface QCMethods () {

}

+ (NSString *)formatString:(NSString *)string;
+ (NSString *)removePunctuationSpecialCharacters:(NSString *)string;
+ (NSString *)searchCeasar:(int)m inputString:(NSString *)inputString searchString:(NSString *)searchString;
+ (NSString *)searchCeasarReverse:(int)m inputString:(NSString *)inputString searchString:(NSString *)searchString;

@end

// Private class Counter
@interface Counter : NSObject {
    int length;
    NSMutableArray *sArray;
    int iArray[10000];
    int pArray[10000][100];
}
@property int length;
@property (nonatomic, strong) NSMutableArray *sArray;


- (id)init;
- (void)add:(NSString *)aString atPosition:(int)pos;
- (BOOL)contains:(NSString *)aString;
- (void)increment:(int)position;
- (int)getIArrayElement:(int)x;
- (int)getPArrayElement:(int)x y:(int)y;

@end

@implementation Counter
@synthesize length;
@synthesize sArray;

- (id)init
{
    if (( self = [super init] ))
    {
        length = 0;
        sArray = [[NSMutableArray alloc] init];
        for( int x = 0; x < 10000; x++ )
        {
            for( int y = 0; y < 100; y++ )
                pArray[x][y] = 0;
            iArray[x] = 0;
        }
    }
    return self;
}

- (void)add:(NSString *)aString atPosition:(int)pos
{    
    [sArray addObject:aString];
    iArray[length] = 1;
    pArray[length][0] = pos;
    length++;
}

- (BOOL)contains:(NSString *)aString
{
    for( int x = 0; x < length; x++ )
    {
        if ([[sArray objectAtIndex:x] isEqualToString:aString])
            return YES;
    }
    return NO;
}

- (void)increment:(int)position
{
    iArray[length-1]++;
    pArray[length-1][iArray[length-1]-1] = position;
}

- (int)getIArrayElement:(int)x
{
    return iArray[x];
}

- (int)getPArrayElement:(int)x y:(int)y
{
    return pArray[x][y];
}
@end
// End private class Counter



@implementation QCMethods

// This is referenced by many of the methods
static char tabulaRecta[26][26] = {
    {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'},
    {'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A'},
    {'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B'},
    {'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C'},
    {'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D'},
    {'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E'},
    {'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F'},
    {'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G'},
    {'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'},
    {'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'},
    {'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'},
    {'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'},
    {'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'},
    {'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'},
    {'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'},
    {'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O'},
    {'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P'},
    {'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q'},
    {'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R'},
    {'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S'},
    {'U', 'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T'},
    {'V', 'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U'},
    {'W', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V'},
    {'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W'},
    {'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X'},
    {'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y'}};



// GCD and Inverse
+ (NSArray *)GCDandInverse:(int)number mod:(int)modulus
{
    
    double y = fmax( (double)number, (double)modulus );
    double z = fmin( (double)number, (double)modulus );
    double w = 0;
    double ans = 0;
    //NSString *resultString;
    double gcd = 0;
    NSString *inverse = 0;
    
    //resultString = [NSString stringWithFormat:@"The inverse algorithm used here is not Euclid's algo, rather it is one I came up with that is not as efficient\n\n"]; <-- Note from Gary Watson
    
    if( y == 0 ^ z == 0 )
        gcd = fmax(y, z);
    else
    {
        BOOL exit = NO;
        
        while (!exit  && !memoryCritical) {
            w = fmod(y, z);
            if (w != 0) {
                y = z;
                z = w;
            }
            else {
                exit = YES;
                ans = z;
            }
        }
        gcd = (int)ans;
    }
       
    if( modulus == 0 )
    {
       inverse = @"Cannot divide by 0";
    }
    else
    {
        if (ans == 1) {
            y = (double)modulus;
            z = (double)number;
            
            for (int x = 1; x <= y && !memoryCritical; x++) {
                w = ((-(y * x - 1) / z));
                w = (w + ((int)(-w / y) + 1) * y);
                if (w - ((int)w) == 0) {
                    inverse = [[NSNumber numberWithInt:w] stringValue];
                    break;
                }
            }
        }
        else
        {
            inverse = @"No inverse";
        }
    }
    
    memoryCritical = NO;
        
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:gcd], inverse, nil];
}

// Autokey Decipher
+ (NSString *)autoKeyDecipher:(NSString *)inputtext withKeyword:(NSString *)keyword plain:(BOOL)plaintext
{
    NSString *inputString = [self formatString:inputtext];
    NSString *outputString = @"";
    NSString *s1 = [self formatString:keyword];
    NSString *resultString= @"";
    
    if ( !plaintext ) {
        s1 = [s1 stringByAppendingString:inputString];
        
        for (int x = 0; x < [inputString length] && !memoryCritical; x++) {
            for (int y = 0; y < 26 && !memoryCritical; y++) {
                if( tabulaRecta[ [s1 characterAtIndex:(x%s1.length)] - 'A' ][y] == [inputString characterAtIndex:x] )
                    outputString = [outputString stringByAppendingFormat:@"%c", tabulaRecta[0][y] ];
            }
        }
        
        for (int x = 0, y = 0; x < [outputString length] && !memoryCritical; x++, y++) {
            resultString = [resultString stringByAppendingFormat:@"%c", [outputString characterAtIndex:x]];
            if ((x + 1) % 5 == 0 && (x + 1) != [outputString length])
                resultString = [resultString stringByAppendingString:@" "];
        }
        
    }
    else {
        
        for (int x = 0; x < [inputString length] && !memoryCritical; x++) {
            for (int y = 0; y < 26 && !memoryCritical; y++) {
                if( tabulaRecta[ [s1 characterAtIndex:(x%s1.length)] - 'A' ][y] == [inputString characterAtIndex:x] )
                    outputString = [outputString stringByAppendingFormat:@"%c", tabulaRecta[0][y] ];
            }
            s1 = [s1 stringByAppendingFormat:@"%c", [outputString characterAtIndex:x]];
            s1 = [s1 uppercaseString];
        }
        
        for (int x = 0, y = 0; x < [outputString length] && !memoryCritical; x++, y++) {
            resultString = [resultString stringByAppendingFormat:@"%c", [outputString characterAtIndex:x]];
            if ((x + 1) % 5 == 0 && (x + 1) != [outputString length])
                resultString = [resultString stringByAppendingString:@" "];
        }
        
    }
    
    memoryCritical = NO;
    
    return resultString;
}


// AutoKey Plaintext Attack
+ (NSString *)autoKeyPlaintextAttack:(NSString *)inputtext maxKeywordLength:(int)length lowerFriedmanCutoff:(double)lower upperFriedmanCutoff:(double)upper
{
    NSString *inputString = [self formatString:inputtext];
    NSString *outputString = @"";
    NSString *s1 = @"";
    NSString *tempString = @"";
    NSString *resultString = @"";
    double array[256];
    double friedman = 0;
    int js = length;
    double friedman_cutoff_low = lower;
    double friedman_cutoff_hi = upper;
    int x, z, t, w;
    unichar y;
    
    for (x = 0; x < js && !memoryCritical; x++) {
        
        for (y = 'A'; y <= 'Z' && !memoryCritical; y++) {
            
            for (z = 1; z <= js && !memoryCritical; z++) {
                    s1 = @"";
                    tempString = @"";
                    outputString = @"";
                    friedman = 0;
                    
                    for (t = x; t < [inputString length] && !memoryCritical; t++) {
                        if ((t - x) % z == 0)
                            tempString = [tempString stringByAppendingFormat:@"%c", [inputString characterAtIndex:t]];
                    }
                    
                    s1 = [NSString stringWithFormat:@"%c", y];
                    
                    for (t = 0; t < [tempString length] && !memoryCritical; t++) {
                        
                        for (w = 0; w < 26 && !memoryCritical; w++) {
                            if( tabulaRecta[ [s1 characterAtIndex:(t%s1.length)] - 'A' ][w] == [tempString characterAtIndex:t] )
                                outputString = [outputString stringByAppendingFormat:@"%c", tabulaRecta[0][w]];
                        }
                        if( outputString.length > 0 & t < outputString.length )
                            s1 = [s1 stringByAppendingFormat:@"%c", [outputString characterAtIndex:t]];
                        s1 = [s1 uppercaseString];
                    }

                    outputString = [outputString uppercaseString];
                    
                    for (t = 0; t < 256 && !memoryCritical; t++)
                        array[t] = 0;
                    
                    
                    for (t = 0; t < [outputString length] && !memoryCritical; t++) {
                        
                        for (unichar c = 'A'; c <= 'Z' && !memoryCritical; c++) {
                            if ([outputString characterAtIndex:t] == c)
                                array[c]++;
                        }
                    }
                    
                    
                    for (unichar c = 'A'; c <= 'Z' && !memoryCritical; c++) {
                        friedman += array[c] / [outputString length] * ((array[c] - 1) / ([outputString length] - 1));
                    }
                    
                    if (friedman >= friedman_cutoff_low && friedman <= friedman_cutoff_hi) {
                        resultString = [resultString stringByAppendingFormat:@"Possibilities for letter %d of keyword %c ", x+1, y];
                        resultString = [resultString stringByAppendingFormat:@"keylength = %d Friedman = %f\n", z, friedman];
                    }
            }
            
        }
        
    }
    
    memoryCritical = NO;
    
    return resultString;
}


// Autokey Cyphertext Attack
+ (NSString *)autoKeyCyphertextAttack:(NSString *)inputtext keywordLength:(int)length
{
    NSString *inputString = [self formatString:inputtext];
    NSString *outputString = @"";
    NSString *s1 = @"";
    NSString *resultString = @"";
    double array[256];
    double friedman = 0;
    
    for (int x = 0; x < length && !memoryCritical; x++) {
        s1 = [s1 stringByAppendingString:@"A"];
    }
    
    s1 = [s1 stringByAppendingString:inputString];
    
    for (int x = 0; x < [inputString length] && !memoryCritical; x++) {
        
        for (int y = 0; y < 26 && !memoryCritical; y++) {
            if( tabulaRecta[ [s1 characterAtIndex:(x%s1.length)] - 'A' ][y] == [inputString characterAtIndex:x] )
                outputString = [outputString stringByAppendingFormat:@"%c", tabulaRecta[0][y]];
        }
    }
    
    for (int x = 0, y = 0; x < [outputString length] && !memoryCritical; x++, y++) {
        resultString = [resultString stringByAppendingFormat:@"%c", [outputString characterAtIndex:x]];
        if ((x + 1) % 5 == 0 && (x + 1) != [outputString length])
            resultString = [resultString stringByAppendingString:@" "];
    }
    
    outputString = [outputString uppercaseString];
    
    for (int x = 0; x < 256 && !memoryCritical; x++)
        array[x] = 0;
    
    
    for (int x = 0; x < [outputString length] && !memoryCritical; x++) {
        
        for (unichar y = 'A'; y <= 'Z' && !memoryCritical; y++) {
            if ([outputString characterAtIndex:x] == y)
                array[y]++;
        }
        
    }
    
    
    for (unichar x = 'A'; x <= 'Z' && !memoryCritical; x++) {
        friedman += array[x] / [outputString length] * ((array[x] - 1) / ([outputString length] - 1));
    }
    
    memoryCritical = NO;
    
    resultString = [resultString stringByAppendingFormat:@"\n\nFriedman value = %f", friedman];
    return resultString;
}


// Viginere Decipher
+ (NSString *)viginereDecipher:(NSString *)inputtext keyword:(NSString *)keyword
{
    NSString *inputString = [self formatString:inputtext];
    NSString *outputString = @"";
    NSString *s1 = [self formatString:keyword];
    NSString *resultString = @"";
    
    for (int x = 0; x < [inputString length] && !memoryCritical; x++) {
        
        for (int y = 0; y < 26 && !memoryCritical; y++) {
            if( tabulaRecta[ [s1 characterAtIndex:x%s1.length] - 'A' ][y] == [inputString characterAtIndex:x] )
                outputString = [outputString stringByAppendingFormat:@"%c", tabulaRecta[0][y]];
        }
        
    }
    
    for (int x = 0, y = 0; x < [outputString length] && !memoryCritical; x++, y++) {
        resultString = [resultString stringByAppendingFormat:@"%c", [outputString characterAtIndex:x]];
        if ((x + 1) % 5 == 0 && (x + 1) != [outputString length])
            resultString = [resultString stringByAppendingString:@" "];
    }
    
    memoryCritical = NO;
    
    return resultString;
}


// Viginere Encipher
+ (NSString *)viginereEncipher:(NSString *)inputtext keyword:(NSString *)keyword
{
    NSString *inputString = [self formatString:inputtext];
    NSString *outputString = @"";
    NSString *s1 = [self formatString:keyword];
    NSString *resultString = @"";
    
    for (int x = 0; x < [inputString length] && !memoryCritical; x++) {
        outputString = [outputString stringByAppendingFormat:@"%c", tabulaRecta[ [s1 characterAtIndex:x%s1.length] - 'A' ][ [inputString characterAtIndex:x] - 'A' ]];
    }
    
    for (int x = 0, y = 0; x < [outputString length] && !memoryCritical; x++, y++) {
        resultString = [resultString stringByAppendingFormat:@"%c", [outputString characterAtIndex:x]];
        if ((x + 1) % 5 == 0 && (x + 1) != [outputString length])
            resultString = [resultString stringByAppendingString:@" "];
    }
    
    memoryCritical = NO;
    
    return resultString;
}


// Poly/Mono Calculator
+ (NSString *)polyMonoCalculator:(NSString *)inputtext keywordSize:(int)size
{
    NSString *inputString = [self formatString:inputtext];
    NSString *tempString;
    double array[256];
    double friedman = 0;
    int spinnerValue = size;
    NSString *resultString = @".065 = Monoalphabetic, .038 means polyalphabetic.\n\n";
    
    for (int z = 0; z < spinnerValue && !memoryCritical; z++) {
        tempString = @"";
        friedman = 0;
        
        for (int x = 0; x < [inputString length] && !memoryCritical; x++) {
            if ((x - z % spinnerValue) % spinnerValue == 0)
                tempString = [tempString stringByAppendingFormat:@"%c", [inputString characterAtIndex:x]];
        }
        
        
        for (int x = 0; x < 256 && !memoryCritical; x++)
            array[x] = 0;
        
        
        for (int x = 0; x < [tempString length] && !memoryCritical; x++) {
            
            for (unichar y = 'A'; y <= 'Z' && !memoryCritical; y++) {
                if ([tempString characterAtIndex:x] == y)
                    array[y]++;
            }
            
        }
        
        
        for (unichar x = 'A'; x <= 'Z' && !memoryCritical; x++) {
            friedman += array[x] / [tempString length] * ((array[x] - 1) / ([tempString length] - 1));
        }
        
        resultString = [resultString stringByAppendingFormat:@"%f\n", friedman];
    }
    
    memoryCritical = NO;
    
    return  resultString;
}


// Strip off the alphabets
+ (NSString *)stripOffTheAlphabets:(NSString *)inputtext wordLength:(int)length
{
    NSString * inputString = [self formatString:inputtext];
    int wordLength = length;
    NSString *resultString = @"";
    NSMutableArray *strings = [[NSMutableArray alloc] initWithCapacity:wordLength];
    
    if( wordLength != 0 )
    {
        for( int x = 0; x < wordLength && !memoryCritical; x++ )
            [strings addObject:@""];
        
        for( int x = 0; x < [inputString length] && !memoryCritical; x++ )
            [strings replaceObjectAtIndex:x%wordLength withObject:[[strings objectAtIndex:x%wordLength] stringByAppendingFormat:@"%c", [inputString characterAtIndex:x]]];
        
        for( int x = 0; x < wordLength && !memoryCritical; x++ )
            resultString = [resultString stringByAppendingFormat:@"%@\n\n", [strings objectAtIndex:x]];
    }
    else
        resultString = @"Wordlength must be greater than 0";
    
//    for (int x = 0; x < [inputString length]; x++) {
//        if( x%wordLength == 0 & x != 0 )
//            resultString = [resultString stringByAppendingString:@"\n"];
//        resultString = [resultString stringByAppendingFormat:@"%c", [inputString characterAtIndex:x]];
//    }
    
    memoryCritical = NO;
    
    return resultString;
}


// Affine Decipher
+ (NSString *)affineDecipher:(NSString *)inputtext multiplicativeShift:(int)multiplier additiveShift:(int)additive
{
    NSString *inputString = [self formatString:inputtext];
    NSString *resultString = @"";
    char *charArray = (char *)[inputString UTF8String];
    int m;
    int a = additive;
    
    // set the multiplicative inverse
    if( multiplier == 1 )
        m = 1;
    else if( multiplier == 3 )
        m = 9;
    else if( multiplier == 5 )
        m = 21;
    else if( multiplier == 7 )
        m = 15;
    else if( multiplier == 9 )
        m = 3;
    else if( multiplier == 11 )
        m = 19;
    else if( multiplier == 15 )
        m = 7;
    else if( multiplier == 17 )
        m = 23;
    else if( multiplier == 19 )
        m = 11;
    else if( multiplier == 21 )
        m = 5;
    else if( multiplier == 23 )
        m = 17;
    else
        m = 25;
    
    for (int x = 0; x < [inputString length] && !memoryCritical; x++) {
        charArray[x] = (char)(charArray[x] - 64);
        charArray[x] = (char)((charArray[x] + (26-a))%26);
        charArray[x] = (char)((charArray[x] * m) % 26);
        if (charArray[x] == 0)
            charArray[x] = (char)26;
        charArray[x] = (char)(charArray[x] + 64);
    }
    
    for (int x = 0, y = 0; x < inputString.length && !memoryCritical; x++, y++) {
        resultString = [resultString stringByAppendingFormat:@"%c", charArray[y]];
        if ((x + 1) % 5 == 0 && (x + 1) != inputString.length)
            resultString = [resultString stringByAppendingString:@" "];
    }
    
    memoryCritical = NO;
    
    return resultString;
}


// Affine Encipher
+ (NSString *)affineEncipher:(NSString *)inputtext multiplicativeShift:(int)multiplier additiveShift:(int)additive
{
    NSString *inputString = [self formatString:inputtext];
    NSString *resultString = @"";
    char *charArray = (char *)[inputString UTF8String];
    int m = multiplier;
    int a = additive;
    
    for (int x = 0; x < inputString.length && !memoryCritical; x++) {
        charArray[x] = (char)(charArray[x] - 64);
        charArray[x] = (char)((charArray[x] * m) % 26);
        charArray[x] = (char)((charArray[x] + a) % 26);
        if (charArray[x] == (char)0)
            charArray[x] = (char)26;
        charArray[x] = (char)(charArray[x] + 64);
    }
    
    for (int x = 0, y = 0; x < inputString.length && !memoryCritical; x++, y++) {
        resultString = [resultString stringByAppendingFormat:@"%c", charArray[y]];
        if ((x + 1) % 5 == 0 && (x + 1) != inputString.length)
            resultString = [resultString stringByAppendingString:@" "];
    }
    
    memoryCritical = NO;
    
    return resultString;
}

// Affine known plaintext attack
+ (NSString *)affineKnownPlainttextAttack:(NSString *)inputtext keyword:(NSString *)keyword shiftFirst:(BOOL)shiftFirst
{
    NSString *inputString = [self formatString:inputtext];
    NSString *searchString = [self formatString:keyword];
    NSString *resultString = @"";
    
    resultString = [resultString stringByAppendingFormat:@"The following are all the possible combinations of \"%@\" ", searchString];
    resultString = [resultString stringByAppendingString:@"which are contained in the cyphertext message and the affine"];
    resultString = [resultString stringByAppendingString:@"keys used to encrypt them.\n\n"];
    
    if (!shiftFirst) {
        resultString = [resultString stringByAppendingString:[self searchCeasar:1 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:3 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:5 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:7 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:9 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:11 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:15 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:17 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:19 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:21 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:23 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasar:25 inputString:inputString searchString:searchString]];
    }
    else {
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:1 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:3 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:5 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:7 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:9 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:11 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:15 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:17 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:19 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:21 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:23 inputString:inputString searchString:searchString]];
        resultString = [resultString stringByAppendingString:[self searchCeasarReverse:25 inputString:inputString searchString:searchString]];
    }
    
    return resultString;
}


// NGraphs
+ (NSString *)getNgraphs:(NSString *)inputtext lengthOfNgraphs:(int)aLength
{
    NSString *inputString = [self formatString:inputtext];
    int js = aLength;
    NSString *tempString;
    Counter *counter = [[Counter alloc] init];
    NSString *resultString = @"";

    if( js <= inputString.length ) {
        for (int x = 0; x < [inputString length] - (js - 1) && !memoryCritical; x++) {
            tempString = [inputString substringWithRange:NSMakeRange(x, js)];
            if ( ([inputString rangeOfString:tempString options:0 range:NSMakeRange(x, [inputString length]-x)].location) != NSNotFound) {
                if (![counter contains:tempString]) {
                    [counter add:tempString atPosition:x];
                    
                    NSUInteger length = [inputString length];
                    NSRange range = NSMakeRange(x+js, length - (x+js));
                    while( range.location != NSNotFound && !memoryCritical )
                    {
                        range = [inputString rangeOfString:tempString options:0 range:range];
                        if( range.location != NSNotFound )
                        {
                            [counter increment:range.location];
                            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                        }
                    }
                }
            }
        }
        
        for (int x = 0; x < counter.length && !memoryCritical; x++) {
            resultString = [resultString stringByAppendingFormat:@"%@ = ", [[counter sArray] objectAtIndex:x]];
            resultString = [resultString stringByAppendingFormat:@"%d at positions ", [counter getIArrayElement:x]];
            
            for (int y = 0; y < [counter getIArrayElement:x] && !memoryCritical; y++) {
                resultString = [resultString stringByAppendingFormat:@"%d",[counter getPArrayElement:x y:y]];
                if (y != [counter getIArrayElement:x] - 1)
                    resultString = [resultString stringByAppendingString:@","];
            }
            
            resultString = [resultString stringByAppendingString:@"\n"];
        }
    }
    
    if( [resultString isEqualToString:@"\n"] || [resultString isEqualToString:@""] ) {
        resultString = [NSString stringWithFormat:@"No graphs of size %d", aLength];
    }
    
    memoryCritical = NO;
    
    return resultString;
}


// Trigraphs
+ (NSString *)getTrigraphs:(NSString *)inputtext
{
    NSString *inputString = [self formatString:inputtext];
    int js = 3;
    NSString *tempString;
    Counter *counter = [[Counter alloc] init];
    NSString *resultString = @"";
    
    for (int x = 0; x < [inputString length] - (js - 1) && !memoryCritical; x++) {
        tempString = [inputString substringWithRange:NSMakeRange(x, js)];
        if ( ([inputString rangeOfString:tempString options:0 range:NSMakeRange(x, [inputString length]-x)].location) != NSNotFound) {
            if (![counter contains:tempString]) {
                [counter add:tempString atPosition:x];
                
                NSUInteger length = [inputString length];
                NSRange range = NSMakeRange(x+js, length - (x+js));
                while( range.location != NSNotFound  && !memoryCritical)
                {
                    range = [inputString rangeOfString:tempString options:0 range:range];
                    if( range.location != NSNotFound )
                    {
                        [counter increment:range.location];
                        range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                    }
                }
            }
        }
    }
    
    for (int x = 0; x < counter.length && !memoryCritical; x++) {
        resultString = [resultString stringByAppendingFormat:@"%@ = ", [[counter sArray] objectAtIndex:x]];
        resultString = [resultString stringByAppendingFormat:@"%d at positions ", [counter getIArrayElement:x]];
        
        for (int y = 0; y < [counter getIArrayElement:x] && !memoryCritical; y++) {
            resultString = [resultString stringByAppendingFormat:@"%d",[counter getPArrayElement:x y:y]];
            if (y != [counter getIArrayElement:x] - 1)
                resultString = [resultString stringByAppendingString:@","];
        }
        
        resultString = [resultString stringByAppendingString:@"\n"];
    }
    
    memoryCritical = NO;
    
    return resultString;
}


// Bigraphs
+ (NSString *)getBigraphs:(NSString *)inputtext
{
    NSString *inputString = [self formatString:inputtext];
    int js = 2;
    NSString *tempString;
    Counter *counter = [[Counter alloc] init];
    NSString *resultString = @"";
    
    for (int x = 0; x < [inputString length] - (js - 1) && !memoryCritical; x++) {
        tempString = [inputString substringWithRange:NSMakeRange(x, js)];
        if ( ([inputString rangeOfString:tempString options:0 range:NSMakeRange(x, [inputString length]-x)].location) != NSNotFound) {
            if (![counter contains:tempString]) {
                [counter add:tempString atPosition:x];
                
                NSUInteger length = [inputString length];
                NSRange range = NSMakeRange(x+js, length - (x+js));
                while( range.location != NSNotFound && !memoryCritical )
                {
                    range = [inputString rangeOfString:tempString options:0 range:range];
                    if( range.location != NSNotFound )
                    {
                        [counter increment:range.location];
                        range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                    }
                }
            }
        }
    }
    
    for (int x = 0; x < counter.length && !memoryCritical; x++) {
        resultString = [resultString stringByAppendingFormat:@"%@ = ", [[counter sArray] objectAtIndex:x]];
        resultString = [resultString stringByAppendingFormat:@"%d at positions ", [counter getIArrayElement:x]];
        
        for (int y = 0; y < [counter getIArrayElement:x] && !memoryCritical; y++) {
            resultString = [resultString stringByAppendingFormat:@"%d",[counter getPArrayElement:x y:y]];
            if (y != [counter getIArrayElement:x] - 1)
                resultString = [resultString stringByAppendingString:@","];
        }
        
        resultString = [resultString stringByAppendingString:@"\n"];
    }
    
    memoryCritical = NO;
    
    return resultString;
}


// Run the alphabet
+ (NSString *)runTheAlphabet:(NSString *)inputtext
{
    NSString *inputString = inputtext;
    inputString = [inputString lowercaseString];
    NSString *resultString = @"";
    
    for (int x = 0; x < 26 && !memoryCritical; x++) {
        for (int y = 0; y < [inputString length] && !memoryCritical; y++) {
            if ([inputString characterAtIndex:y] >= 'a' && [inputString characterAtIndex:y] <= 'z') {
                resultString = [resultString stringByAppendingFormat:@"%c", (char)(([inputString characterAtIndex:y] + x) % ('z' +1) + (int)(([inputString characterAtIndex:y] + x ) / ('z' + 1)) * 'a' )];
            }
            else
                resultString = [resultString stringByAppendingString:@" "];
        }
        
        resultString = [resultString stringByAppendingString:@"\n\n"];
    }
    
    memoryCritical = NO;
    
    return resultString;
}

// Frequency Count
+ (NSString *)frequencyCount:(NSString *)inputtext
{
    NSString *inputString = [self removePunctuationSpecialCharacters:inputtext];
    inputString = [inputString uppercaseString];
    int array[26];
    NSMutableArray *sArray = [[NSMutableArray alloc] init];
    NSString *resultString = @"";
    
    for (int x = 0; x < 26 && !memoryCritical; x++ )
        array[x] = 0;
    
    for (int x = 0; x < [inputString length] && !memoryCritical; x++) {
        
        switch ([inputString characterAtIndex:x]) {
            case 'A': array[0]++; break;
            case 'B': array[1]++; break;
            case 'C': array[2]++; break;
            case 'D': array[3]++; break;
            case 'E': array[4]++; break;
            case 'F': array[5]++; break;
            case 'G': array[6]++; break;
            case 'H': array[7]++; break;
            case 'I': array[8]++; break;
            case 'J': array[9]++; break;
            case 'K': array[10]++; break;
            case 'L': array[11]++; break;
            case 'M': array[12]++; break;
            case 'N': array[13]++; break;
            case 'O': array[14]++; break;
            case 'P': array[15]++; break;
            case 'Q': array[16]++; break;
            case 'R': array[17]++; break;
            case 'S': array[18]++; break;
            case 'T': array[19]++; break;
            case 'U': array[20]++; break;
            case 'V': array[21]++; break;
            case 'W': array[22]++; break;
            case 'X': array[23]++; break;
            case 'Y': array[24]++; break;
            case 'Z': array[25]++; break;
        }
    }

    for (int x = 0; x < 26 && !memoryCritical; x++) {
        resultString = [resultString stringByAppendingFormat:@"%c = %d =\t", ('A'+x), array[x]];
        
        for (int y = 0; y < array[x] && !memoryCritical; y++)
            resultString = [resultString stringByAppendingString:@"I"];
        
        if(x != 26)
            resultString = [resultString stringByAppendingString:@"\n"];
    }
    
    resultString = [resultString stringByAppendingString:@"\n"];
    [sArray addObjectsFromArray:[inputString componentsSeparatedByString:@" "]];
    resultString = [resultString stringByAppendingString:@"\nHere are all the 1 letter words\n"];
    
    for (int x = 0; x < [sArray count] && !memoryCritical; x++) {
        if ([[sArray objectAtIndex:x] length] == 1)
            resultString = [resultString stringByAppendingFormat:@"%@\n", [sArray objectAtIndex:x]];
    }
    
    resultString = [resultString stringByAppendingString:@"\nHere are all the 2 letter words\n"];
    
    for (int x = 0; x < [sArray count] && !memoryCritical; x++) {
        if ([[sArray objectAtIndex:x] length] == 2)
            resultString = [resultString stringByAppendingFormat:@"%@\n", [sArray objectAtIndex:x]];
    }
    
    resultString = [resultString stringByAppendingString:@"\nHere are all the 3 letter words\n"];
    
    for (int x = 0; x < [sArray count] && !memoryCritical; x++) {
        if ([[sArray objectAtIndex:x] length] == 3)
            resultString = [resultString stringByAppendingFormat:@"%@\n", [sArray objectAtIndex:x]];
    }
    
    resultString = [resultString stringByAppendingString:@"\nHere are all the initial letters\n"];
    
    for (int x = 0; x < [sArray count] && !memoryCritical; x++) {
        if ([[sArray objectAtIndex:x] length] > 0)
            resultString = [resultString stringByAppendingFormat:@"%c ", [[sArray objectAtIndex:x] characterAtIndex:0]];
    }
    
    resultString = [resultString stringByAppendingString:@"\n\nHere are all the final letters\n"];
    
    for (int x = 0; x < [sArray count] && !memoryCritical; x++) {
        if ([[sArray objectAtIndex:x] length] > 0)
            resultString = [resultString stringByAppendingFormat:@"%c ", [[sArray objectAtIndex:x] characterAtIndex:[[sArray objectAtIndex:x] length]-1] ];
    }
    
    resultString = [resultString stringByAppendingString:@"\n\nHere are all the doubled letters\n"];
    char c = [inputString characterAtIndex:0];
    
    for (int x = 1; x < [inputString length] && !memoryCritical; x++) {
        if ([inputString characterAtIndex:x] == c)
            resultString = [resultString stringByAppendingFormat:@"%c%c ", c, c];
        c = [inputString characterAtIndex:x];
    }
    
    resultString = [resultString stringByAppendingString:@"\n\nFrequencies for English\n"];
    resultString = [resultString stringByAppendingString:@"a = 07 =\tIIIIIII\n"];
    resultString = [resultString stringByAppendingString:@"b = 01 =\tI\n"];
    resultString = [resultString stringByAppendingString:@"c = 03 =\tIII\n"];
    resultString = [resultString stringByAppendingString:@"d = 04 =\tIIII\n"];
    resultString = [resultString stringByAppendingString:@"e = 13 =\tIIIIIIIIIIIII\n"];
    resultString = [resultString stringByAppendingString:@"f = 03 =\tIII\n"];
    resultString = [resultString stringByAppendingString:@"g = 02 =\tII\n"];
    resultString = [resultString stringByAppendingString:@"h = 04 =\tIIII\n"];
    resultString = [resultString stringByAppendingString:@"i = 07 =\tIIIIIII\n"];
    resultString = [resultString stringByAppendingString:@"j =\n"];
    resultString = [resultString stringByAppendingString:@"k =\n"];
    resultString = [resultString stringByAppendingString:@"l = 04 =\tIIII\n"];
    resultString = [resultString stringByAppendingString:@"m = 03 =\tIII\n"];
    resultString = [resultString stringByAppendingString:@"n = 08 =\tIIIIIIII\n"];
    resultString = [resultString stringByAppendingString:@"o = 07 =\tIIIIIII\n"];
    resultString = [resultString stringByAppendingString:@"p = 03 =\tIII\n"];
    resultString = [resultString stringByAppendingString:@"q =\n"];
    resultString = [resultString stringByAppendingString:@"r = 08 =\tIIIIIIII\n"];
    resultString = [resultString stringByAppendingString:@"s = 06 =\tIIIIII\n"];
    resultString = [resultString stringByAppendingString:@"t = 09 =\tIIIIIIIII\n"];
    resultString = [resultString stringByAppendingString:@"u = 03 =\tIII\n"];
    resultString = [resultString stringByAppendingString:@"v = 01 =\tI\n"];
    resultString = [resultString stringByAppendingString:@"w = 02 =\tII\n"];
    resultString = [resultString stringByAppendingString:@"x =\n"];
    resultString = [resultString stringByAppendingString:@"y = 02 =\tII\n"];
    resultString = [resultString stringByAppendingString:@"z ="];
    
    memoryCritical = NO;
    
    return resultString;
}


// Search possible affine ciphers. Helper method for Affine Known Plaintext Attack
+ (NSString *) searchCeasar:(int)m inputString:(NSString *)inputString searchString:(NSString *)searchString {
    int counter;
    NSString *mSearchString;
    char* charArray;
    NSString *resultString = @"";
    
    for (int x = 0; x < 26 && !memoryCritical; x++) {
        charArray = (char *)[searchString UTF8String];
        
        for (int y = 0; y < searchString.length && !memoryCritical; y++) {
            charArray[y] = (char)(charArray[y] - 64);
            charArray[y] = (char)((charArray[y] * m) % 26);
            charArray[y] = (char)((charArray[y] + x) % 26);
            if (charArray[y] == (char)0)
                charArray[y] = (char)26;
            charArray[y] = (char)(charArray[y] + 64);
        }
        
        mSearchString = [[NSString alloc] initWithUTF8String:charArray];
        counter = 0;
                        
        NSUInteger length = [inputString length];
        NSRange range = NSMakeRange(0, length);
        while(range.location != NSNotFound  && !memoryCritical)
        {
            range = [inputString rangeOfString:mSearchString options:0 range:range];
            if(range.location != NSNotFound)
            {
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                counter++; 
            }
        }
                        
        if (counter > 0) {
            resultString = [resultString stringByAppendingFormat:@"%@ appears %d times with a multiplicative key = %d and an additive key = %d\n",
                            mSearchString, counter, m, x, nil];
        }
    }
    
    memoryCritical = NO;
    
    return resultString;
}

// Search possible affine ciphers shifting first. Helper method for Affine Known Plaintext Attack
+ (NSString *) searchCeasarReverse:(int)m inputString:(NSString *)inputString searchString:(NSString *)searchString {
    int counter;
    NSString *mSearchString;
    char* charArray;
    NSString *resultString = @"";
    
    for (int x = 0; x < 26 && !memoryCritical; x++) {
        charArray = (char *)[searchString UTF8String];
        
        for (int y = 0; y < searchString.length && !memoryCritical; y++) {
            charArray[y] = (char)(charArray[y] - 64);
            charArray[y] = (char)((charArray[y] + x) % 26);
            charArray[y] = (char)((charArray[y] * m) % 26);
            if (charArray[y] == (char)0)
                charArray[y] = (char)26;
            charArray[y] = (char)(charArray[y] + 64);
        }
        
        mSearchString = [NSString stringWithUTF8String:charArray];
        counter = 0;

        NSUInteger length = [inputString length];
        NSRange range = NSMakeRange(0, length); 
        while(range.location != NSNotFound && !memoryCritical)
        {
            range = [inputString rangeOfString:mSearchString options:0 range:range];
            if(range.location != NSNotFound)
            {
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                counter++; 
            }
        }
        
        if (counter > 0) {
            resultString = [resultString stringByAppendingFormat:@"%@ appears %d times with a multiplicative key = %d and an additive key = %d\n",
                            mSearchString, counter, m, x, nil];
        }
    }
    
    memoryCritical = NO;
    
    return resultString;
}


// Removes punctuation
+ (NSString *)removePunctuationSpecialCharacters:(NSString *)string
{
    NSString *inputString = string;
    inputString = [inputString stringByReplacingOccurrencesOfString:@"," withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"." withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"?" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\"" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"!" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"@" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"#" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"$" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"%" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"^" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"&" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"*" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"(" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@")" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"/" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\\" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"<" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@">" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\'" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"~" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"`" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"[" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"]" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"|" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"{" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"}" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"=" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@":" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@";" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return inputString;
}


// Removes special characters, punctuation, and spaces from a string
+ (NSString *)formatString:(NSString *)string
{
    NSString *inputString = string.uppercaseString;
    inputString = [inputString stringByReplacingOccurrencesOfString:@"," withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"." withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"?" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\"" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"!" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"@" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"#" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"$" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"%" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"^" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"&" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"*" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"(" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@")" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"/" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\\" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"<" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@">" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\'" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"~" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"`" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"[" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"]" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"|" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"{" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"}" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"=" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@":" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@";" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"0" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"1" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"2" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"3" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"4" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"5" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"6" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"7" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"8" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"9" withString:@" "];
    inputString = [inputString stringByReplacingOccurrencesOfString:@" " withString:@""];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    inputString = [inputString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return inputString;
}

@end

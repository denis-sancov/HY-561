//
//  NSString+FilteredString.m
//  TrippleCreator
//
//  Created by Denis Sancov on 14.04.16.
//  Copyright © 2016 University of Crete. All rights reserved.
//

#import "NSString+FilteredString.h"

@implementation NSString (FilteredString)

- (NSString *)filter {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end

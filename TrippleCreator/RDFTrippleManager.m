//
//  RDFTrippleManager.m
//  TrippleCreator
//
//  Created by Denis Sancov on 12.04.16.
//  Copyright © 2016 University of Crete. All rights reserved.
//

#import "RDFTrippleManager.h"

@implementation RDFTrippleManager

+ (void)createRDFTripplesFrom:(NSArray<APYoutubeVideoObject *> *)videos {
    NSMutableString *tripples = [NSMutableString string];
    [videos enumerateObjectsUsingBlock:^(APYoutubeVideoObject *obj, NSUInteger idx, BOOL *stop) {
        [tripples appendFormat:@"%@\n",[obj tripleRepresentation]];
    }];
    
//    NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *path = [NSString stringWithFormat:@"%@/triples",NSHomeDirectory()];
//    [[NSFileManager defaultManager] createFileAtPath:path
//                                            contents:fileContents
//                                          attributes:nil];
}

@end

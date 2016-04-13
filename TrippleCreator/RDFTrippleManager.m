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
    [tripples appendString:@"@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n"];
    [tripples appendString:@"@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n"];
    [tripples appendString:@"@prefix ex: <http://example.org/stuff/1.0/> .\n\n"];
    
    [tripples appendString:@"<http://www.w3.org/TR/rdf-syntax-grammar>\n\n"];

    [videos enumerateObjectsUsingBlock:^(APYoutubeVideoObject *obj, NSUInteger idx, BOOL *stop) {
        [tripples appendFormat:@"%@\n",[obj tripleRepresentation]];
    }];
    
    NSData *fileContents = [tripples dataUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [NSString stringWithFormat:@"%@/triples.txt",NSHomeDirectory()];
    [[NSFileManager defaultManager] createFileAtPath:path
                                            contents:fileContents
                                          attributes:nil];
}

@end

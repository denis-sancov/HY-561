//
//  main.m
//  TrippleCreator
//
//  Created by Denis Sancov on 12.04.16.
//  Copyright © 2016 University of Crete. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APYoutubeVideoObject.h"
#import "RDFTrippleManager.h"

static NSString *queryString = @"El Greco";
int stopProgramm = 0;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *results = [NSMutableArray array];
        [APYoutubeVideoObject getObjectsWithQuery:queryString
                                    nextPageToken:nil
                                    numberOfItems:2000
                                     storeResults:results
                                         onFinish:^{
                                             NSLog(@"finish %td", [results count]);
                                             [RDFTrippleManager createRDFTripplesFrom:results
                                                                 storeThemInFileNamed:queryString];
                                             stopProgramm = 1;
                                         }];        
        while (!stopProgramm) {}
    }
    return 0;
}

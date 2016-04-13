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

int stopProgramm = 0;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *results = [NSMutableArray array];
        [APYoutubeVideoObject getObjectsWithQuery:@"δομίνικος θεοτοκόπουλος"
                                    nextPageToken:nil
                                    numberOfItems:50
                                     storeResults:results
                                         onFinish:^{
                                             NSLog(@"finish %td", [results count]);
                                             [RDFTrippleManager createRDFTripplesFrom:results];
                                             stopProgramm = 1;
                                         }];
        
        while (!stopProgramm) {}
    }
    return 0;
}

//
//  RDFTrippleManager.h
//  TrippleCreator
//
//  Created by Denis Sancov on 12.04.16.
//  Copyright © 2016 University of Crete. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APYoutubeVideoObject.h"

@interface RDFTrippleManager : NSObject

+ (void)createRDFTripplesFrom:(NSArray<APYoutubeVideoObject *> *)videos
         storeThemInFileNamed:(NSString *)fileNamed;

@end

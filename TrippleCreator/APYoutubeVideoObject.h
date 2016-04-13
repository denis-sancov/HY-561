//
//  APYoutubeVideoObject.h
//  TrippleCreator
//
//  Created by Denis Sancov on 12.04.16.
//  Copyright © 2016 University of Crete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APYoutubeVideoObject : NSObject

@property (copy, nonatomic, readonly) NSString *youtubeURLString;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *detail;
@property (copy, nonatomic, readonly) NSDate *publicationDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)tripleRepresentation;

+ (NSArray<APYoutubeVideoObject *> *)objectsFromDictionary:(NSDictionary *)dictionary;

+ (void)getObjectsWithQuery:(NSString *)query
              nextPageToken:(NSString *)nextPageToken
              numberOfItems:(NSUInteger)numberOfItems
               storeResults:(NSMutableArray<APYoutubeVideoObject *> *)results
                   onFinish:(void(^)(void))finish;

@end

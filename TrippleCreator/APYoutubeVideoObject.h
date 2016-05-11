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
@property (strong, nonatomic, readonly) NSDate *publicationDate;
@property (strong, nonatomic, readonly) NSNumber *viewCount;
@property (strong, nonatomic, readonly) NSNumber *isPopular;
@property (strong, nonatomic, readonly) NSArray *tags;
@property (copy, nonatomic, readonly) NSString *channelTitle;
@property (copy, nonatomic, readonly) NSString *channelURLString;
@property (copy, nonatomic, readonly) NSString *duration;
@property (copy, nonatomic, readonly) NSString *definition;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)tripleRepresentation;

+ (NSArray<APYoutubeVideoObject *> *)objectsFromDictionary:(NSDictionary *)dictionary;

+ (void)getObjectsWithQuery:(NSString *)query
              nextPageToken:(NSString *)nextPageToken
              numberOfItems:(NSUInteger)numberOfItems
               storeResults:(NSMutableArray<APYoutubeVideoObject *> *)results
                   onFinish:(void(^)(void))finish;

@end

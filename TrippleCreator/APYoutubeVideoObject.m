//
//  APYoutubeVideoObject.m
//  TrippleCreator
//
//  Created by Denis Sancov on 12.04.16.
//  Copyright © 2016 University of Crete. All rights reserved.
//

#import "APYoutubeVideoObject.h"

@implementation APYoutubeVideoObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _youtubeURLString = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", [dictionary valueForKeyPath:@"id.videoId"]];
        NSDictionary *snippet = dictionary[@"snippet"];
        _title = snippet[@"title"];
        _detail = snippet[@"description"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.locale = enUSPOSIXLocale;
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        _publicationDate = [dateFormatter dateFromString:snippet[@"publishedAt"]];
    }
    return self;
}

- (NSString *)tripleRepresentation {
    return [NSString stringWithFormat:@""];
}

+ (NSArray<APYoutubeVideoObject *> *)objectsFromDictionary:(NSDictionary *)dictionary {
    
    NSArray *items = dictionary[@"items"];
    NSMutableArray *result = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[[self alloc] initWithDictionary:obj]];
    }];
    return result;
}

+ (void)getObjectsWithQuery:(NSString *)query
              nextPageToken:(NSString *)nextPageToken
              numberOfItems:(NSUInteger)numberOfItems
               storeResults:(NSMutableArray<APYoutubeVideoObject *> *)results
                   onFinish:(void(^)(void))finish {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"www.googleapis.com";
    components.path = @"/youtube/v3/search";
    NSMutableDictionary *params = [@{
        @"key":@"AIzaSyB3c4NmcmnAgA95IEhqtlgjpwpy0thzudg",
        @"part":@"snippet",
        @"type":@"video",
        @"order":@"viewCount",
        @"q":query,
        @"maxResults":@"50"
    } mutableCopy];
    if (nextPageToken != nil) {
        params[@"pageToken"] = nextPageToken;
    }
    NSMutableArray *items = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * _Nonnull stop) {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:obj];
        [items addObject:item];
    }];
    components.queryItems = items;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[components URL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (error != nil) {
                    NSLog(@"got error %@",error);
                } else {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                    NSLog(@"result %@", result);
                    NSArray *videos = [APYoutubeVideoObject objectsFromDictionary:result];
                    if ([videos count] == 0) {
                        return;
                    }
                    [results addObjectsFromArray:videos];
                    if ([results count] < numberOfItems) {
                        NSLog(@"new request with offset %td", [results count]);
                        [self getObjectsWithQuery:query
                                    nextPageToken:result[@"nextPageToken"]
                                    numberOfItems:numberOfItems
                                     storeResults:results
                                         onFinish:finish];
                        return;
                    }
                }
                finish();
            }] resume];

}

@end

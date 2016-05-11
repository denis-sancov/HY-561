//
//  APYoutubeVideoObject.m
//  TrippleCreator
//
//  Created by Denis Sancov on 12.04.16.
//  Copyright © 2016 University of Crete. All rights reserved.
//

#import "APYoutubeVideoObject.h"
#import "NSString+FilteredString.h"

@implementation APYoutubeVideoObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _youtubeURLString = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", dictionary[@"id"]];
        NSDictionary *snippet = dictionary[@"snippet"];
        _title = snippet[@"title"];
        _detail = snippet[@"description"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.locale = enUSPOSIXLocale;
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        _publicationDate = [dateFormatter dateFromString:snippet[@"publishedAt"]];
        
        _tags = snippet[@"tags"];
        
        _channelTitle = snippet[@"channelTitle"];
        _channelURLString =  [NSString stringWithFormat:@"https://www.youtube.com/channel/%@", snippet[@"channelId"]];
        
        NSDictionary *stats = dictionary[@"statistics"];
        NSInteger viewCount = [stats[@"viewCount"] integerValue];
        _viewCount = @(viewCount);
        _isPopular = @(viewCount > 1000);
        
        NSDictionary *contentDetails = dictionary[@"contentDetails"];
        _duration = contentDetails[@"duration"];
        _definition = contentDetails[@"definition"];
        
    }
    return self;
}

- (NSString *)tripleRepresentation {
    NSMutableString *triple = [NSMutableString string];
    [triple appendString:@"{\n"];
    [triple appendFormat:@"<%@> crm:hasTitle \"%@\";\n",_youtubeURLString, _title];
    [triple appendFormat:@"    crm:videoURL %@;\n", _youtubeURLString];
    [triple appendFormat:@"    crm:hasDescription \"%@\";\n", _detail];
    [triple appendFormat:@"    crm:hasViewCount \"%@\";\n", _viewCount];
    [triple appendFormat:@"    crm:hasUploadDate \"%@\";\n", _publicationDate];
    [triple appendFormat:@"    crm:fromChannel \"%@\";\n", _channelURLString];
    [triple appendFormat:@"    crm:hasDuration \"%@\";\n", _duration];
    [triple appendFormat:@"    crm:isPopular \"%@\";\n", _isPopular];
    [triple appendFormat:@"    crm:tags \"%@\";\n", [_tags componentsJoinedByString:@","]];
    [triple appendFormat:@"    crm:kindOfDefinition \"%@\".\n", _definition];
    [triple appendFormat:@"    crm:typeOfVideo \" \".\n"];
    [triple appendString:@"}\n"];

    return triple;
}

+ (NSArray<APYoutubeVideoObject *> *)objectsFromDictionary:(NSDictionary *)dictionary {
    NSArray *items = dictionary[@"items"];
    NSMutableArray *result = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *stats = obj[@"statistics"];
        NSInteger viewCount = [stats[@"viewCount"] integerValue];
        if (viewCount >= 50) {
            [result addObject:[[self alloc] initWithDictionary:obj]];
        }
    }];
    return result;
}

+ (void)performRequestWithPath:(NSString *)path
                        params:(NSDictionary *)params
                      onFinish:(void(^)(NSDictionary *))finish {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"www.googleapis.com";
    components.path = path;
    
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
                    finish(nil);
                } else {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:nil];
                    finish(result);
                }
            }] resume];
}


+ (void)getInformationAboutVideos:(NSArray<NSDictionary *> *)videos
                         onFinish:(void(^)(NSArray<APYoutubeVideoObject *> *))finish {
    NSMutableArray<NSString *> *ids = [NSMutableArray array];
    [videos enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ids addObject:[obj valueForKeyPath:@"id.videoId"]];
    }];
    NSDictionary *params = @{
        @"key":@"AIzaSyB3c4NmcmnAgA95IEhqtlgjpwpy0thzudg",
        @"id":[ids componentsJoinedByString:@","],
        @"part":@"snippet, statistics, contentDetails, topicDetails",
        @"type":@"video",
        @"order":@"viewCount",
        @"maxResults":@"50"
    };
    
    [self performRequestWithPath:@"/youtube/v3/videos"
                          params:params
                        onFinish:^(NSDictionary *response) {
                            NSLog(@"response %@", response);
                            NSArray *videos = [APYoutubeVideoObject objectsFromDictionary:response];
                            finish(videos);
                        }];
}

+ (void)getObjectsWithQuery:(NSString *)query
              nextPageToken:(NSString *)nextPageToken
              numberOfItems:(NSUInteger)numberOfItems
               storeResults:(NSMutableArray<APYoutubeVideoObject *> *)results
                   onFinish:(void(^)(void))finish {
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
    
    void(^handleVideos)(NSArray *, NSDictionary *) = ^(NSArray *videos, NSDictionary *result) {
        if ([videos count] == 0) {
            finish();
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
        finish();
    };
    
    
    [self performRequestWithPath:@"/youtube/v3/search"
                          params:params
                        onFinish:^(NSDictionary *result) {
                            [self getInformationAboutVideos:result[@"items"]
                                                   onFinish:^(NSArray<APYoutubeVideoObject *> *videos) {
                                                        handleVideos(videos, result);
                                                   }];
                        }];
}

@end

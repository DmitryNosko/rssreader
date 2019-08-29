//
//  RSSParser.h
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

@interface RSSParser : NSXMLParser
@property (copy, nonatomic) void(^feedItemDownloadedHandler)(FeedItem* item);
@property (copy, nonatomic) void(^documentDownloadedHandler)(NSString* string);
- (instancetype)initWithURL:(NSURL*) url;
@end

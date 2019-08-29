//
//  FeedItem.h
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedItem : NSObject
@property (strong, nonatomic) NSString* itemTitle;
@property (strong, nonatomic) NSString* link;
@property (strong, nonatomic) NSString* pubDate;
@property (strong, nonatomic) NSMutableString* itemDescription;
@property (strong, nonatomic) NSString* enclosure;
@property (strong, nonatomic) NSString* imageURL;
@end

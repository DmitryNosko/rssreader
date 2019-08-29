//
//  FeedItem.m
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemDescription = [[NSMutableString alloc] init];
    }
    return self;
}

@end

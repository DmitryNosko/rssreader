//
//  RSSParser.m
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "RSSParser.h"

@interface RSSParser () <NSXMLParserDelegate>
@property (strong, nonatomic) NSString* element;
@property (strong, nonatomic) FeedItem* feedItem;
@property (strong, nonatomic) NSXMLParser* parser;
@end

static NSString* PATTERN_FOR_VALIDATION = @"<\/?[A-Za-z]+[^>]*>";

@implementation RSSParser

- (instancetype)initWithURL:(NSURL*) url
{
    self = [super init];
    if (self) {
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [_parser setDelegate:self];
        [_parser setShouldResolveExternalEntities:NO];
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    self.element = elementName;
    if ([self.element isEqualToString:@"rss"]) {
        self.feedItem = [[FeedItem alloc] init];
    }
    if ([self.element isEqualToString:@"item"]) {
        self.feedItem = [[FeedItem alloc] init];
    } else if ([self.element isEqualToString:@"enclosure"]) {
        self.feedItem.imageURL = [attributeDict objectForKey:@"url"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        if (self.feedItem != nil) {
            self.feedItemDownloadedHandler(self.feedItem);
        }
        self.feedItem = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![trimmed isEqualToString:@"\n"]) {
        if ([self.element isEqualToString:@"title"]) {
            self.feedItem.itemTitle = string;
        } else if ([self.element isEqualToString:@"link"]) {
            self.feedItem.link = string;
        } else if ([self.element isEqualToString:@"pubDate"]) {
            self.feedItem.pubDate = string;
        } else if ([self.element isEqualToString:@"description"]) {
            [self.feedItem.itemDescription appendString:string];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.documentDownloadedHandler(@"success");
}

@end

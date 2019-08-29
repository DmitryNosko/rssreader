//
//  MainViewController.m
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewController.h"
#import "MainTableViewCell.h"
#import "DetailsViewController.h"
#import "FeedItem.h"
#import "RSSParser.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, MainTableViewCellListener>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray<FeedItem *>* feeds;
@property (strong, nonatomic) NSString* element;
@property (strong, nonatomic) NSString* currentLink;
@property (strong, nonatomic) NSFileManager* fileManager;
@property (strong, nonatomic) NSString* data;

@property (strong, nonatomic) RSSParser* rssParser;
@property (strong, nonatomic) FeedItem* feedItem;
@end

static NSString* CELL_IDENTIFIER = @"Cell";
static NSString* URL_TO_PARSE = @"https://news.tut.by/rss/index.rss";
//static NSString* URL_TO_PARSE = @"https://developer.apple.com/news/rss/news.rss";
static NSString* PATTERN_FOR_VALIDATION = @"<\/?[A-Za-z]+[^>]*>";

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RSS Reader";
    [self tableViewSetUp];
    self.feeds = [[NSMutableArray alloc] init];
    
    NSURL* url = [NSURL URLWithString:URL_TO_PARSE];
    self.rssParser = [[RSSParser alloc] initWithURL:url];
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    NSThread* thread = [[NSThread alloc] initWithBlock:^{
        [self.rssParser parse];
    }];
    [thread start];
    
    __weak MainViewController* weakSelf = self;
    self.rssParser.feedItemDownloadedHandler = ^(FeedItem *item) {
        [weakSelf.feeds addObject:item];
        [weakSelf.tableView reloadData];
    };
    
    self.rssParser.documentDownloadedHandler = ^(NSString *string) {
        [weakSelf.tableView reloadData];
    };
    
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewFeed)];
    self.navigationItem.rightBarButtonItem = addItem;
}

#pragma mark - FeedItem

- (void) addNewFeed {
    UIAlertController* addFeedAlert = [UIAlertController alertControllerWithTitle:@"Add new feed"
                                                                          message:@"Enter feed name and URL"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    [addFeedAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Feed name";
    }];
    [addFeedAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Feed URL";
    }];
    
    [addFeedAlert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel handler:nil]];
    [addFeedAlert addAction:[UIAlertAction actionWithTitle:@"Save"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                         NSArray<UITextField*>* textField = addFeedAlert.textFields;
                                                         UITextField* feedTextField = [textField firstObject];
                                                         UITextField* urlTextField = [textField lastObject];
                                                         
                                                         if (![feedTextField.text isEqualToString:@""] && ![urlTextField.text isEqualToString:@""]) {
                                                             NSString* inputString = urlTextField.text;
                                                             
                                                             NSThread* thread = [[NSThread alloc] initWithBlock:^{
 //                                                                self.parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:inputString]];
 //                                                                [self.feeds removeAllObjects];
//                                                                 [self.parser setDelegate:self];
 //                                                                [self.parser setShouldResolveExternalEntities:NO];
  //                                                               [self.parser parse];
                                                             }];
                                                             [thread start];
                                                         }
                                                     }]];
    
    [self.navigationController presentViewController:addFeedAlert animated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.listener = self;
    cell.titleLabel.text = [self.feeds objectAtIndex:indexPath.row].itemTitle;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebViewController* dvc = [[WebViewController alloc] init];
    NSString* string = [self.feeds objectAtIndex:indexPath.row].link;
    NSString *stringForURL = [string substringWithRange:NSMakeRange(0, [string length]-6)];
    NSURL* url = [NSURL URLWithString:stringForURL];
    dvc.newsURL = url;
    [self.navigationController pushViewController:dvc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

//#pragma mark - NSXMLParserDelegate
//
//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
//
//    self.element = elementName;
//    if ([self.element isEqualToString:@"rss"]) {
//        self.feedItem = [[FeedItem alloc] init];
//    }
//    if ([self.element isEqualToString:@"item"]) {
//        self.feedItem = [[FeedItem alloc] init];
//    } else if ([self.element isEqualToString:@"enclosure"]) {
//        self.feedItem.imageURL = [attributeDict objectForKey:@"url"];
//    }
//}
//
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//
//    if ([elementName isEqualToString:@"item"]) {
//        [self.feeds addObject:self.feedItem];
//    }
//}
//
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (![trimmed isEqualToString:@"\n"]) {
//        if ([self.element isEqualToString:@"title"]) {
//            self.feedItem.itemTitle = string;
//        } else if ([self.element isEqualToString:@"link"]) {
//            self.feedItem.link = string;
//        } else if ([self.element isEqualToString:@"pubDate"]) {
//            self.feedItem.pubDate = string;
//        } else if ([self.element isEqualToString:@"description"]) {
//            [self.feedItem.itemDescription appendString:string];
//        }
//    }
//}
//
//- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    [self performSelectorOnMainThread:@selector(executeReloadingData) withObject:nil waitUntilDone:NO];
//}
//
//- (void) executeReloadingData {
//    UIApplication* app = [UIApplication sharedApplication];
//    app.networkActivityIndicatorVisible = NO;
//    [self.tableView reloadData];
//}
//
- (NSString*) correctDescription:(NSString *) string { // vinesti v const rex
    NSRegularExpression* regularExpression = [NSRegularExpression regularExpressionWithPattern:PATTERN_FOR_VALIDATION
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    string = [regularExpression stringByReplacingMatchesInString:string
                                                         options:0
                                                           range:NSMakeRange(0, [string length])
                                                    withTemplate:@""];
    return string;
}

- (BOOL) hasRSSLink:(NSString*) link {
    return [[link substringWithRange:NSMakeRange(link.length - 4, 4)] isEqualToString:@".rss"];
}

#pragma mark - MainTableViewCellListener

- (void)didTapOnInfoButton:(MainTableViewCell *)infoButton {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:infoButton];
    FeedItem* item = [self.feeds objectAtIndex:indexPath.row];
    
    DetailsViewController* dvc = [[DetailsViewController alloc] init];
    dvc.itemTitleString = item.itemTitle;
    dvc.itemDateString = item.pubDate;
    dvc.itemURLString = item.imageURL;
    dvc.itemDescriptionString = [self correctDescription:item.itemDescription];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - TableViewSetUp

- (void) tableViewSetUp {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
}

#pragma mark - Shake gesture

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSThread* thread = [[NSThread alloc] initWithBlock:^{
        [self.rssParser parse];
    }];
    [thread start];
    
}

@end

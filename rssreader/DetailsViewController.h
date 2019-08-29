//
//  DetailsViewController.h
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) NSString* itemTitleString;
@property (strong, nonatomic) NSString* itemDescriptionString;
@property (strong, nonatomic) NSString* itemURLString;
@property (strong, nonatomic) NSString* itemDateString;

@end

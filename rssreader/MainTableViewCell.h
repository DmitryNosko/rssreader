//
//  MainTableViewCell.h
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTableViewCell;

@protocol MainTableViewCellListener <NSObject>
- (void) didTapOnInfoButton:(MainTableViewCell*) infoButton;
- (void) didTapOnInfoDescriptionButton:(MainTableViewCell*) descriptionButton;
@end

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) id<MainTableViewCellListener> listener;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIButton* infoButton;
@property (strong, nonatomic) UIButton* descriptionButton;
@property (strong, nonatomic) UILabel* stateLabel;
@property (assign, nonatomic) BOOL isNew;
@end


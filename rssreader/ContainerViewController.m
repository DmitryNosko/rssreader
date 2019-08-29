//
//  ContainerViewController.m
//  rssreader
//
//  Created by USER on 8/29/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "ContainerViewController.h"
#import "MainViewController.h"
#import "MenuViewController.h"

@interface ContainerViewController ()
@property (strong, nonatomic) UIViewController* controller;
@property (strong, nonatomic) UIViewController* menuViewController;
@property (assign, nonatomic) BOOL isMove;
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStyleDone target:self action:@selector(addNewFeed)];
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewFeed)];
    self.navigationItem.leftBarButtonItem = addItem;
    self.isMove = false;
    [self configurateMainViewController];
}

- (void) configurateMainViewController {
    MainViewController* mvc = [[MainViewController alloc] init];
    self.controller = mvc;
    
    [self.view addSubview:self.controller.view];
    [self addChildViewController:self.controller];
}

- (void) configurateMenuViewController {
    if (self.menuViewController == nil) {
        self.menuViewController = [[MenuViewController alloc] init];
        [self.view insertSubview:self.menuViewController.view atIndex:0];
        [self addChildViewController:self.menuViewController];
        NSLog(@"addeddddd");
    }
}

- (void) showMenuViewController:(BOOL) shouldMove {
    if (shouldMove) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.controller.view.frame = CGRectMake(self.controller.view.frame.origin.x, self.controller.view.frame.origin.y, self.controller.view.frame.size.width - 140, self.controller.view.frame.size.height);
                         } completion:^(BOOL finished) {
                             
                         }];
    } else {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.controller.view.frame = CGRectMake(self.controller.view.frame.origin.x, self.controller.view.frame.origin.y, self.controller.view.frame.size.width + 140, self.controller.view.frame.size.height);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void) addNewFeed {
    [self configurateMenuViewController];
    self.isMove = !self.isMove;
    [self showMenuViewController:self.isMove];
}

@end


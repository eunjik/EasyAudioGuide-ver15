//
//  KSERootViewController.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 15..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSEContainer.h"
#import <QuartzCore/QuartzCore.h>


@interface KSERootViewController : UIViewController <UIPageViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
//@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) NSMutableArray *containerArray;
@property NSTimer *timer;
@property (strong, nonatomic) UITableViewController *tableViewController;
@property (strong, nonatomic) UITableView *tableView;

//- (IBAction)startButtonClick:(id)sender;

@end

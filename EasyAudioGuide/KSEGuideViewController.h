//
//  KSEGuideViewController.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 22..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSEGuide.h"
#import "MBProgressHUD.h"

@interface KSEGuideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, UIAlertViewDelegate>{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UITableView *guideTableView;
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) NSMutableArray *guideArray;
@property (strong, nonatomic) KSEContainer *selectedContainer;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSArray *infoArray;

@property (strong, nonatomic) IBOutlet UILabel *guideTitle;
@property (strong, nonatomic) IBOutlet UITextView *introView;

@property (strong, nonatomic) IBOutlet UIButton *introButton;
@property (strong, nonatomic) IBOutlet UIButton *guideButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic) IBOutlet UIImageView *introBar;
@property (strong, nonatomic) IBOutlet UIImageView *guidesBar;
@property (strong, nonatomic) IBOutlet UIImageView *infoBar;

@property (strong, nonatomic) IBOutlet UILabel *introLabel;
@property (strong, nonatomic) IBOutlet UILabel *guidesLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;


@property (strong, nonatomic) IBOutlet UILabel *containerName;
@property (strong, nonatomic) IBOutlet UILabel *containerProvider;
@property (strong, nonatomic) IBOutlet UIButton *guidePopup;


@property int GuideCount;
@property NSTimer *timer;
@property NSInteger guideButtonClicked;
@property UIActivityIndicatorView *spinner;
@property int alertFlag;


- (IBAction)introButtonClick:(id)sender;
- (IBAction)guideButtonClick:(id)sender;
- (IBAction)infoButtonClick:(id)sender;

- (IBAction)guidePopupClick:(id)sender;

@end

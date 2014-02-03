//
//  KSEGuideViewController.m
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 22..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import "KSEGuideViewController.h"
//#import "UIImageView+Network.h"
#import <Parse/Parse.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "KSEPlayViewController.h"
#import "CustomIOS7AlertView.h"


@interface KSEGuideViewController ()

@end

@implementation KSEGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar_black_new.png"] forBarMetrics:UIBarMetricsDefault];

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    self.alertFlag = 0;
    
    self.selectedContainer = [[KSEContainer alloc] init];
    self.selectedContainer.name = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerName"];
    self.selectedContainer.addr = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerAddr"];
    self.selectedContainer.phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerPhone"];
    self.selectedContainer.website = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerWebsite"];
    self.selectedContainer.objectId = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerId"];
    self.selectedContainer.contentProvider = [[NSUserDefaults standardUserDefaults]
                                              objectForKey:@"selectedContainerContentProvider"];
    self.selectedContainer.radiusForLock = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectecContainerRadiusForLock"];
    
    self.containerName.text = self.selectedContainer.name;
    self.containerProvider.text = self.selectedContainer.contentProvider;
    
  /*  UIImage *temp = [[UIImage imageNamed:@"Info_gray.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:temp style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar_black_new.png"] forBarMetrics:UIBarMetricsDefault];
    
    CGRect frame = CGRectMake(100, 0, 50, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:(222/255.0) green:(222/255.0) blue:(222/255.0) alpha:1];
    //label.text = @"Guide";
    label.text = self.selectedContainer.name;
    
    self.navigationItem.titleView = label;
    [self.navigationController.navigationBar addSubview:label];
    [self.navigationController.navigationBar bringSubviewToFront:label];
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    /*self.navigationItem.title = @"Guide";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(222/255.0) green:(222/255.0) blue:(222/255.0) alpha:1];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIFont boldSystemFontOfSize:21.0], UITextAttributeFont, nil]];
    */
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1){
        UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 32.0f, 32.0f)];
        UIImage *backImage = [UIImage imageNamed:@"Back_lightgray.png"];
        //UIImage *backImage = [[UIImage imageNamed:@"Back_lightgray.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0f, 0, 12.0f)];
        [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
        //[backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
        //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
       /* UIImage *backButtonImage = [UIImage imageNamed:@"Back_lightgray.png"];
        
        UIImage *barBackBtnImg = [backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonImage.size.width, 0, 0)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        */
    }
    else{
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Back_lightgray.png"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Back_lightgray.png"]];
    }
    
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, backButtonImage.size.width) forBarMetrics:UIBarMetricsDefault];
    
    //self.navigationController.navigationItem.leftBarButtonItem.tintColor = [UIColor darkGrayColor];
    self.GuideCount = -1;
    
    //[[UIBarButtonItem appearance] setTintColor: [UIColor colorWithRed:0/255.0 green:41/255.0 blue:64/255.0 alpha:1.0]];
    
   /* self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar.png"] forBarMetrics:UIBarMetricsDefault];
*/
    
  /*  UIImage *backButtonImage = [UIImage imageNamed:@"Back_lightgray.png"];
    UIImage *barBackBtnImg = [backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonImage.size.width, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, backButtonImage.size.width) forBarMetrics:UIBarMetricsDefault];
    */
    
   /* UIImage *temp = [[UIImage imageNamed:@"Back_lightgray.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:temp style:UIBarButtonItemStyleBordered target:self action:@selector(action)];
    UIImage *barBackBtnImg = [temp resizableImageWithCapInsets:UIEdgeInsetsMake(0, temp.size.width, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, temp.size.width) forBarMetrics:UIBarMetricsDefault];
    */
    
    
    self.guideButtonClicked = 1;
    
    self.introView.hidden = NO;
    self.guideTableView.hidden = YES;
    self.infoTableView.hidden = YES;
    
    self.introBar.hidden = YES;
    self.guidesBar.hidden = NO;
    self.infoBar.hidden = YES;
    
    self.introLabel.textColor = [UIColor whiteColor];
    self.guidesLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:1];
    self.infoLabel.textColor = [UIColor whiteColor];
    
    [self.introButton setImage:[UIImage imageNamed:@"Intro_gray_iphone.png"] forState:UIControlStateNormal];
    [self.guideButton setImage:[UIImage imageNamed:@"Guides_color_iphone.png"] forState:UIControlStateNormal];
    [self.infoButton setImage:[UIImage imageNamed:@"Info_gray_iphone.png"] forState:UIControlStateNormal];
    
    self.introView.editable = NO;
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSData *archivedObject = [defaults objectForKey:@"selectedContainer"];
    //self.selectedContainer = (KSEContainer *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
    
    if (self.selectedContainer.contentProvider != nil)
          self.selectedContainer.contentProvider = [[NSString alloc] initWithFormat:@"제공 :: %@",self.selectedContainer.contentProvider];
    
    self.introView.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerIntro"];
    
    NSString* imageurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerImage"];
    
    
    [self.imageView setImageWithURL:[NSURL URLWithString:imageurl]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    
    self.infoArray = [[NSArray alloc] initWithObjects:
                      self.selectedContainer.name,
                      self.selectedContainer.addr,
                      self.selectedContainer.phone,
                      self.selectedContainer.website,
                      self.selectedContainer.contentProvider,
                      nil];
    
    
    [self.guideTitle setText:@""];
    //[self.guideTitle setFont:[UIFont fontWithName:@"SeoulHangangM" size:17]];
    
  
    [self.guideTableView setSeparatorColor:[UIColor grayColor]];
    [self.infoTableView setSeparatorColor:[UIColor grayColor]];
    
    self.guideTableView.backgroundColor = [UIColor clearColor];
    self.infoTableView.backgroundColor = [UIColor clearColor];
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = @"Loading";
    HUD.delegate = self;
    [HUD show:YES];
    
    [self parseStart:nil];

    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(effect) userInfo:nil repeats:YES];
    
    [super viewDidLoad];
    
    

}




- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
    
}

- (void) effect
{
    [self.guideTableView reloadData];
    if (self.guideArray.count>0 || self.GuideCount==0){
        [HUD hide:YES];
        [self.spinner stopAnimating];
        //[self.guideTableView reloadData];
    }
}

- (void)parseStart:(id)sender
{
    NSString *selectedContainerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerId"];
    
    self.guideArray = [[NSMutableArray alloc] init];
    self.GuideCount = 0;
    PFQuery *guideQuery = [PFQuery queryWithClassName:@"Guide"];
    guideQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    guideQuery.maxCacheAge = 60 * 10;
    //guideQuery.maxCacheAge = 0;
    
    [guideQuery whereKey:@"parent" equalTo:[PFObject objectWithoutDataWithClassName:@"Container" objectId:selectedContainerId]];
    [guideQuery whereKey:@"isActive" equalTo:[NSNumber numberWithBool:YES]];
    [guideQuery orderByAscending:@"seq"];
    
    [guideQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            [HUD hide:YES];
            //guideQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
            //guideQuery.cachePolicy = kPFCachePolicyCacheOnly;
            //NSLog(@"!!!!!!!!!! %d",self.GuideCount);
            
        }
        if (!error){
            self.GuideCount = guideQuery.countObjects;
            //if (objects.count == 0) {
            //    guideQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
           // }
            for (int i=0; i<guideQuery.countObjects; i++){
                PFObject *obj = [objects objectAtIndex:i];
                //guideQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
                NSString *ss;
                NSString *newString;
                KSEGuide *guide = [[KSEGuide alloc] init];
                [guide setObjectId:obj.objectId];
                
                ss = [obj objectForKey:@"name"];
                newString = [ss stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [guide setName:newString];
                
                NSArray *tmp = [obj objectForKey:@"templates"];
                [guide setTemplates:tmp];
                
                ss = [obj objectForKey:@"createdAt"];
                newString = [ss stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [guide setCreatedAt:newString];
                
                ss = [obj objectForKey:@"updatedAt"];
                newString = [ss stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [guide setUpdatedAt:newString];
                
                PFFile *image_file = [obj objectForKey:@"image_file"];
                [guide setImage_file:image_file];
                
                [self.guideArray addObject:guide];
                //[self.guideTableView setUserInteractionEnabled:YES];
                
                [self effect];
            }
            //NSData *_guideArray = [NSKeyedArchiver archivedDataWithRootObject:guideArray];
            //[[NSUserDefaults standardUserDefaults] setObject:_guideArray forKey:@"guides"];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
    [alertView close];
}


- (IBAction)guidePopupClick:(id)sender{
    
    
    
    
    NSInteger *selectedContainerDistance = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectecContainerDistance"];
    
    if (self.selectedContainer.radiusForLock == NULL || selectedContainerDistance<=self.selectedContainer.radiusForLock){
        
        CustomIOS7AlertView *alertView = [CustomIOS7AlertView alertWithTitle:@"가이드 선택" message:@"오디오 가이드 언어를 선택하세요."];
        
        NSMutableArray *guides = [[NSMutableArray alloc]init];
        
        for (KSEGuide *guide in self.guideArray){
            [guides addObject:guide.name];
        }
        [guides addObject:@"취소"];
        [guides addObject:nil];
        
        [alertView setButtonTitles:guides];
        
        //[alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Shoot us a mail!", @"Try another demo!", @"Close", nil]];
        [alertView setButtonColors:[NSMutableArray arrayWithObjects:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f],[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f],nil]];
        [alertView setDelegate:self];
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
            [alertView close];
        }];
        [alertView show];
        
        /*
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"가이드 선택"
                                                      message:@"오디오가이드를 선택하세요."
                                                     delegate:self
                                            cancelButtonTitle:@"취소"
                                            otherButtonTitles:nil];
   
        for (KSEGuide *guide in self.guideArray){
            [message addButtonWithTitle:guide.name];
        
        }
        [message show];
         */
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                          message:@"해당 장소에서만 접근이 가능합니다."
                                                         delegate:self
                                                cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [message show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    KSEPlayViewController *controller = [[UIStoryboard storyboardWithName:@"Storyboard_4inch" bundle:NULL] instantiateViewControllerWithIdentifier:@"PlayViewController"];
    
    if (buttonIndex==0) NSLog(@"취소");
    for (NSInteger i=0; i<[self.guideArray count]; i++){
        KSEGuide *guide = [[KSEGuide alloc] init];
        guide = [self.guideArray objectAtIndex:i];
        if (buttonIndex == i+1){
            NSLog(@"%@",guide.name);
            self.alertFlag = i;
            
            KSEGuide *selectedGuide = [self.guideArray objectAtIndex:self.alertFlag];
            NSLog(@"%@",selectedGuide.name);
            [self.timer invalidate];
            
            [[NSUserDefaults standardUserDefaults] setObject:selectedGuide.objectId forKey:@"selectedGuideId"];
            [[NSUserDefaults standardUserDefaults] setObject:selectedGuide.templates forKey:@"selectedGuideTemplates"];
            
            
            
            [self.navigationController pushViewController:controller animated:YES];
            
            
            
        }
    }
}

- (IBAction)introButtonClick:(id)sender{
    self.introView.hidden = NO;
    self.guideTableView.hidden = YES;
    self.infoTableView.hidden = YES;
    
    self.introBar.hidden = NO;
    self.guidesBar.hidden = YES;
    self.infoBar.hidden = YES;
    
    self.introLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:1];
    self.guidesLabel.textColor = [UIColor whiteColor];
    self.infoLabel.textColor = [UIColor whiteColor];
    
    [self.introButton setImage:[UIImage imageNamed:@"Intro_color_iphone.png"] forState:UIControlStateNormal];
    [self.guideButton setImage:[UIImage imageNamed:@"Guides_gray_iphone.png"] forState:UIControlStateNormal];
    [self.infoButton setImage:[UIImage imageNamed:@"Info_gray_iphone.png"] forState:UIControlStateNormal];
}

- (IBAction)guideButtonClick:(id)sender{
       self.guideButtonClicked = 1;
        [self.guideTableView setUserInteractionEnabled:YES];
        [self.guideTableView reloadData];
    self.introView.hidden = YES;
    self.guideTableView.hidden = NO;
    self.infoTableView.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"Guides_color_iphone.png"];
    [self.guideButton setImage:image forState:UIControlStateNormal];
    
    UIImage *image2 = [UIImage imageNamed:@"Info_color_iphone.png"];
    [self.infoButton setImage:image2 forState:UIControlStateNormal];
    
    self.introBar.hidden = YES;
    self.guidesBar.hidden = NO;
    self.infoBar.hidden = YES;
    
    self.introLabel.textColor = [UIColor whiteColor];
    self.guidesLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:1];
    self.infoLabel.textColor = [UIColor whiteColor];
    
    [self.introButton setImage:[UIImage imageNamed:@"Intro_gray_iphone.png"] forState:UIControlStateNormal];
    [self.guideButton setImage:[UIImage imageNamed:@"Guides_color_iphone.png"] forState:UIControlStateNormal];
    [self.infoButton setImage:[UIImage imageNamed:@"Info_gray_iphone.png"] forState:UIControlStateNormal];
}

- (IBAction)infoButtonClick:(id)sender{
    self.guideButtonClicked = 0;
    [self.infoTableView setUserInteractionEnabled:YES];
    [self.infoTableView reloadData];
    
    self.introView.hidden = YES;
    self.guideTableView.hidden = YES;
    self.infoTableView.hidden = NO;
    
    self.introBar.hidden = YES;
    self.guidesBar.hidden = YES;
    self.infoBar.hidden = NO;
    
    self.introLabel.textColor = [UIColor whiteColor];
    self.guidesLabel.textColor = [UIColor whiteColor];
    self.infoLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:1];
    
    
    [self.introButton setImage:[UIImage imageNamed:@"Intro_gray_iphone.png"] forState:UIControlStateNormal];
    [self.guideButton setImage:[UIImage imageNamed:@"Guides_gray_iphone.png"] forState:UIControlStateNormal];
    [self.infoButton setImage:[UIImage imageNamed:@"Info_color_iphone.png"] forState:UIControlStateNormal];
}


- (void)prefetch:(NSString *)guideId
{
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    itemQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    itemQuery.maxCacheAge = 60 * 10;
    [itemQuery whereKey:@"parent" equalTo:[PFObject objectWithoutDataWithClassName:@"Guide" objectId:guideId]];
    [itemQuery orderByAscending:@"seq"];
    
    
    
    /*[itemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            itemQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
            
        }
        if (!error){
            for (int i=0; i<itemQuery.countObjects; i++){
                PFObject *obj = [objects objectAtIndex:i];
            }
        }
    }];*/
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.guideButtonClicked == 1){
        if (self.GuideCount==0)
            return 1;
        else
            return [self.guideArray count];
    }
    else
        return [self.infoArray count]-1;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
            [self.timer invalidate];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.guideButtonClicked==1){
        static NSString *CellIdentifier = @"GuideCell";
        
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:1];
        bgColorView.layer.masksToBounds = YES;
        [cell setSelectedBackgroundView:bgColorView];
        
        
        if (self.GuideCount==0){
            if (indexPath.row==0) label.text = @"오디오가이드 준비 중입니다.";
            self.guideTableView.allowsSelection = NO;
        }
        else{
            self.guideTableView.allowsSelection = YES;
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:0.4];
            bgColorView.layer.masksToBounds = YES;
            [cell setSelectedBackgroundView:bgColorView];
        
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            KSEGuide *guide = [[KSEGuide alloc] init];
            guide = [self.guideArray objectAtIndex:indexPath.row];
    
            [self prefetch:guide.objectId];
            
            label.text = [[NSString alloc] initWithFormat:@"%@", guide.name];
            
            UIImageView *image_file = (UIImageView *)[cell viewWithTag:2];
            NSString* imageurl = guide.image_file.url;
            imageurl = [imageurl stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                            withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
            
            if (imageurl != nil){
                [image_file setImageWithURL:[NSURL URLWithString:imageurl]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
            }
            else{
                [label setFrame:CGRectMake(60, 0, 200, 60)];
                //[image_file setImageWithURL:[NSURL URLWithString:imageurl]
                //           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }
            
            /*
            image_file.image = [UIImage imageNamed:@"placeholder.png"];
            if (imageurl != nil){
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        image_file.image = image;
                    });
                });
            }
            else{
                image_file.image = nil;
                
            }
            */
        }
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    }
    else{
        static NSString *CellIdentifier = @"InfoCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = [[NSString alloc] initWithFormat:@"%@", [self.infoArray objectAtIndex:indexPath.row+1]];
        //[label setFont:[UIFont fontWithName:@"SeoulHangangM" size:17]];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:0.4];
        bgColorView.layer.masksToBounds = YES;
        [cell setSelectedBackgroundView:bgColorView];
        
        
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.guideButtonClicked==0){
        if (indexPath.row==1){
            [self callWithWebView:self.selectedContainer.phone];
            //[self callWithWebView2];
        }
        if (indexPath.row==2){
            //[self urlWebView:self.selectedContainer.website];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.selectedContainer.website]];
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) callWithWebView:(NSString *)phoneNumber
{
    NSString *tel = [[NSString alloc] initWithString:self.selectedContainer.phone];
    tel = [tel stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    tel = [tel stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSURL *url = [NSURL URLWithString:[@"tel://" stringByAppendingString:tel]];
    UIWebView *callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview: callWebview];
    
}

- (void) urlWebView:(NSString *)weburl
{
    UIViewController *webViewController = [[UIViewController alloc] init];
    
    NSURL *url = [NSURL URLWithString:weburl];
    UIWebView *uiWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 504)];
                              
    [uiWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [webViewController.view addSubview:uiWebView];
    
    
    [self.navigationController pushViewController:webViewController animated:YES];
    //[[self.navigationController.viewControllers objectAtIndex:0] setTitle:@"web View"];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //self.selectedTeam;
    NSLog(@"alertFlag = %d",self.alertFlag);
    
    if (self.alertFlag == 0){
        NSIndexPath *indexPath = [[NSIndexPath alloc]init];
        indexPath = [self.guideTableView indexPathForSelectedRow];
        KSEGuide *selectedGuide = [self.guideArray objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGuide.objectId forKey:@"selectedGuideId"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGuide.templates forKey:@"selectedGuideTemplates"];
    }
    else{
        KSEGuide *selectedGuide = [self.guideArray objectAtIndex:self.alertFlag];
        NSLog(@"%@",selectedGuide.name);
        
        [[NSUserDefaults standardUserDefaults] setObject:selectedGuide.objectId forKey:@"selectedGuideId"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedGuide.templates forKey:@"selectedGuideTemplates"];
        
    }
    
    
}

@end

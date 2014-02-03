//
//  KSEItemViewController.m
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 23..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import "KSEItemViewController.h"
#import "KSEItem.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "KSELiveTVController.h"

@interface KSEItemViewController ()

@end

@implementation MapAnnotation
@synthesize coordinate;


- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)c
{
    self.title = name;
    coordinate = c;
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D) c{
    coordinate = c;
    return self;
}

- (void)mapSetting
{
    
}

@end


@implementation KSEItemViewController
//@synthesize audioPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.mapview.showsUserLocation = TRUE;
    
    /*UIButton *button1 = [[UIButton alloc] init];
     button1.frame = CGRectMake(0, 0, 30, 30);
     [button1 setBackgroundImage:[UIImage imageNamed:@"item2.png"] forState:UIControlStateNormal];
     
     [button1 addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];*/
}

- (void)viewDidAppear:(BOOL)animated
{
    
    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = @"Audio";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar_black_new.png"] forBarMetrics:UIBarMetricsDefault];

    
    self.mapview.showsUserLocation = TRUE;
    self.infoTextView.editable = NO;
    self.infoTextView.backgroundColor = [UIColor clearColor];
    
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D center;
    center.latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerLatitude"] doubleValue];
    center.longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedContainerLongitude"] doubleValue];
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    region.span = span;
    region.center = center;
    
    //*************************  지도에 핀 꼽기   **************************//
    /*if (addAnnotation != nil){
     [self.mapview removeAnnotation:addAnnotation];
     addAnnotation = nil;
     }
     addAnnotation = [[MapAnnotation alloc] initWithCoordinate:center];
     
     
     [self.mapview addAnnotation:addAnnotation];*/
    [self.mapview setRegion:region animated:TRUE];
    [self.mapview regionThatFits:region];
    
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    CGRect frame = CGRectMake(100, 0, 50, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:(222/255.0) green:(222/255.0) blue:(222/255.0) alpha:1];
    label.text = @"Audio";
    self.navigationItem.titleView = label;
    [self.navigationController.navigationBar addSubview:label];
    [self.navigationController.navigationBar bringSubviewToFront:label];
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1){
        UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 32.0f, 32.0f)];
        UIImage *backImage = [UIImage imageNamed:@"Back_lightgray.png"];
        //UIImage *backImage = [[UIImage imageNamed:@"Back_lightgray.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0f, 0, 12.0f)];
        [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
        //[backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
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
    
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.buttonView.backgroundColor = [UIColor blackColor];
    
    audioPlayer2 = nil;
    audioPlayerArray = [[NSMutableArray alloc] init];
    audioFileUrlArray = [[NSMutableArray alloc] init];
    
    /*AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *audioSessionError;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&audioSessionError];
    
    UInt32 mix = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(mix), &mix);
    
    UInt32 route = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    
    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    
    [audioSession setActive:YES error:&audioSessionError];
    */
    
    
    [self.infoButton setImage:[UIImage imageNamed:@"Literature_gray.png"] forState:UIControlStateNormal];
    self.infoButton.userInteractionEnabled = NO;
    
    UIImage* image3 = [UIImage imageNamed:@"CircledBorderTriangleDown_rev_color.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width*0.8, image3.size.height*0.8);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=mailbutton;
    
    
/*    UIImage *backButtonImage = [UIImage imageNamed:@"Back_lightgray.png"];
    UIImage *barBackBtnImg = [backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonImage.size.width, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, backButtonImage.size.width) forBarMetrics:UIBarMetricsDefault];
  */  
    
    
    //UIBarButtonItem *barListBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleMenu)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMenu:)];
    //self.navigationItem.rightBarButtonItem = barListBtn;
    
    
    [super viewDidLoad];
    
    
    NSIndexPath *tmpindex = [NSIndexPath indexPathForRow:0 inSection:0];
    self.checkedIndexPath = tmpindex;
    
    //self.infoTextView.hidden = YES;
    //self.infoImageView.hidden = YES;
    //self.infoBackground.hidden = YES;
    self.infoView.hidden = YES;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = @"Loading";
    HUD.delegate = self;
    [HUD show:YES];
    
    [self parseStart:nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(effect) userInfo:nil repeats:YES];
    
   self.templates = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedGuideTemplates"];
    if ([[self.templates objectAtIndex:0] isEqualToString:@"list"])
    {
        self.buttonView.hidden = YES;
        self.tableView.hidden = NO;
        self.mapview.hidden = YES;
        self.templateMode = 0;
    }
    if ([[self.templates objectAtIndex:0] isEqualToString:@"number"]){
        self.buttonView.hidden = NO;
        self.tableView.hidden = YES;
        self.mapview.hidden = YES;
        self.templateMode = 1;
    }
    if ([[self.templates objectAtIndex:0] isEqualToString:@"gps"]){
        self.buttonView.hidden = YES;
        self.tableView.hidden = YES;
        self.mapview.hidden = NO;
        self.templateMode = 2;
    }
    [self reMenuSetting];
    
    audioPlayer2 = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    self.audioSlider.value = 0.0;

    
    //buttons
    [self.button0 setBackgroundImage:[UIImage imageNamed:@"yellow_0.png"] forState:UIControlStateHighlighted];
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"yellow_1.png"] forState:UIControlStateHighlighted];
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"yellow_2.png"] forState:UIControlStateHighlighted];
    [self.button3 setBackgroundImage:[UIImage imageNamed:@"yellow_3.png"] forState:UIControlStateHighlighted];
    [self.button4 setBackgroundImage:[UIImage imageNamed:@"yellow_4.png"] forState:UIControlStateHighlighted];
    [self.button5 setBackgroundImage:[UIImage imageNamed:@"yellow_5.png"] forState:UIControlStateHighlighted];
    [self.button6 setBackgroundImage:[UIImage imageNamed:@"yellow_6.png"] forState:UIControlStateHighlighted];
    [self.button7 setBackgroundImage:[UIImage imageNamed:@"yellow_7.png"] forState:UIControlStateHighlighted];
    [self.button8 setBackgroundImage:[UIImage imageNamed:@"yellow_8.png"] forState:UIControlStateHighlighted];
    [self.button9 setBackgroundImage:[UIImage imageNamed:@"yellow_9.png"] forState:UIControlStateHighlighted];
    [self.buttonplay setBackgroundImage:[UIImage imageNamed:@"yellow_play.png"] forState:UIControlStateHighlighted];
    [self.buttonc setBackgroundImage:[UIImage imageNamed:@"yellow_c.png"] forState:UIControlStateHighlighted];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[audioPlayer stop];
    [audioPlayer2 stop];
    audioPlayer2 = nil;
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [self.menu close];

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) effect
{
    [self.tableView reloadData];
    if (self.itemArray.count>0 || self.itemCount==0){
        //[HUD hide:YES];
        [self.tableView reloadData];
    }
    int a = self.itemArray.count;
    int b = self.itemCount;
    
    if (self.itemCount>0 && a==b){
        NSLog(@"!!!!!%d %d",a,b);
        [HUD hide:YES];
    }
}

- (void)parseStart:(id)sender
{
    NSString *selectedGuideId = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedGuideId"];
    if ([selectedGuideId isEqualToString:@"kw6b0Uq3Ic"]){
        self.signLanguage = 1;
    }
    else{
        self.signLanguage = 0;
    }
    
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"Item"];
    itemQuery.maxCacheAge = 60 * 60;
    
    itemQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [itemQuery whereKey:@"parent" equalTo:[PFObject objectWithoutDataWithClassName:@"Guide" objectId:selectedGuideId]];
    [itemQuery orderByAscending:@"seq"];
    
    
    self.itemArray = [[NSMutableArray alloc] init];
    
    [itemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            //itemQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
            [HUD hide:YES];
        }
        if (!error){
            self.itemCount = itemQuery.countObjects;
            
            for (int i=0; i<itemQuery.countObjects; i++){
                PFObject *obj = [objects objectAtIndex:i];
                
                KSEItem *item = [[KSEItem alloc] init];
                [item setObjectId:obj.objectId];
                
                item.name = [obj objectForKey:@"name"];
                
                PFFile *audiofile = [obj objectForKey:@"audio_file"];
                //item.audio_file = audiofile.url;
                NSString *urlstr = audiofile.url;
                urlstr = [urlstr stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                                           withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
                
                [item setAudio_file:urlstr];
                
                if (self.signLanguage==0 && [audioThread isFinished]){
                    //NSThread *myThread = [[NSThread alloc] initWithTarget:self selector:@selector(audioPrepare:) object:urlstr];
                    //[myThread start];
                    audioThread = [[NSThread alloc] initWithTarget:self selector:@selector(audioPrepare:) object:urlstr];
                    [audioThread start];
                }
                //NSString *itemNum = [[NSString alloc] initWithFormat:@"item%d",i];
                /*audioPlayer = [[AudioPlayer alloc] init];
                [audioPlayer setDataSource:[audioPlayer dataSourceFromURL:[NSURL URLWithString:urlstr]] withQueueItemId:itemNum];
                */
                
                item.description = [obj objectForKey:@"description"];
                
                item.createdAt = [obj objectForKey:@"createdAt"];
                item.updatedAt = [obj objectForKey:@"updatedAt"];
                PFGeoPoint *point = [obj objectForKey:@"gps"];
                item.number = [obj objectForKey:@"number"];
                
                item.image_file = [obj objectForKey:@"image_file"];
                
                [self.itemArray addObject:item];
                [self effect];
                
                
                
                CLLocationCoordinate2D pinLocation;
                pinLocation.latitude = point.latitude;
                pinLocation.longitude = point.longitude;
                addAnnotation = [[MapAnnotation alloc] initWithName:item.name address:@"address" coordinate:pinLocation];
                
                [self.mapview addAnnotation:addAnnotation];
                
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

- (void)toggleMenu
{
    self.infoView.hidden = YES;
    
    //[self reMenuSetting];
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self.navigationController];
}


- (void)reMenuSetting
{
    __typeof (self) __weak weakSelf = self;
    REMenuItem *listItem = [[REMenuItem alloc] initWithTitle:@"       List"
                                                    //subtitle:@"리스트 형식으로 보여줍니다."
                                                       image:[UIImage imageNamed:@"Listorder_color.png"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          //NSLog(@"Item: %@", item);
                                                          self.buttonView.hidden = YES;
                                                          self.tableView.hidden = NO;
                                                          self.mapview.hidden = YES;
                                                          self.templateMode = 0;
                                                          
                                                      }];
    
    REMenuItem *numberItem = [[REMenuItem alloc] initWithTitle:@"       Number"
                                                       //subtitle:@"번호입력 방식으로 보여줍니다."
                                                          image:[UIImage imageNamed:@"List_numbered_color.png"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             //NSLog(@"Item: %@", item);
                                                             self.buttonView.hidden = NO;
                                                             self.tableView.hidden = YES;
                                                             self.mapview.hidden = YES;
                                                             self.templateMode = 1;
                                                         }];
    
    REMenuItem *mapItem = [[REMenuItem alloc] initWithTitle:@"       Map"
                                                        //subtitle:@"지도 위에 보여줍니다."
                                                           image:[UIImage imageNamed:@"Map_color.png"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              //NSLog(@"Item: %@", item);
                                                              self.buttonView.hidden = YES;
                                                              self.tableView.hidden = YES;
                                                              self.mapview.hidden = NO;
                                                              self.templateMode = 2;
                                                          }];
    
    //mapItem.badge = @"12";
    
    listItem.tag = 0;
    numberItem.tag = 1;
    mapItem.tag = 2;
    
    int flag = 0;
    for (int i=0; i<self.templates.count; i++){
        if ([[self.templates objectAtIndex:i] isEqualToString:@"list"]) flag+=1;
        if ([[self.templates objectAtIndex:i] isEqualToString:@"number"]) flag+=10;
        if ([[self.templates objectAtIndex:i] isEqualToString:@"gps"]) flag+=100;
    }
    
    switch(flag){
        case 1:
            self.menu = [[REMenu alloc] initWithItems:@[listItem]];
            break;
        case 10:
            self.menu = [[REMenu alloc] initWithItems:@[numberItem]];
            break;
        case 11:
            self.menu = [[REMenu alloc] initWithItems:@[listItem, numberItem]];
            break;
        case 100:
            self.menu = [[REMenu alloc] initWithItems:@[mapItem]];
            break;
        case 101:
            self.menu = [[REMenu alloc] initWithItems:@[listItem, mapItem]];
            break;
        case 110:
            self.menu = [[REMenu alloc] initWithItems:@[numberItem, mapItem]];
            break;
        case 111:
            self.menu = [[REMenu alloc] initWithItems:@[listItem, numberItem, mapItem]];
            break;
    }
    
    //self.menu = [[REMenu alloc] initWithItems:@[listItem, numberItem, mapItem]];
    
    // Background view
    //
    //self.menu.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    //self.menu.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //self.menu.backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
    
    //self.menu.imageAlignment = REMenuImageAlignmentRight;
    //self.menu.closeOnSelection = NO;
    //self.menu.appearsBehindNavigationBar = NO; // Affects only iOS 7
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    self.menu.highlightedTextColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:0.4];
    
}


- (IBAction)typeButtonClick:(id)sender{
    
    //if (self.infoView.hidden == NO){
        self.infoView.hidden = YES;
    //}
    
    int templateValue=0;
    for (int i=0; i<self.templates.count; i++){
        if ([[self.templates objectAtIndex:i] isEqualToString:@"list"])
            templateValue=templateValue+1;
        if ([[self.templates objectAtIndex:i] isEqualToString:@"number"])
            templateValue=templateValue+10;
        if ([[self.templates objectAtIndex:i] isEqualToString:@"gps"])
            templateValue=templateValue+100;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]init];
    alert = [[UIAlertView alloc] initWithTitle:@"Select Type"
                                       message:@"원하는 형식을 선택하세요"
                                      delegate:self cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@"List", @"Number", @"Map", nil];
    
    [alert show];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex){
        case 0:
            break;
        case 1:
            self.buttonView.hidden = YES;
            self.tableView.hidden = NO;
            self.mapview.hidden = YES;
            self.templateMode = 0;
            break;
        case 2:
            self.buttonView.hidden = NO;
            self.tableView.hidden = YES;
            self.mapview.hidden = YES;
            self.templateMode = 1;
            break;
        case 3:
            self.buttonView.hidden = YES;
            self.tableView.hidden = YES;
            self.mapview.hidden = NO;
            self.templateMode = 2;
            break;
    }
}



-(void) AnnotationButtonClicked:(id)sender {
    NSLog(@"클릭되셔슴므..!");
    //[self.mapview.annotations indexOfObject:sender];
    //NSLog(@"%d",[self.mapview.annotations indexOfObject:sel]);
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation{
    MKPinAnnotationView *pinAnnotation = nil;
    if (annotation != mapView.userLocation) {
        static NSString *pinID = @"mapPin";
        pinAnnotation = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
        if (pinAnnotation == nil) pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
        // Set ability to show callout
        pinAnnotation.canShowCallout = YES;
        // Set up the disclosure button on the right side
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinAnnotation.rightCalloutAccessoryView = infoButton;
        [infoButton addTarget:self action:@selector(AnnotationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return pinAnnotation;
}


- (void)mapView:(MKMapView *)mapView
didAddAnnotationViews:(NSArray *)views{
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control{
    for (int i=0; i<self.itemArray.count; i++){
        KSEItem *tmp = [self.itemArray objectAtIndex:i];
        if ([tmp.name isEqualToString:[view.annotation title]]){
            self.selectedRow = i;
            self.playLabel.text = tmp.name;
            self.infoTextView.text = tmp.description;
            
            NSString* imageurl = tmp.image_file.url;
            imageurl = [imageurl stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                        withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
            
           
            //self.infoImageView.image = [UIImage imageNamed:@"placeholder.png"];
            if (imageurl != nil){
                [self.infoImageView setImageWithURL:[NSURL URLWithString:imageurl]
                                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                if ([tmp.description length]==0){
                    self.infoTextView.hidden = YES;
                }
            }
            else{
                self.infoImageView.image = nil;
                //[self.infoTextView setFrame:CGRectMake(20, 20, 280, 245)];
            }
            
            
            //[self start];
            [self audioControl];
            break;
        }
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.itemArray count];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]+1 == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [self.timer invalidate];
        //[self start];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(204/255.0) blue:(0/255.0) alpha:0.4];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    
    // Configure the cell...
    KSEGuide *guide = [[KSEGuide alloc] init];
    guide = [self.itemArray objectAtIndex:indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [[NSString alloc] initWithFormat:@"%@", guide.name];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    KSEItem *tmp = [self.itemArray objectAtIndex:self.selectedRow];
    //NSLog(@"str2 %@",tmp.audio_file);
    
   
    if (self.signLanguage == 0){
        self.playLabel.text = tmp.name;
        self.infoTextView.text = tmp.description;
        NSString* imageurl = tmp.image_file.url;
        imageurl = [imageurl stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                    withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
        
        if (imageurl != nil){
            [self.infoImageView setImageWithURL:[NSURL URLWithString:imageurl]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            if ([tmp.description length]==0){
                self.infoTextView.hidden = YES;
            }
        
        }
        else{
            self.infoImageView.image = nil;
            //[self.infoTextView setFrame:CGRectMake(20, 20, 280, 245)];
        }
    
        //[self start];
        [self audioControl];
    }
    else{
        [self.timer invalidate];
        NSString *urlstr = tmp.audio_file;
        [[NSUserDefaults standardUserDefaults] setObject:urlstr forKey:@"selectedItemAudioFile"];
        //NSLog(@"str %@",urlstr);
        
        KSELiveTVController *viewController = [[KSELiveTVController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.timer invalidate];
    
    //self.selectedTeam;
    NSIndexPath *indexPath = [[NSIndexPath alloc]init];
    indexPath = [self.tableView indexPathForSelectedRow];
    KSEItem *selectedItem = [self.itemArray objectAtIndex:indexPath.row];
    NSString *urlstr = selectedItem.audio_file;
    [[NSUserDefaults standardUserDefaults] setObject:urlstr forKey:@"selectedItemAudioFile"];
    
}

- (IBAction)progressSliderMoved:(UISlider *)sender{
    //audioPlayer.currentTime = sender.value;
    //[audioPlayer setCurrentTime:sender.value];
    [audioPlayer2 setCurrentTime:sender.value];
}

/*
 - (void) play{
 
 }
 */

-(void) playButtonPressed
{
    [self audioControl];
}


-(void) sliderChanged
{
    if (!audioPlayer2)
    {
        return;
    }
    [audioPlayer2 setCurrentTime:self.audioSlider.value];
}

-(void) setupTimer
{
    self.audioSlider.maximumValue = [audioPlayer2 duration];
    self.audioSlider.value = 0.0;
    
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void) tick
{
    self.audioSlider.value = audioPlayer2.currentTime;
}

/*
- (IBAction)smallplayButtonClick:(id)sender{
    [self playButtonPressed];
}
*/

- (IBAction)playButtonClick:(id)sender{
    if (self.templateMode == 1)// number
    {
        int flag=0;
        for (int i=0; i<self.itemArray.count; i++){
            KSEItem *tmp = [self.itemArray objectAtIndex:i];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            
            if ([tmp.number isEqualToNumber:[f numberFromString:self.buttonLabel.text]]){
                self.selectedRow = i;
                self.playLabel.text = tmp.name;
                
                self.infoTextView.text = tmp.description;
                self.infoImageView.image = [UIImage imageNamed:@"placeholder.png"];
                
                NSString* imageurl = tmp.image_file.url;
                imageurl = [imageurl stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                                               withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
                
                if (imageurl != nil){
                    [self.infoImageView setImageWithURL:[NSURL URLWithString:imageurl]
                                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    if ([tmp.description length]==0){
                        self.infoTextView.hidden = YES;
                    }
                }
                else{
                    self.infoImageView.image = nil;
                    //[self.infoTextView setFrame:CGRectMake(20, 20, 280, 245)];
                }

                
                
                flag=1;
                break;
            }
        }
        if (flag==1){
            [self audioControl];
            self.buttonLabel.text = @"작품 번호";
            self.detailLabel.text = @"작품 번호를 입력해주세요";
        }
        else{
            self.playLabel.text = @"없는 번호입니다.";
        }
    }
    else{
        [self playButtonPressed];
        
    }
}

- (IBAction)infoButtonClick:(id)sender
{
    if (self.infoView.hidden == YES){
        //self.infoTextView.hidden = NO;
        //self.infoImageView.hidden = NO;
        //self.infoBackground.hidden = NO;
        self.infoView.hidden = NO;
        
    }
    else{
        //self.infoTextView.hidden = YES;
        //self.infoImageView.hidden = YES;
        //self.infoBackground.hidden = YES;
        self.infoView.hidden = YES;
        
    }
}

-(NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)string];
    CFRelease(string);
    return uuid;
}
/*
- (void)start {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    HUD.labelText = @"Connecting";
    [HUD show:YES];
    
    
    KSEItem *tmp = [self.itemArray objectAtIndex:self.selectedRow];
    NSString *urlstr = tmp.audio_file;
   
    PFObject *log = [PFObject objectWithClassName:@"Log"];
    [log setObject:@"iphone" forKey:@"deviceType"];
    [log setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                  forKey:@"deviceId"];
    
    [log setObject:[PFObject objectWithoutDataWithClassName:@"Item" objectId:tmp.objectId]
             forKey:@"item"];
    
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    [log setACL:defaultACL];
    
    [log saveInBackground];
    
    
    if (audioPlayer.state == AudioPlayerStatePlaying){
        [audioPlayer stop];
    }
    UIImage *image = [UIImage imageNamed:@"pause_color.png"];
    [self.playButton setBackgroundImage:image forState:UIControlStateNormal];
    if ([self.infoTextView.text length]==0 && [tmp.image_file.url length]==0){
        self.infoButton.userInteractionEnabled = NO;
        [self.infoButton setImage:[UIImage imageNamed:@"Literature_gray.png"] forState:UIControlStateNormal];
    }
    else{
        self.infoButton.userInteractionEnabled = YES;
        [self.infoButton setImage:[UIImage imageNamed:@"Literature_color.png"] forState:UIControlStateNormal];
    }
    
    urlstr = [urlstr stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                         withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
    
    audioPlayer = [[AudioPlayer alloc] init];
    [audioPlayer setDataSource:[audioPlayer dataSourceFromURL:[NSURL URLWithString:urlstr]] withQueueItemId:@"item1"];
    if ([self.timer isValid])[self.timer invalidate];
    self.timer = nil;
    [self setupTimer];
}


- (void)onDownloadError {
    NSLog(@"onFire downloaderror callback function");
}
*/


- (void) detailLabelSetting
{
    NSNumber *tmpn = [[NSNumber alloc] initWithInteger:self.buttonLabel.text.integerValue];
    int flag=0;
    for (int i=0; i<self.itemArray.count; i++){
        KSEItem *tmp = [self.itemArray objectAtIndex:i];
        
        if ([tmp.number isEqualToNumber:tmpn]){
            self.detailLabel.text = tmp.name;
            flag=1;
            break;
        }
    }
    if (flag==0){
        if ([self.buttonLabel.text isEqualToString:@""]){
            self.buttonLabel.text = @"작품 번호";
            self.detailLabel.text = @"작품 번호를 입력해주세요";
        }
        else
            self.detailLabel.text = @"없는 번호입니다";
    }
}

- (NSString *) buttonLabelCheck
{
    if ([self.buttonLabel.text isEqualToString:@"작품 번호"])
        return @"";
    else{
        if ([self.buttonLabel.text length]==3){
            return @"";
        }
        else
            return self.buttonLabel.text;
    }
    
}

- (IBAction)Button0Click:(id)sender
{
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"0"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
    
}
- (IBAction)Button1Click:(id)sender
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"1"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
}
- (IBAction)Button2Click:(id)sender
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"2"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
}
- (IBAction)Button3Click:(id)sender
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"3"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
}
- (IBAction)Button4Click:(id)sender
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"4"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
}
- (IBAction)Button5Click:(id)sender
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"5"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
}
- (IBAction)Button6Click:(id)sender
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"6"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
}
- (IBAction)Button7Click:(id)sender
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"7"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
}
- (IBAction)Button8Click:(id)sender
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"8"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
}
- (IBAction)Button9Click:(id)sender
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@",[self buttonLabelCheck],@"9"];
    self.buttonLabel.text = str;
    [self detailLabelSetting];
}

- (IBAction)BackButtonClick:(id)sender
{
    if ([self.buttonLabel.text isEqualToString:@"작품 번호"]){
        self.buttonLabel.text = @"작품 번호";
        self.detailLabel.text = @"작품 번호를 입력해주세요";
    }
    else{
        if (self.buttonLabel.text.length>0){
            self.buttonLabel.text = [self.buttonLabel.text substringToIndex:self.buttonLabel.text.length-1];
            [self detailLabelSetting];
        }
        else{
            self.buttonLabel.text = @"작품 번호";
            self.detailLabel.text = @"작품 번호를 입력해주세요";
        }
    }
}


////////audio
- (void)audioPrepare:(NSString*)audioUrl
{
    NSURL *fileURL = [NSURL URLWithString:audioUrl];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    AVAudioPlayer *audioPlayerTmp = [[AVAudioPlayer alloc] initWithData:data error:nil];
    [audioPlayerTmp prepareToPlay];
    
    [audioPlayerArray addObject:audioPlayerTmp];
    [audioFileUrlArray addObject:audioUrl];
    
}

- (void) configureAVAudioSession
{
    //get your app's audioSession singleton object
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    //error handling
    BOOL success;
    NSError* error;
    
    //set the audioSession category.
    //Needs to be Record or PlayAndRecord to use audioRouteOverride:
    
    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                             error:&error];
    
    if (!success)  NSLog(@"AVAudioSession error setting category:%@",error);
    
    //set the audioSession override
    success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                         error:&error];
    if (!success)  NSLog(@"AVAudioSession error overrideOutputAudioPort:%@",error);
    
    //activate the audio session
    success = [session setActive:YES error:&error];
    if (!success) NSLog(@"AVAudioSession error activating: %@",error);
    else NSLog(@"audioSession active");
    
}

- (void)audioControl
{
    KSEItem *tmp = [self.itemArray objectAtIndex:self.selectedRow];
    
    UIImage *image = [UIImage imageNamed:@"pause_color.png"];
    [self.playButton setBackgroundImage:image forState:UIControlStateNormal];
    if ([self.infoTextView.text length]==0 && [tmp.image_file.url length]==0){
        self.infoButton.userInteractionEnabled = NO;
        [self.infoButton setImage:[UIImage imageNamed:@"Literature_gray.png"] forState:UIControlStateNormal];
    }
    else{
        self.infoButton.userInteractionEnabled = YES;
        [self.infoButton setImage:[UIImage imageNamed:@"Literature_color.png"] forState:UIControlStateNormal];
    }
    
    int flag=-1;
    NSLog(@"%@",tmp.audio_file);
    for (int i=0; i<audioPlayerArray.count; i++){
        NSLog(@"%@",[audioFileUrlArray objectAtIndex:i]);
        if ([[audioFileUrlArray objectAtIndex:i]isEqualToString:tmp.audio_file]){
            flag=i;
            break;
        }
    }
    if (flag<0){
        if ([audioPlayer2 isPlaying]){
            [audioPlayer2 stop];
            audioPlayer2 = nil;
        }
        if (audioPlayer2!=nil) audioPlayer2 = nil;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        HUD.labelText = @"Connecting";
        [HUD show:YES];
        
        
        KSEItem *tmp = [self.itemArray objectAtIndex:self.selectedRow];
        NSString *urlstr = tmp.audio_file;
        
        PFObject *log = [PFObject objectWithClassName:@"Log"];
        [log setObject:@"iphone" forKey:@"deviceType"];
        [log setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                forKey:@"deviceId"];
        
        
        [log setObject:[PFObject objectWithoutDataWithClassName:@"Item" objectId:tmp.objectId]
                forKey:@"item"];
        
        PFACL *defaultACL = [PFACL ACL];
        [defaultACL setPublicReadAccess:YES];
        [defaultACL setPublicWriteAccess:YES];
        [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
        [log setACL:defaultACL];
        
        [log saveInBackground];
        
        urlstr = [urlstr stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                                   withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
        //[self configureAVAudioSession];
        //[self switchToReceiver];
        NSURL *fileURL = [NSURL URLWithString:urlstr];
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        
       /*
        NSError *setCategoryError = nil;
        BOOL success = [[AVAudioSession sharedInstance]
                        setCategory: AVAudioSessionCategoryAmbient
                        error: &setCategoryError];
        
        if (!success) { /* handle the error in setCategoryError */// }
        
     /*   UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;  // 1
        
        AudioSessionSetProperty (
                                 kAudioSessionProperty_OverrideAudioRoute,                         // 2
                                 sizeof (audioRouteOverride),                                      // 3
                                 &audioRouteOverride                                               // 4
                                 );
        
        //UInt32 route = kAudioSessionOverrideAudioRoute_Speaker;
        //AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
        
      */
      //  UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
      //  AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
      /*  UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    */
        audioPlayer2 = [[AVAudioPlayer alloc] initWithData:data error:nil];
        
        [audioPlayer2 prepareToPlay];
        [HUD hide:YES];
        [audioPlayer2 play];
        
        if ([self.timer isValid])[self.timer invalidate];
        self.timer = nil;
        [self setupTimer];
    }
    else{
        AVAudioPlayer *audioPlayerPrepared = [audioPlayerArray objectAtIndex:flag];
        
        //[audioPlayerPrepared play];
        [audioPlayer2 stop];
        //[audioPlayerPrepared playAtTime:0];
        
        audioPlayer2 = audioPlayerPrepared;
        [audioPlayer2 setCurrentTime:0.0];
        [audioPlayer2 play];
        
        if ([self.timer isValid])[self.timer invalidate];
        self.timer = nil;
        [self setupTimer];
    }
}

- (IBAction)audioControlButtonClick:(id)sender
{
    if ([audioPlayer2 isPlaying] || audioPlayer2==nil){
        [audioPlayer2 pause];
        UIImage *image = [UIImage imageNamed:@"Play_color.png"];
        [self.playButton setBackgroundImage:image forState:UIControlStateNormal];
        
    }
    else{
        [audioPlayer2 play];
        UIImage *image = [UIImage imageNamed:@"pause_color.png"];
        [self.playButton setBackgroundImage:image forState:UIControlStateNormal];
        
    }
}

@end

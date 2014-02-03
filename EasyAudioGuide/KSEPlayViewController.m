//
//  KSEPlayViewController.m
//  EasyAudioGuide
//
//  Created by 김 은지 on 14. 1. 6..
//  Copyright (c) 2014년 EunjiKim. All rights reserved.
//

#import "KSEPlayViewController.h"
#import "KSEItem.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "KSELiveTVController.h"

@interface KSEPlayViewController ()

@end

@implementation KSEPlayViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.buttonView.hidden = NO;
    [self parseStart:nil];
    
    audioPlayer2 = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    self.audioSlider.value = 0.0;

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[audioPlayer stop];
    [audioPlayer2 stop];
    audioPlayer2 = nil;
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    //[self.menu close];
    
}


- (void) effect
{
    //[self.tableView reloadData];
    if (self.itemArray.count>0 || self.itemCount==0){
        //[HUD hide:YES];
        //[self.tableView reloadData];
    }
    int a = self.itemArray.count;
    int b = self.itemCount;
    
    if (self.itemCount>0 && a==b){
        NSLog(@"!!!!!%d %d",a,b);
        //[HUD hide:YES];
    }
}

- (void)parseStart:(id)sender
{
    NSString *selectedGuideId = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedGuideId"];
    
    NSLog(@"%@",selectedGuideId);
    
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
            //[HUD hide:YES];
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
                
                /*self.infoTextView.text = item.description;
                NSString* imageurl = item.image_file.url;
                imageurl = [imageurl stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                                               withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
                
                if (imageurl != nil){
                    [self.infoImageView setImageWithURL:[NSURL URLWithString:imageurl]
                                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    if ([item.description length]==0){
                        self.infoTextView.hidden = YES;
                    }
                    
                }
                else{
                    self.infoImageView.image = nil;
                    //[self.infoTextView setFrame:CGRectMake(20, 20, 280, 245)];
                }*/
                
                [self.itemArray addObject:item];
                [self effect];
                
                
                
                CLLocationCoordinate2D pinLocation;
                pinLocation.latitude = point.latitude;
                pinLocation.longitude = point.longitude;
                //addAnnotation = [[MapAnnotation alloc] initWithName:item.name address:@"address" coordinate:pinLocation];
                
                //[self.mapview addAnnotation:addAnnotation];
                
            }
            //NSData *_guideArray = [NSKeyedArchiver archivedDataWithRootObject:guideArray];
            //[[NSUserDefaults standardUserDefaults] setObject:_guideArray forKey:@"guides"];
        }
    }];
}


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

- (IBAction)numberViewButtonClick:(id)sender{
    if (self.buttonView.hidden == YES)
        self.buttonView.hidden = NO;
    else
        self.buttonView.hidden = YES;
    
    
}


- (IBAction)currentTimeSliderTouchUpInside:(id)sender{
    [audioPlayer2 stop];
    audioPlayer2.currentTime = self.audioSlider.value;
    [audioPlayer2 prepareToPlay];
    [audioPlayer2 play];
}


- (IBAction)playButtonClick:(id)sender{
    self.templateMode = 1;
    
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
        [self audioControl];
        
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
        
        self.savedLog = [PFObject objectWithClassName:@"Log"];
        [self.savedLog setObject:@"iphone" forKey:@"deviceType"];
        [self.savedLog setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                forKey:@"deviceId"];
        [self.savedLog setObject:[PFObject objectWithoutDataWithClassName:@"Item" objectId:tmp.objectId]
                forKey:@"item"];
        NSNumber *percentage = [NSNumber numberWithDouble:self.audioSlider.value/self.audioSlider.maximumValue];
        [self.savedLog setObject:percentage forKey:@"percentage"];
        
        
        PFACL *defaultACL = [PFACL ACL];
        [defaultACL setPublicReadAccess:YES];
        [defaultACL setPublicWriteAccess:YES];
        [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
        [self.savedLog setACL:defaultACL];
        
        [self.savedLog saveInBackground];
        
        
        urlstr = [urlstr stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                                   withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
        //[self configureAVAudioSession];
        //[self switchToReceiver];
        NSURL *fileURL = [NSURL URLWithString:urlstr];
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        
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
    
    KSEItem *tmp = [self.itemArray objectAtIndex:self.selectedRow];
    NSNumber *percentage = [NSNumber numberWithDouble:self.audioSlider.value/self.audioSlider.maximumValue];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Log"];
    [query whereKey:@"deviceType" equalTo:@"iphone"];
    [query whereKey:@"deviceId" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    [query whereKey:@"item" equalTo:[PFObject objectWithoutDataWithClassName:@"Item" objectId:tmp.objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            for (PFObject *object in objects){
                NSNumber *savedPercentage = [object objectForKey:@"percentage"];
                if (percentage.floatValue-savedPercentage.floatValue>0.1){
                    object[@"percentage"] = percentage;
                }
            }
        }
    }];
    
    /*PFObject *log = [PFObject objectWithClassName:@"Log"];
    [log setObject:@"iphone" forKey:@"deviceType"];
    [log setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString]
            forKey:@"deviceId"];
    [log setObject:[PFObject objectWithoutDataWithClassName:@"Item" objectId:tmp.objectId]
            forKey:@"item"];
    NSNumber *percentage = [NSNumber numberWithDouble:self.audioSlider.value/self.audioSlider.maximumValue];
    [log setObject:percentage forKey:@"percentage"];
    
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    [log setACL:defaultACL];
    
    [log saveInBackground];
    
    self.savedLog = log;
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

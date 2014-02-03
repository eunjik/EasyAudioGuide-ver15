//
//  KSELiveTVController.m
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 9. 30..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import "KSELiveTVController.h"

@interface KSELiveTVController ()

@end

@implementation KSELiveTVController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    CGRect frame = CGRectMake(100, 0, 50, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:(222/255.0) green:(222/255.0) blue:(222/255.0) alpha:1];
    label.text = @"Video";
    self.navigationItem.titleView = label;
    [self.navigationController.navigationBar addSubview:label];
    [self.navigationController.navigationBar bringSubviewToFront:label];
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1){
        UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 32.0f, 32.0f)];
        UIImage *backImage = [UIImage imageNamed:@"Back_lightgray.png"];
        //UIImage *backImage = [[UIImage imageNamed:@"Back_lightgray.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0f, 0, 12.0f)];
        [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
        //[backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    else{
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Back_lightgray.png"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Back_lightgray.png"]];
    }

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //http://8eazshgc65.c-cdn.tcloudbiz.com
    //NSString *str = [NSString stringWithFormat:@"http://files.parse.com/dce2d900-956f-4ed6-9f1a-755a4265b329/e560aa01-495b-4852-bb48-58b0ba2a8f1b-test3_1.mp4"];
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedItemAudioFile"];
    
    str = [str stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                         withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
    
    
    NSURL *url = [NSURL URLWithString:str];
    NSLog(@"%@",str);
    player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [player.view setFrame:CGRectMake(0, 0, 320, 400)];
    [self.view addSubview:player.view];
    [player prepareToPlay];
    [player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  KSEItemViewController.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 23..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import "KNURLDownloader.h"
#import "KSEItem.h"
#import "AudioPlayer.h"
#import "MBProgressHUD.h"
#import "REMenu.h"



@interface MapAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *cTitle;
    NSString *cSubTitle;
}

@property (nonatomic, retain) NSString *title;
@end

@interface KSEItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, MBProgressHUDDelegate>{
    MapAnnotation *addAnnotation;
    MBProgressHUD *HUD;
    
    AVAudioPlayer *audioPlayer2;
    NSMutableArray *audioPlayerArray;
    NSMutableArray *audioFileUrlArray;
    NSThread *audioThread;
}
@property (strong, nonatomic) REMenu *menu;
- (void)toggleMenu;
- (void)reMenuSetting;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UILabel *buttonLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (strong, nonatomic) IBOutlet UIImageView *infoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *infoBackground;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic) NSMutableArray *itemArray;
@property NSTimer *timer;
@property NSInteger *signLanguage;
@property NSInteger *itemCount;

@property (strong, nonatomic) NSMutableArray *description;
@property (strong, nonatomic) NSMutableArray *audio_url;
@property NSInteger selectedRow;
@property (strong, nonatomic) IBOutlet UILabel *playLabel;
@property (strong, nonatomic) IBOutlet UISlider *audioSlider;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) NSArray *templates;
@property NSInteger templateMode; // list:0 number:1 gps:2
@property (nonatomic, retain) NSIndexPath *checkedIndexPath;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;


@property (strong, nonatomic) IBOutlet UIButton *button0;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (strong, nonatomic) IBOutlet UIButton *button5;
@property (strong, nonatomic) IBOutlet UIButton *button6;
@property (strong, nonatomic) IBOutlet UIButton *button7;
@property (strong, nonatomic) IBOutlet UIButton *button8;
@property (strong, nonatomic) IBOutlet UIButton *button9;
@property (strong, nonatomic) IBOutlet UIButton *buttonplay;
@property (strong, nonatomic) IBOutlet UIButton *buttonc;


- (IBAction)progressSliderMoved:(UISlider *)sender;
- (IBAction)playButtonClick:(id)sender;
- (IBAction)typeButtonClick:(id)sender;
- (IBAction)infoButtonClick:(id)sender;

- (IBAction)Button0Click:(id)sender;
- (IBAction)Button1Click:(id)sender;
- (IBAction)Button2Click:(id)sender;
- (IBAction)Button3Click:(id)sender;
- (IBAction)Button4Click:(id)sender;
- (IBAction)Button5Click:(id)sender;
- (IBAction)Button6Click:(id)sender;
- (IBAction)Button7Click:(id)sender;
- (IBAction)Button8Click:(id)sender;
- (IBAction)Button9Click:(id)sender;

- (IBAction)BackButtonClick:(id)sender;
- (IBAction)smallplayButtonClick:(id)sender;


- (IBAction)audioControlButtonClick:(id)sender;

-(void) AnnotationButtonClicked:(id)sender;

//@property (readwrite, retain) AudioPlayer* audioPlayer;

@end

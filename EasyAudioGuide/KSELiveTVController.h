//
//  KSELiveTVController.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 9. 30..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface KSELiveTVController : UIViewController{
    MPMoviePlayerController *player;
}

@property (nonatomic, retain) MPMoviePlayerController *player;

@end

//
//  KSEAppDelegate.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 15..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSEContainer.h"
#import "KSEGuide.h"
#import "KSEItem.h"

@interface KSEAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

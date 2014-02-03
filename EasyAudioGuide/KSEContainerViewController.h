//
//  KSEContainerViewController.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 21..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//


#import <Parse/Parse.h>
#import "KSEContainer.h"

@interface KSEContainerViewController : PFQueryTableViewController<CLLocationManagerDelegate, UIActivityItemSource, UISearchBarDelegate>{
    NSMutableArray *copycontainerArray;
    IBOutlet UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
}

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *containerArray;
@property NSTimer *timer;
@property NSThread *myThread;
@property CLLocation *location;
@property CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) PFGeoPoint *userGeoPoint;
@property BOOL searchButtonIs;

- (IBAction)searchButtonClick:(id)sender;

- (void)imageLoaded:(NSNotification *)notification;

@end


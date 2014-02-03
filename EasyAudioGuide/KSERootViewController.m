//
//  KSERootViewController.m
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 15..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import "KSERootViewController.h"
#import <Parse/Parse.h>

@interface KSERootViewController ()
@end

@implementation KSERootViewController


- (void)viewWillAppear:(BOOL)animated
{
    //221 221 221
    //[self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.85 alpha:1.0]];
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1];
    //[[UIBarButtonItem appearance] setTintColor: [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]];
    //NSDictionary *textAttributes = [[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor, nil];
    
    //[[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self parseStart:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(effect) userInfo:nil repeats:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
}


- (void)effect
{
    [self.tableView reloadData];
    NSLog(@"!");
}

- (void)parseStart:(id)sender
{
    if ([[NSThread currentThread] isCancelled] == YES);
    
    PFQuery *containerQuery = [PFQuery queryWithClassName:@"Container"];
    
    self.containerArray = [[NSMutableArray alloc] init];
    
    [containerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (int i=0; i<containerQuery.countObjects; i++){
                KSEContainer *container = [[KSEContainer alloc] init];
                PFObject *obj = [objects objectAtIndex:i];
                [container setObjectId:obj.objectId];
                
                NSString *ss;
                NSString *newString;
                ss = [obj objectForKey:@"addr"];
                newString = [ss stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [container setAddr:newString];
                
                ss = [obj objectForKey:@"name"];
                newString = [ss stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [container setName:newString];
                
                PFFile *file = [obj objectForKey:@"image_file"];
                NSData *imageData = [file getData];
                UIImage *image = [UIImage imageWithData:imageData];
                [container setImage:image];
                
                ss = [obj objectForKey:@"phone"];
                newString = [ss stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [container setPhone:newString];
                
                ss = [obj objectForKey:@"website"];
                newString = [ss stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [container setWebsite:newString];
                
                ss = [obj objectForKey:@"createdAt"];
                newString = [ss stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [container setCreatedAt:newString];
                
                ss = [obj objectForKey:@"updatedAt"];
                newString = [ss stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [container setUpdatedAt:newString];
                
                PFGeoPoint *point =[obj objectForKey:@"location"];
                [container setLatitude:[NSString stringWithFormat:@"%f",point.latitude]];
                [container setLongitude:[NSString stringWithFormat:@"%f",point.longitude]];
                
                //NSLog(@"@@@@%f, %f",point.latitude,point.longitude);
                
                [self.containerArray addObject:container];
                
            }
            //[self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.containerArray count];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]+1 == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [self.timer invalidate];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContainerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    KSEContainer *container = [[KSEContainer alloc] init];
    container = [self.containerArray objectAtIndex:indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [[NSString alloc] initWithFormat:@"%@", container.name];
    
    UILabel *label2 = (UILabel *)[cell viewWithTag:3];
    //label2.text = [[NSString alloc] initWithFormat:@"%@, %@", container.latitude, container.longitude];
    double c_latitude = container.latitude.doubleValue;
    double c_longitude = container.longitude.doubleValue;
    CLLocation *tmpgeo = [[CLLocation alloc] initWithLatitude:c_latitude longitude:c_longitude];
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    CLLocation *tmpgeo2 = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    
    CLLocationDistance distance2 = [tmpgeo distanceFromLocation:tmpgeo2];
    NSInteger tt = distance2;
    label2.text = [[NSString alloc] initWithFormat:@"%dm",tt];
    
    /*
     // Create the colors
     UIColor *darkOp =
     [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0];
     UIColor *lightOp =
     [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
     
     // Create the gradient
     CAGradientLayer *gradient = [CAGradientLayer layer];
     
     // Set colors
     gradient.colors = [NSArray arrayWithObjects:
     (id)lightOp.CGColor,
     (id)darkOp.CGColor,
     nil];
     
     // Set bounds
     
     // Add the gradient to the view
     
     */
    UIImageView *image = (UIImageView *)[cell viewWithTag:2];
    /* UIView *view = (UIView *)[cell viewWithTag:3];
     gradient.frame = view.bounds;
     
     [view.layer insertSublayer:gradient atIndex:0];
     */
    [image setImage:container.image];
    /*
     UIView *blackOverlay = [[UIView alloc] initWithFrame: image.frame];
     blackOverlay.layer.backgroundColor = [[UIColor blackColor] CGColor];
     
     [self.view addSubview: blackOverlay];
     */
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //self.selectedTeam;
    NSIndexPath *indexPath = [[NSIndexPath alloc]init];
    indexPath = [self.tableView indexPathForSelectedRow];
    KSEContainer *selectedContainer = [self.containerArray objectAtIndex:indexPath.row];
    
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:selectedContainer];
    [[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:@"selectedContainer"];
    
    [[NSUserDefaults standardUserDefaults] setObject:selectedContainer.objectId forKey:@"selectedContainerId"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedContainer.name forKey:@"selectedContainerName"];
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(selectedContainer.image) forKey:@"selectedContainerImage"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedContainer.latitude forKey:@"selectedContainerLatitude"];
    [[NSUserDefaults standardUserDefaults] setObject:selectedContainer.longitude forKey:@"selectedContainerLongitude"];
    
}


@end
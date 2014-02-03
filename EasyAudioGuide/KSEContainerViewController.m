//
//  MyTableController.m
//  ParseStarterProject
//
//  Created by James Yu on 12/29/11.
//

#import "KSEContainerViewController.h"
//#import "AsyncImageView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "KSEGuide.h"

@implementation KSEContainerViewController
double distance;

- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Container";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        //self.objectsPerPage = 20;
        
        self.loadingViewEnabled = NO;
        self.isLoading = NO;
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

- (void)viewDidLoad
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar_new.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(222/255.0) green:(222/255.0) blue:(222/255.0) alpha:1];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    searching = NO;
    self.containerArray = [[NSMutableArray alloc] init];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager startUpdatingLocation];
    
    self.location = [self.locationManager location];
    self.coordinate = [self.location coordinate];
    
    self.userGeoPoint = [PFGeoPoint alloc];
    self.userGeoPoint.latitude = self.coordinate.latitude;
    self.userGeoPoint.longitude = self.coordinate.longitude;
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error){
        if (!error){
            self.userGeoPoint = geoPoint;
            self.containerArray = [[NSMutableArray alloc] init];
            
            [self loadObjects];
        }
    }];
    
    self.searchButtonIs = 0;
    /*UIImage* image3 = [UIImage imageNamed:@"Search_color.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(searchButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=mailbutton;
    */
     
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"notFirstRun"]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                          message:@"3G/4G상태에서 서비스 이용시 가입하신 요금제에 따라 데이터 통화료가 발생할 수 있습니다."
                                                         delegate:self
                                                cancelButtonTitle:@"취소"
                                                otherButtonTitles:@"확인", nil];
        
        [message show];
        
        [defaults setBool:YES forKey:@"notFirstRun"];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.loadingViewEnabled = YES;
    //self.isLoading = YES;
    //[self clear];
    //[self loadObjects];
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar_new.png"] forBarMetrics:UIBarMetricsDefault];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar_new.png"] forBarMetrics:UIBarMetricsDefault];

}

- (void)viewWillDisappear:(BOOL)animated
{
    //UIImage *_defaultImage;
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar_black_new.png"] forBarMetrics:UIBarMetricsDefault];

    //[self.navigationController.navigationBar setBackgroundImage:_defaultImage forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //self.view = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    
    // This method is called before a PFQuery is fired to get more objects
}


- (IBAction)searchButtonClick:(id)sender{

    if (self.searchButtonIs == 0){
        self.searchButtonIs = 1;
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 310, 44)];
        searchBar.backgroundImage = [[UIImage alloc] init];
        searchBar.delegate = self;
        searchBar.placeholder = @"검색어를 입력해주세요";
        
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar_2.png"] forBarMetrics:UIBarMetricsDefault];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStyleBordered target:self action:@selector(searchButtonClick:)];
        
        
        
    }
    else{
        self.searchButtonIs = 0;
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"iphone_bar.png"] forBarMetrics:UIBarMetricsDefault];
        
        UIImage* image3 = [UIImage imageNamed:@"Search_color.png"];
        CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
        UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
        [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
        [someButton addTarget:self action:@selector(searchButtonClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [someButton setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
        self.navigationItem.rightBarButtonItem=mailbutton;
    }

}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar{
    searching = YES;
    letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    
}

- (void) searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText{
    [copycontainerArray removeAllObjects];
    
    if ([searchText length]>0){
        searching = YES;
        letUserSelectRow = YES;
        self.tableView.scrollEnabled = YES;
        [self searchTableView];
    }
    else{
        searching = NO;
        letUserSelectRow = NO;
        self.tableView.scrollEnabled = NO;
    }
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [self searchTableView];
}


-(void)searchTableView
{
    NSString *searchText = searchBar.text;
    for (int i=0; i<[self.containerArray count]; i++){
        KSEContainer *tmp = [[KSEContainer alloc] init];
        tmp = [self.containerArray objectAtIndex:i];
        NSLog(@"tmp = %@",tmp.name);
        NSRange titleResultRange = [tmp.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (titleResultRange.length >0){
            [copycontainerArray addObject:tmp];
        }
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searching)
    {
        return [copycontainerArray count];
    }
    else{
        return self.objects.count;
    }
}

- (void)prefetch:(NSString *)containerId
{
    PFQuery *guideQuery = [PFQuery queryWithClassName:@"Guide"];
    guideQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    guideQuery.maxCacheAge = 60 * 60;
    
    [guideQuery whereKey:@"parent" equalTo:[PFObject objectWithoutDataWithClassName:@"Container" objectId:containerId]];
    [guideQuery whereKey:@"isActive" equalTo:[NSNumber numberWithBool:YES]];
    [guideQuery orderByAscending:@"seq"];
        
    /*[guideQuery findObjectsInBackgroundWithBlock:^(NSArray *objects2, NSError *error) {
        if (objects2.count == 0) {
           // guideQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        if (!error){
            for (int i=0; i<guideQuery.countObjects; i++){
                PFObject *obj = [objects2 objectAtIndex:i];
            }
        }
    }];*/
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"Container"];
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    query.maxCacheAge = 60 * 60;
    
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query whereKey:@"location" nearGeoPoint:self.userGeoPoint withinKilometers:40200];
    [query whereKey:@"isActive" equalTo:[NSNumber numberWithBool:YES]];
    
   /* if (searching){
        [query whereKey:@"name" equalTo:searchBar.text];
    }
    */
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return query;
}


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"ContainerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        // Here we use the new provided setImageWithURL: method to load the web image
        //[cell.imageView setImageWithURL:[NSURL URLWithString:@"http://www.domain.com/path/to/image.jpg"]
         //              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        
        //add AsyncImageView to cell
		/*AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame: cell.imageView.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.clipsToBounds = YES;
		imageView.tag = 2;
		[cell addSubview:imageView];
		[imageView release];
		*/
        
		//common settings
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		cell.indentationWidth = 44.0f;
		cell.indentationLevel = 1;
        
    }
    
   /* if (searching){
        //get image view
        UIImageView *cellImageView = (UIImageView*)[cell viewWithTag:2];
        //load the image
        KSEContainer *container = [copycontainerArray objectAtIndex:indexPath.row];
        
        PFFile *file = container.file;
        [cellImageView setImageWithURL:[NSURL URLWithString:file.url]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = container.name;
    }
    else{*/
        //get image view
        UIImageView *cellImageView = (UIImageView*)[cell viewWithTag:2];
        //load the image
        PFFile *file = [object objectForKey:@"image_file"];
        NSString *str = file.url;
        str = [str stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                         withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
    
        [cellImageView setImageWithURL:[NSURL URLWithString:str]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
        KSEContainer *container = [[KSEContainer alloc] init];
    
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = [object objectForKey:@"name"];
        
        UILabel *distanceLabel = (UILabel *)[cell.contentView viewWithTag:3];
        distance = [[object objectForKey:@"location"] distanceInKilometersTo:self.userGeoPoint];
        if (distance<1.0){
            [distanceLabel setText:[[NSString alloc] initWithFormat:@"%.0fm",distance*1000]];
        }
        else{
            [distanceLabel setText:[[NSString alloc] initWithFormat:@"%.01fkm",distance]];
        }
    
    
        container.objectId = [object objectId];
        container.name = [object objectForKey:@"name"];
        container.addr = [object objectForKey:@"addr"];
        container.phone = [object objectForKey:@"phone"];
        container.website = [object objectForKey:@"website"];
        container.file = [object objectForKey:@"image_file"];
        container.latitude = [object objectForKey:@"latitude"];
        container.longitude = [object objectForKey:@"longitude"];
        container.intro = [object objectForKey:@"intro"];
        container.contentProvider = [object objectForKey:@"contentProvider"];
        container.radiusForLock = [[object objectForKey:@"radiusForLock"] integerValue];
        
    
        [self.containerArray addObject:container];
    
        [self prefetch:container.objectId];
    //self.myThread = [[NSThread alloc] initWithTarget:self selector:@selector(prefetch:) object:container.objectId];
    //[self.myThread start];
    
    
        //[self performSelectorInBackground:@selector(prefetch:) withObject:container.objectId];
   // }
    
    return cell;
    
}


-(void)thumbImageLoadSucces:(id)sender {
    
    NSLog(@"imageloadedsucces");
    
}

-(void)thumbImageLoadError:(id)sender {
    
    NSLog(@"imageloadederror");
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //[self.myThread cancel];
    
    NSIndexPath *indexPath = [[NSIndexPath alloc]init];
    indexPath = [self.tableView indexPathForSelectedRow];
    
    //KSEContainer *container = [self.containerArray objectAtIndex:indexPath.row];
    
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    //KSEContainer *container = [self.containerArray objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:[object objectId] forKey:@"selectedContainerId"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[object objectForKey:@"name"]
        forKey:@"selectedContainerName"];
    PFFile *file = [object objectForKey:@"image_file"];
    NSString *str = file.url;
    str = [str stringByReplacingOccurrencesOfString:@"http://files.parse.com"
                                         withString:@"http://8eazshgc65.c-cdn.tcloudbiz.com"];
    
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"selectedContainerImage"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[object objectForKey:@"intro"] forKey:@"selectedContainerIntro"];
    
    PFGeoPoint *point =[object objectForKey:@"location"];
    [[NSUserDefaults standardUserDefaults] setDouble:point.latitude forKey:@"selectedContainerLatitude"];
    [[NSUserDefaults standardUserDefaults] setDouble:point.longitude
        forKey:@"selectedContainerLongitude"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[object objectForKey:@"radiusForLock"] forKey:@"selectecContainerRadiusForLock"];
    [[NSUserDefaults standardUserDefaults] setObject:[object objectForKey:@"addr"]  forKey:@"selectedContainerAddr"];
    [[NSUserDefaults standardUserDefaults] setObject:[object objectForKey:@"phone"]  forKey:@"selectedContainerPhone"];
    [[NSUserDefaults standardUserDefaults] setObject:[object objectForKey:@"website"]  forKey:@"selectedContainerWebsite"];
    [[NSUserDefaults standardUserDefaults] setObject:[object objectForKey:@"contentProvider"] forKey:@"selectedContainerContentProvider"];
   
    [[NSUserDefaults standardUserDefaults] setInteger:distance*1000 forKey:@"selectecContainerDistance"];
    
}

@end

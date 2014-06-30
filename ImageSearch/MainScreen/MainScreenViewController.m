//
//  ViewController.m
//  ImageSearch
//
//  Created by Can Leloglu on 6/26/14.
//  Copyright (c) 2014 Can Leloglu. All rights reserved.
//

#import "MainScreenViewController.h"
#import "NetworkManager.h"
#import "MainScreenCollectionViewController.h"
#import "MainScreenCollectionViewCell.h"
#import "ImageDetailView.h"
#import "ImageObject.h"
#import "NSString+Extension.h"
#import "MainScreenTableViewController.h"
#import "ActivityView.h"

@interface MainScreenViewController ()
<NetworkManagerDelegate,
MainScreenCollectionViewControllerDelegate,
MainScreenTableViewControllerDelegate,
ImageDetailViewDelegate,
UITextFieldDelegate>

// strong referenced objects
@property (strong, nonatomic) NetworkManager* networkManager;
@property (strong, nonatomic) NSMutableArray* imageObjArray;
@property (strong, nonatomic) MainScreenCollectionViewController* collectionViewController;
@property (strong, nonatomic) MainScreenTableViewController* tableViewController;
@property (strong, nonatomic) ImageDetailView* imageDetailView;
@property (strong, nonatomic) ActivityView* activityView;

@property (nonatomic) NSInteger searchIndex;

// Outlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *activityContainer;

@end

@implementation MainScreenViewController

/*
 * Called when the view is load - creates strong references objects
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchIndex = 1;
    
    // setup network manager
    self.networkManager = [[NetworkManager alloc] init];
    self.networkManager.delegate = self;
    
    self.imageObjArray = [[NSMutableArray alloc] init];
    
    self.collectionViewController = [[MainScreenCollectionViewController alloc] init];
    self.collectionViewController.delegate = self;
    self.collectionViewController.collectionView = self.collectionView;
    self.collectionView.delegate = self.collectionViewController;
    self.collectionView.dataSource = self.collectionViewController;
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    self.tableViewController = [[MainScreenTableViewController alloc] init];
    self.tableViewController.delegate = self;
    self.tableViewController.tableView = self.tableView;
    self.tableView.delegate = self.tableViewController;
    self.tableView.dataSource = self.tableViewController;
    
    self.activityView = (ActivityView*)[[[NSBundle mainBundle] loadNibNamed:@"ActivityView" owner:self options:nil] objectAtIndex:0];
    self.activityView.frame = self.activityContainer.bounds;
    [self.activityContainer addSubview:self.activityView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardIsHidden) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardIsShown) name:UIKeyboardDidShowNotification object:nil];
}

/*
 * Called when the view appears - hides past searches and stops activity animation
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tableView.hidden = YES;
    [self.activityView stopAnimating];
}

/*
 * If there was some class which creates and holds this view controller dealloc would be necessary
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    self.networkManager = nil;
    self.collectionViewController = nil;
    self.tableViewController = nil;
}

/*
 * Removes all objects from image array and cleans up collection view
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self.imageObjArray removeAllObjects];
    [self.collectionViewController cleanup];
    [self.collectionViewController reloadData];
}

/*
 * Change the height of tableview to keep it over the keyboard
 */
- (void)keyboardIsShown
{
    __weak MainScreenViewController* weakself = self;
    [UIView animateWithDuration:0.3 animations:^
    {
        CGRect frame = weakself.tableView.frame;
        weakself.tableView.frame = CGRectMake(frame.origin.x,
                                              frame.origin.y,
                                              frame.size.width,
                                              weakself.view.frame.size.height - weakself.tableView.frame.origin.y - 216);
    }];
}

/*
 * Change the height of tableview to keep it over the keyboard
 */
- (void)keyboardIsHidden
{
    __weak MainScreenViewController* weakself = self;
    [UIView animateWithDuration:0.3 animations:^
    {
        CGRect frame = weakself.tableView.frame;
        weakself.tableView.frame = CGRectMake(frame.origin.x,
                                              frame.origin.y,
                                              frame.size.width,
                                              weakself.view.frame.size.height - weakself.tableView.frame.origin.y);
    }];
}

/*
 * We should remove all objects on imageObjArray that belong to previous search assign search index to 1 to start over
 */
- (void)prepareForNewSearch
{
    [self.imageObjArray removeAllObjects]; // Cleanup current search results
    self.searchIndex = 1;
}

/*
 * Generic search function - starts the network request with the search term
 */
- (void)search
{
    // If network manager is busy - return
    if (self.networkManager.hasActiveRequest)
    {
        return;
    }
    
    // Start activity indicator - it will be stopped in network callback methods
    [self.activityView startAnimating];
    
    NSString* searchStr = [self.textField.text searchString];
    
    [self.networkManager makeReqWithString:searchStr andIndex:self.searchIndex];
    [self.textField resignFirstResponder]; // close keyboard
}

#pragma mark - actions

/*
 * Called when search button is tapped - starts a new search from index 1 - pushes the search to past array
 */
- (IBAction)onButton:(id)sender
{
    [self prepareForNewSearch];
    [self.tableViewController pushSearchToPast:self.textField.text];
    [self search];
}


#pragma mark - networkmanager delegate methods

/*
 * Called when network request is succesfuly finished
 */
- (void)requestFinished:(NSURLRequest *)req withDict:(NSDictionary *)dict
{
    // Stop activity animator and hide it
    [self.activityView stopAnimating];
    
    self.tableView.hidden = YES;
    
    // Iterate through the result dictionary and store everything in terms of ImageObject
    NSMutableArray* items = [dict objectForKey:@"items"];
    for (NSDictionary* obj in items)
    {
        NSString* thumbnail = [[obj objectForKey:@"image"] objectForKey:@"thumbnailLink"];
        NSString* link = [obj objectForKey:@"link"];
        ImageObject* imgObj = [[ImageObject alloc] init];
        imgObj.thumbnailUrlStr = thumbnail; // for collection view
        imgObj.largeImageUrlStr = link; // for image detail view
        [self.imageObjArray addObject:imgObj];
    }
    self.collectionViewController.allItems = nil; // first clean the array
    self.collectionViewController.allItems = [NSArray arrayWithArray:self.imageObjArray];
    [self.collectionViewController reloadData];
    
    self.searchIndex += searchBlock; // Start next search from index + 10 - we show results 10 by 10
    
    // The first search does not fill the screen - we should do it this way because the api fails for +10 result requests
    if ([self.collectionViewController.allItems count] == searchBlock)
    {
        [self search];
    }
}

/*
 * Called when network request fails
 */
- (void)requestFailed:(NSURLRequest *)req withReason:(NSString *)reason
{
    // Stop and hide the activity indicator
    [self.activityView stopAnimating];
    
    // Show an alert with the reason of fail
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fail"
                                                    message:reason
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - collectionviewcontroller delegate methods

/*
 * Called when user selects an image from collection view
 */
- (void)controllerDidSelect:(id)sender thumbnail:(UIImage *)thumbnail imageObj:(ImageObject *)imageObj
{
    // If there image detail view does not exist yet create one from the xib file
    if (!self.imageDetailView)
    {
        self.imageDetailView = (ImageDetailView*)[[[NSBundle mainBundle] loadNibNamed:@"ImageDetailView" owner:self options:nil] objectAtIndex:0];
    }
    self.imageDetailView.frame = self.view.bounds;
    
    // Update the image in detail view - thumbnail image is used as a placeholder until large image is donwloaded
    [self.imageDetailView updateImageViewWithPlaceHolder:thumbnail andImageObject:imageObj];
    [self.view addSubview:self.imageDetailView];
}

/*
 * Called when user scrolls down until hitting the bottom - pull the next page of results
 */
- (void)controllerHitTheBottom:(id)sender
{
    [self search];
}


#pragma mark - tableviewcontroller delegate methods

/*
 * Called when user selects an entry from past searches - starts a new search with selected string
 */
- (void)tableControllerDidSelect:(id)sender searchTerm:(NSString *)searchTerm
{
    // cleanup the current search to start a new one
    [self.imageObjArray removeAllObjects];
    
    // move the selected search to the top of the past searches list
    [self.tableViewController pushSearchToPast:searchTerm];
    
    self.tableView.hidden = YES;
    self.textField.text = searchTerm;
    [self search];
}


#pragma mark - image detail delegate functions

/*
 * Called when image detail view is closed and removed from the superview - we release it to save memory
 */
- (void)imageDetailViewDidClose:(id)sender
{
    self.imageDetailView = nil;
}


#pragma mark - uitextfield delegate methods

/*
 * Called when user enters a text to textfield and hits the go button
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // If the user taps the return button this should be a new search
    self.tableView.hidden = YES;
    [self prepareForNewSearch];
    [self search];
    return YES;
}

/*
 * Called when user taps on the text field - reveals the past searches list and reloads the data of the table view
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.tableView.hidden = NO;
    [self.tableViewController reloadData];
    return YES;
}

@end

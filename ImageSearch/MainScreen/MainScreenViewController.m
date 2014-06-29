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

@interface MainScreenViewController ()
<NetworkManagerDelegate,
MainScreenCollectionViewControllerDelegate,
ImageDetailViewDelegate,
UITextFieldDelegate>

// strong referenced objects
@property (strong, nonatomic) NetworkManager* networkManager;
@property (strong, nonatomic) NSMutableArray* imageObjArray;
@property (strong, nonatomic) MainScreenCollectionViewController* collectionViewController;
@property (strong, nonatomic) ImageDetailView* imageDetailView;

@property (nonatomic) NSInteger searchIndex;

// Outlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MainScreenViewController

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
}

- (void)dealloc
{
    self.networkManager = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self.collectionViewController cleanup];
}

- (void)search
{
    NSString* searchStr = [self.textField.text searchString];
    [self.networkManager makeReqWithString:searchStr andIndex:self.searchIndex];
    [self.textField resignFirstResponder];
}

#pragma mark - actions

- (IBAction)onButton:(id)sender
{
    [self.imageObjArray removeAllObjects];
    self.searchIndex = 1;
    [self search];
}

#pragma mark - networkmanager delegate methods

- (void)requestFinished:(NSURLRequest *)req withDict:(NSDictionary *)dict
{
    NSMutableArray* items = [dict objectForKey:@"items"];
    for (NSDictionary* obj in items)
    {
        NSString* thumbnail = [[obj objectForKey:@"image"] objectForKey:@"thumbnailLink"];
        NSString* link = [obj objectForKey:@"link"];
        ImageObject* imgObj = [[ImageObject alloc] init];
        imgObj.thumbnailUrlStr = thumbnail;
        imgObj.largeImageUrlStr = link;
        [self.imageObjArray addObject:imgObj];
    }
    self.collectionViewController.allItems = self.imageObjArray;
    [self.collectionViewController reloadData];
    
    self.searchIndex += 10;
}

- (void)requestFailed:(NSURLRequest *)req
{
    NSLog(@"failed");
}

#pragma mark - collectionviewcontroller delegate methods

- (void)controllerDidSelect:(id)sender thumbnail:(UIImage *)thumbnail imageObj:(ImageObject *)imageObj
{
    if (!self.imageDetailView)
    {
        self.imageDetailView = (ImageDetailView*)[[[NSBundle mainBundle] loadNibNamed:@"ImageDetailView" owner:self options:nil] objectAtIndex:0];
    }
    self.imageDetailView.frame = self.view.bounds;
    [self.imageDetailView updateImageViewWithPlaceHolder:thumbnail andImageObject:imageObj];
    
    [self.view addSubview:self.imageDetailView];
}

- (void)controllerHitTheBottom:(id)sender
{
    [self search];
}

#pragma mark - image detail delegate functions

- (void)imageDetailViewDidClose:(id)sender
{
    self.imageDetailView = nil;
}

#pragma mark - uitextfield delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search];
    [self.textField resignFirstResponder];
    return YES;
}

@end

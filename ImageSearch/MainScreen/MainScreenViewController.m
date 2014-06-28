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
@property (strong, nonatomic) NSMutableArray* imageUrlArray;
@property (strong, nonatomic) MainScreenCollectionViewController* collectionViewController;
@property (strong, nonatomic) ImageDetailView* imageDetailView;

// Outlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup network manager
    self.networkManager = [[NetworkManager alloc] init];
    self.networkManager.delegate = self;
    
    self.imageUrlArray = [[NSMutableArray alloc] init];
    
    self.collectionViewController = [[MainScreenCollectionViewController alloc] init];
    self.collectionViewController.delegate = self;
    self.collectionViewController.collectionView = self.collectionView;
    self.collectionView.delegate = self.collectionViewController;
    self.collectionView.dataSource = self.collectionViewController;
    
    [self.collectionView registerClass:[MainScreenCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
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

#pragma mark - actions

- (IBAction)onButton:(id)sender
{
    NSString* searchStr = [self.textField.text searchString];
    [self.networkManager makeReqWithString:searchStr];
    [self.textField resignFirstResponder];
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
        [self.imageUrlArray addObject:imgObj];
    }
    self.collectionViewController.allItems = self.imageUrlArray;
    [self.collectionViewController reloadData];
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

#pragma mark - image detail delegate functions

- (void)imageDetailViewDidClose:(id)sender
{
    self.imageDetailView = nil;
}

#pragma mark - uitextfield delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onButton:nil];
    [self.textField resignFirstResponder];
    return YES;
}

@end

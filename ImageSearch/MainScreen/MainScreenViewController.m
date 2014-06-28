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

@interface MainScreenViewController ()
<NetworkManagerDelegate,
MainScreenCollectionViewControllerDelegate,
ImageDetailViewDelegate>

// strong referenced objects
@property (strong, nonatomic) NetworkManager* networkManager;
@property (strong, nonatomic) NSMutableArray* imageUrlArray;
@property (strong, nonatomic) MainScreenCollectionViewController* collectionViewController;
@property (strong, nonatomic) ImageDetailView* imageDetailView;

// Outlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
}

#pragma mark - actions

- (IBAction)onButton:(id)sender
{
    [self.networkManager makeReq];
}

#pragma mark - networkmanager delegate methods

- (void)requestFinished:(NSURLRequest *)req withDict:(NSDictionary *)dict
{
    NSMutableArray* items = [dict objectForKey:@"items"];
    for (NSDictionary* obj in items)
    {
        NSString* imgUrl = [[obj objectForKey:@"image"] objectForKey:@"thumbnailLink"];
        [self.imageUrlArray addObject:imgUrl];
    }
    self.collectionViewController.allItems = self.imageUrlArray;
    [self.collectionViewController reloadData];
}

- (void)requestFailed:(NSURLRequest *)req
{
    NSLog(@"failed");
}

#pragma mark - collectionviewcontroller delegate methods

- (void)controllerDidSelect:(id)sender image:(UIImage *)image
{
    if (!self.imageDetailView)
    {
        self.imageDetailView = (ImageDetailView*)[[[NSBundle mainBundle] loadNibNamed:@"ImageDetailView" owner:self options:nil] objectAtIndex:0];
    }
    self.imageDetailView.frame = self.view.bounds;
    self.imageDetailView.image = image;
    [self.view addSubview:self.imageDetailView];
}

#pragma mark - image detail delegate functions

- (void)imageDetailViewDidClose:(id)sender
{
    self.imageDetailView = nil;
}

@end

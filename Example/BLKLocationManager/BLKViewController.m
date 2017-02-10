//
//  BLKViewController.m
//  BLKLocationManager
//
//  Created by LiuHangqi on 12/30/2016.
//  Copyright (c) 2016 LiuHangqi. All rights reserved.
//

#import "BLKViewController.h"
#import "BLKLocationManager.h"

@interface BLKViewController ()

@property (nonatomic, strong) BLKLocationManager *locationManger;

@end

@implementation BLKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)requestAuth:(id)sender {
    
    [self.locationManger requestAuthorization];
}
- (IBAction)updateLocation:(id)sender {
    
   [self.locationManger updateLocationWithCompletion:^(BOOL servicesEnable, BOOL userEnable, NSArray<CLLocation *> *locations, NSError *error) {
    
       NSLog(@"serviceEnable:%d, userEnable:%d, locations:%@, error:%@",servicesEnable, userEnable, locations, error);
   }];
}
- (IBAction)status:(id)sender {
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.k
}

- (BLKLocationManager *)locationManger {
    
    return [BLKLocationManager sharedInstance];
}

@end

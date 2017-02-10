//
//  BLKLocationManager.m
//  Pods
//
//  Created by liu on 2016/12/30.
//
//

#import "BLKLocationManager.h"
#import "JZLocationConverter.h"

@interface BLKLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL userEnable;
@property (nonatomic, copy) BLKLocationCompletion completion;

@property (nonatomic, strong, readwrite) NSString *province;
@property (nonatomic, strong, readwrite) NSString *city;

@end

@implementation BLKLocationManager

+ (instancetype)sharedInstance {
    
    static BLKLocationManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shared = [[BLKLocationManager alloc]init];
    });
    
    return shared;
}

- (void)requestAuthorization {
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)updateLocationWithCompletion:(BLKLocationCompletion)completion {
    
    self.completion = completion;
    if (![CLLocationManager locationServicesEnabled]) {
     
        if (self.completion) {
            
            self.completion(NO, self.userEnable, nil, nil);
        }
        return;
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init]; 
    [geocoder reverseGeocodeLocation:locations[0] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count > 0) {
            
            CLPlacemark *placemark = placemarks[0];
            self.city = placemark.locality;
            self.province = placemark.administrativeArea;
        }
    }];
    
    CLLocationCoordinate2D location = [JZLocationConverter wgs84ToBd09:locations[0].coordinate];
    _latitude = location.latitude;
    _longitude = location.longitude;
    if (self.completion) {
        
        self.completion(YES, self.userEnable, locations, nil);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (self.completion) {
        
        self.completion(YES, self.userEnable, nil, error);
    }
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            self.userEnable = YES;
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            self.userEnable = NO;
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            self.userEnable = NO;
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            self.userEnable = NO;
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            self.userEnable = YES;
        }
            break;
        default:
            break;
    }
}

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return _locationManager;
}



@end

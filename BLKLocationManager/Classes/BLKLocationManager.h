//
//  BLKLocationManager.h
//  Pods
//
//  Created by liu on 2016/12/30.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^BLKLocationCompletion)(BOOL servicesEnable, BOOL userEnable, NSArray<CLLocation *> *locations, NSError *error);

@interface BLKLocationManager : NSObject

@property (nonatomic, strong, readonly) NSString *province;
@property (nonatomic, strong, readonly) NSString *city;

@property (nonatomic, assign, readonly) double latitude;
@property (nonatomic, assign, readonly) double longitude;

+ (instancetype)sharedInstance;

- (void)requestAuthorization;

- (void)updateLocationWithCompletion:(BLKLocationCompletion)completion;

@end

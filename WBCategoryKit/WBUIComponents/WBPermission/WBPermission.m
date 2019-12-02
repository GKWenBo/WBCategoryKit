//
//  WBPermission.m
//  Pods-WBCategoryKit_Example
//
//  Created by WenBo on 2019/12/2.
//

#import "WBPermission.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <CoreLocation/CoreLocation.h>
#import <EventKit/EventKit.h>
#import <HealthKit/HealthKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreTelephony/CTCellularData.h>

#import <objc/runtime.h>
#import "objc/message.h"

#import "WBCategoryKitCore.h"

@implementation WBPermission

+ (BOOL)wb_isServicesEnabledWithType:(WBPermissionType)type {
    if (type == WBPermissionType_Location) {
        SEL sel = NSSelectorFromString(@"wb_isServicesEnabled");
        BOOL ret = ((BOOL *(*)(id, SEL))objc_msgSend)(NSClassFromString(@"WBPermissionLocation"), sel);
        return ret;
    }
    return YES;
}

+ (BOOL)wb_isDeviceSupportedWithType:(WBPermissionType)type {
    if (type == WBPermissionType_Health) {
        SEL sel = NSSelectorFromString(@"wb_isHealthDataAvailable");
        BOOL ret = ((BOOL *(*)(id , SEL))objc_msgSend)(NSClassFromString(@"WBPermissionHealth"), sel);
        return ret;
    }
    return YES;
}

+ (BOOL)wb_authorizedWithType:(WBPermissionType)type {
    SEL sel = NSSelectorFromString(@"wb_authorized");
    NSString *classStr = nil;
    switch (type) {
        case WBPermissionType_Location:
            classStr = @"WBPermissionLocation";
            break;
        case WBPermissionType_Camera:
            classStr = @"WBPermissionCamera";
            break;
        case WBPermissionType_Photos:
            classStr = @"WBPermissionPhotos";
            break;
        case WBPermissionType_Contacts:
            classStr = @"WBPermissionContacts";
            break;
        case WBPermissionType_Reminders:
            classStr = @"WBPermissionReminders";
            break;
        case WBPermissionType_Calendar:
            classStr = @"WBPermissionCalendar";
            break;
        case WBPermissionType_Microphone:
            classStr = @"WBPermissionMicrophone";
            break;
        case WBPermissionType_Health:
            classStr = @"WBPermissionHealth";
            break;
        case WBPermissionType_MediaLibrary:
            classStr = @"WBPermissionMediaLibrary";
            break;
        default:
            break;
    }
    if (classStr) {
        BOOL ret = ((BOOL *(*)(id, SEL))objc_msgSend)(NSClassFromString(classStr), sel);
        return ret;
    }
    return NO;
}

+ (void)wb_authorizeWithType:(WBPermissionType)type completion:(void (^)(BOOL, BOOL))completion {
    SEL sel = NSSelectorFromString(@"wb_authorizeWithCompletion:");
    NSString *classStr = nil;
    switch (type) {
        case WBPermissionType_Location:
            classStr = @"WBPermissionLocation";
            break;
        case WBPermissionType_Camera:
            classStr = @"WBPermissionCamera";
            break;
        case WBPermissionType_Photos:
            classStr = @"WBPermissionPhotos";
            break;
        case WBPermissionType_Contacts:
            classStr = @"WBPermissionContacts";
            break;
        case WBPermissionType_Reminders:
            classStr = @"WBPermissionReminders";
            break;
        case WBPermissionType_Calendar:
            classStr = @"WBPermissionCalendar";
            break;
        case WBPermissionType_Microphone:
            classStr = @"WBPermissionMicrophone";
            break;
        case WBPermissionType_Health:
            classStr = @"WBPermissionHealth";
            break;
        case WBPermissionType_MediaLibrary:
            classStr = @"WBPermissionMediaLibrary";
            break;
        default:
            break;
    }
    if (classStr) {
        ((void(*)(id, SEL, void (^)(BOOL, BOOL)))objc_msgSend)(NSClassFromString(classStr), sel, completion);
    }
}

@end

// MARK: -------- Setting
@implementation WBPermissionSetting

+ (void)wb_displayAppPrivacySettings {
    if (@available(iOS 8,*))
    {
        if (UIApplicationOpenSettingsURLString != NULL)
        {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if (@available(iOS 10,*)) {
                [[UIApplication sharedApplication]openURL:appSettings options:@{} completionHandler:^(BOOL success) {
                }];
            }
            else
            {
                [[UIApplication sharedApplication]openURL:appSettings];
            }
        }
    }
}

+ (void)wb_showAlertToDislayPrivacySettingWithTitle:(NSString*)title
                                                msg:(NSString*)message
                                             cancel:(NSString*)cancel
                                            setting:(NSString*)setting {
    [self wb_showAlertToDislayPrivacySettingWithTitle:title
                                                  msg:message
                                               cancel:cancel
                                              setting:setting
                                           completion:nil];
}

+ (void)wb_showAlertToDislayPrivacySettingWithTitle:(NSString *)title
                                                msg:(NSString *)message
                                             cancel:(NSString *)cancel
                                            setting:(NSString *)setting
                                         completion:(void (^)(void))completion {
    if (@available(iOS 8,*)) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        //cancel
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancel
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
            if (completion) {
                completion();
            }
        }];
        [alertController addAction:action];
                
        //ok
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:setting
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            if (completion) {
                completion();
            }
            
            [self wb_currentTopViewController];
        }];
        [alertController addAction:okAction];
        
        [[self wb_currentTopViewController] presentViewController:alertController animated:YES completion:nil];
    }
}

+ (UIViewController*)wb_currentTopViewController {
    UIViewController *currentViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while ([currentViewController presentedViewController])    currentViewController = [currentViewController presentedViewController];
    
    if ([currentViewController isKindOfClass:[UITabBarController class]]
        && ((UITabBarController*)currentViewController).selectedViewController != nil )
    {
        currentViewController = ((UITabBarController*)currentViewController).selectedViewController;
    }
    
    while ([currentViewController isKindOfClass:[UINavigationController class]]
           && [(UINavigationController*)currentViewController topViewController])
    {
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    }
    
    return currentViewController;
}
    
@end

@implementation WBPermissionBase


@end

@implementation WBPermissionPhotos

+ (NSInteger)wb_authorizationStatus {
    if (@available(iOS 8, *)) {
         return  [PHPhotoLibrary authorizationStatus];
    } else {
        return  [ALAssetsLibrary authorizationStatus];
    }
}

+ (BOOL)wb_authorized {
    return [self wb_authorizationStatus] == 3;
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    if (@available(iOS 8.0, *)) {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        switch (status) {
            case PHAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case PHAuthorizationStatusNotDetermined:
            {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(status == PHAuthorizationStatusAuthorized,YES);
                        });
                    }
                }];
            }
                break;
            default:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
        }
        
    }else{
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        switch (status) {
            case ALAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES, NO);
                }
            }
                break;
            case ALAuthorizationStatusNotDetermined:
            {
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                
                [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                       usingBlock:^(ALAssetsGroup *assetGroup, BOOL *stop) {
                                           if (*stop) {
                                               if (completion) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       completion(YES, NO);
                                                   });
                                                   
                                               }
                                           } else {
                                               *stop = YES;
                                           }
                                       }
                                     failureBlock:^(NSError *error) {
                                         if (completion) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 completion(NO, YES);
                                             });
                                         }
                                     }];
            } break;
            case ALAuthorizationStatusRestricted:
            case ALAuthorizationStatusDenied:
            {
                if (completion) {
                    completion(NO, NO);
                }
            }
                break;
        }
    }
}

@end

@implementation WBPermissionCamera

+ (BOOL)wb_authorized {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        return permission == AVAuthorizationStatusAuthorized;
       
    } else {
        // Prior to iOS 7 all apps were authorized.
        return YES;
    }
}

+ (NSInteger)wb_authorizationStatus {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    } else {
        // Prior to iOS 7 all apps were authorized.
        return AVAuthorizationStatusAuthorized;
    }
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES,NO);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO,NO);
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                                             if (completion) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     completion(granted,YES);
                                                 });
                                             }
                                         }];
                
            }
                break;
        }
    } else {
        // Prior to iOS 7 all apps were authorized.
        completion(YES,NO);
    }
}

@end

@implementation WBPermissionContacts

+ (BOOL)wb_authorized {
    if (@available(iOS 9,*)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        return status ==  CNAuthorizationStatusAuthorized;
    }
    else
    {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        return status == kABAuthorizationStatusAuthorized;
    }
}

+ (NSInteger)wb_authorizationStatus {
    NSInteger status;
    if (@available(iOS 9,*)) {
       status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    }
    else{
        status = ABAddressBookGetAuthorizationStatus();
    }
    return status;
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    if (@available(iOS 9,*))
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status)
        {
            case CNAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case CNAuthorizationStatusDenied:
            case CNAuthorizationStatusRestricted:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case CNAuthorizationStatusNotDetermined:
            {
                [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (completion) {
                            completion(granted,YES);
                        }
                    });
                }];
                
            }
                break;
        }
    }
    else
    {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusAuthorized: {
                if (completion) {
                    completion(YES,NO);
                }
            } break;
            case kABAuthorizationStatusNotDetermined: {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted,YES);
                        });
                    }
                });
            } break;
            case kABAuthorizationStatusRestricted:
            case kABAuthorizationStatusDenied: {
                if (completion) {
                    completion(NO,NO);
                }
            } break;
        }
    }
}

@end
 
@interface WBPermissionLocation () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^permissionCompletion)(BOOL granted,BOOL firstTime);

@end

@implementation WBPermissionLocation

+ (instancetype)shareManager {
    static WBPermissionLocation *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WBPermissionLocation alloc]init];
    });
    return _instance;
}

+ (BOOL)wb_isServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (NSInteger)wb_authorizationStatus {
    return  [CLLocationManager authorizationStatus];
}

+ (BOOL)wb_authorized {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (@available(iOS 8,*)) {
        return (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
     }
    else if(@available(iOS 2,*)) {
        WBBeginIgnoreDeprecatedWarning
        return authorizationStatus == kCLAuthorizationStatusAuthorized;
        WBEndIgnoreDeprecatedWarning
     }
     return NO;
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    switch (authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways://kCLAuthorizationStatusAuthorized both equal 3
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            if (completion) {
                completion(YES,NO);
            }
        } break;
        case kCLAuthorizationStatusNotDetermined:
        {
            if (![self wb_isServicesEnabled]) {
                if (completion) {
                    completion(NO,NO);
                }
                return;
            }
            
            [[WBPermissionLocation shareManager] wb_startGps:completion];
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            if (completion) {
                completion(NO,NO);
            }
        } break;
    }
}

- (void)wb_startGps:(void(^)(BOOL granted,BOOL firstTime))completion {
    if (self.locationManager != nil) {
        [self stopGps];
    }
    
    self.permissionCompletion = completion;
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    if (@available(iOS 8,*)) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            BOOL hasAlwaysKey = [[NSBundle mainBundle]
                                 objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
            BOOL hasWhenInUseKey =
            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] !=
            nil;
            if (hasAlwaysKey) {
                [_locationManager requestAlwaysAuthorization];
            } else if (hasWhenInUseKey) {
                [_locationManager requestWhenInUseAuthorization];
            } else {
                // At least one of the keys NSLocationAlwaysUsageDescription or
                // NSLocationWhenInUseUsageDescription MUST be present in the Info.plist
                // file to use location services on iOS 8+.
                NSAssert(hasAlwaysKey || hasWhenInUseKey,
                         @"To use location services in iOS 8+, your Info.plist must "
                         @"provide a value for either "
                         @"NSLocationWhenInUseUsageDescription or "
                         @"NSLocationAlwaysUsageDescription.");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
}

- (void)stopGps
{
    if (self.locationManager )
    {
        [_locationManager stopUpdatingLocation];
        self.locationManager = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            //access permission,first callback this status
        }
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            
            [self stopGps];
            if (_permissionCompletion) {
                _permissionCompletion(YES,YES);
            }
            self.permissionCompletion = nil;
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            
            [self stopGps];
            if (_permissionCompletion) {
                _permissionCompletion(NO,YES);
            }
            self.permissionCompletion = nil;
            break;
        }
    }
}

@end

@implementation WBPermissionReminders

+ (NSInteger)wb_authorizationStatus {
    EKAuthorizationStatus status =
    [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    return  status;
}

+ (BOOL)wb_authorized {
    return [self wb_authorizationStatus] == EKAuthorizationStatusAuthorized;
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    EKAuthorizationStatus status = [self wb_authorizationStatus];
    
    switch (status) {
        case EKAuthorizationStatusAuthorized: {
            if (completion) {
                completion(YES, NO);
            }
        } break;
        case EKAuthorizationStatusNotDetermined:
        {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeReminder
                                       completion:^(BOOL granted, NSError *error) {
                                           if (completion) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   completion(granted,YES);
                                               });
                                           }
                                       }];
        }
            break;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied: {
            if (completion) {
                completion(NO, NO);
            }
        } break;
    }
}

@end

@implementation WBPermissionCalendar

+ (NSInteger)wb_authorizationStatus {
    return [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
}

+ (BOOL)wb_authorized {
    return [self wb_authorizationStatus] == EKAuthorizationStatusAuthorized;
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    EKAuthorizationStatus authorizationStatus =
    [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
        case EKAuthorizationStatusAuthorized: {
            if (completion) {
                completion(YES, NO);
            }
        } break;
        case EKAuthorizationStatusNotDetermined:
        {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeEvent
                                       completion:^(BOOL granted, NSError *error) {
                                           if (completion) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   completion(granted,YES);
                                               });
                                           }
                                       }];
        }
            break;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied: {
            if (completion) {
                completion(NO, NO);
            }
        } break;
    }
}

@end

@implementation WBPermissionMicrophone

static NSString *const kHasBeenAskedForMicrophonePermission = @"HasBeenAskedForMicrophonePermission";
+ (NSInteger)wb_authorizationStatus {
    if ( @available(iOS 8,*) ){
        return [[AVAudioSession sharedInstance] recordPermission];
    }
    else if (@available(iOS 7,*))
    {
        bool hasBeenAsked =
        [[NSUserDefaults standardUserDefaults] boolForKey:kHasBeenAskedForMicrophonePermission];
        if (hasBeenAsked) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            __block BOOL hasAccess;
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                hasAccess = granted;
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            return hasAccess ? 2 : 1;
        } else {
            return 0;
        }
    }
    else
        return 2;
}

+ (BOOL)wb_authorized {
    return [self wb_authorizationStatus] == AVAudioSessionRecordPermissionGranted;
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (@available(iOS 8.0, *)) {
        AVAudioSessionRecordPermission permission = [audioSession recordPermission];
        switch (permission) {
            case AVAudioSessionRecordPermissionGranted: {
                if (completion) {
                    completion(YES, NO);
                }
            }
                break;
            case AVAudioSessionRecordPermissionDenied: {
                if (completion) {
                    completion(NO, NO);
                }
            }
                break;
            case AVAudioSessionRecordPermissionUndetermined:
            {
                AVAudioSession *session = [[AVAudioSession alloc] init];
                NSError *error;
                [session setCategory:@"AVAudioSessionCategoryPlayAndRecord" error:&error];
                [session requestRecordPermission:^(BOOL granted) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(granted,YES);
                        });
                    }
                }];
            }
                break;
            default:
            {
                completion(NO,YES);
            }
                break;
        }
    }
    else if([audioSession respondsToSelector:@selector(requestRecordPermission:)])
    {
        [audioSession requestRecordPermission:^(BOOL granted) {
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

            if (completion) {
                BOOL hasBeenAskedPermission = [ud boolForKey:kHasBeenAskedForMicrophonePermission];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(granted,!hasBeenAskedPermission);
                });
            }
            
            [ud setBool:YES forKey:kHasBeenAskedForMicrophonePermission];
            [ud synchronize];
        }];
    }
    else
    {
        completion(YES, NO);
    }
}

@end

@implementation WBPermissionHealth

+ (NSInteger)wb_authorizationStatus {
    if (@available(iOS 8,*)) {
        
        if (![HKHealthStore isHealthDataAvailable])
        {
            return HKAuthorizationStatusSharingDenied;
        }
        
        NSMutableSet *readTypes = [NSMutableSet set];
        NSMutableSet *writeTypes = [NSMutableSet set];
        
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        NSMutableSet *allTypes = [NSMutableSet set];
        [allTypes unionSet:readTypes];
        [allTypes unionSet:writeTypes];
        for (HKObjectType *sampleType in allTypes) {
            HKAuthorizationStatus status = [healthStore authorizationStatusForType:sampleType];
            return status;
        }
        
        return HKAuthorizationStatusSharingDenied;
    }
    
    return 3;
}

+ (BOOL)wb_authorized {
    return [self wb_authorizationStatus] == 2;
}

+ (BOOL)wb_isHealthDataAvailable {
    if (@available(iOS 8,*)) {
    return [HKHealthStore isHealthDataAvailable];
    }
    return NO;
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    if ( @available(iOS 8,*) )
    {
        if (![HKHealthStore isHealthDataAvailable])
        {
            completion(NO,YES);
            return;
        }
        
        NSMutableSet *readTypes = [NSMutableSet set];
        NSMutableSet *writeTypes = [NSMutableSet set];
        
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        NSMutableSet *allTypes = [NSMutableSet set];
        [allTypes unionSet:readTypes];
        [allTypes unionSet:writeTypes];
        
        if (allTypes.count <= 0 ) {
            //设备不支持健康
            completion(NO,YES);
            return;
        }
        
        for (HKObjectType *healthType in allTypes) {
            HKAuthorizationStatus status = [healthStore authorizationStatusForType:healthType];
            switch (status) {
                case HKAuthorizationStatusNotDetermined:
                {
                        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
                        [healthStore requestAuthorizationToShareTypes:writeTypes
                                                            readTypes:readTypes
                                                           completion:^(BOOL success, NSError *error) {
                                                               if (completion) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       completion(success,YES);
                                                                   });
                                                               }
                                                           }];
                }
                    break;
                case HKAuthorizationStatusSharingAuthorized: {
                    if (completion) {
                        completion(YES, NO);
                    }
                } break;
                case HKAuthorizationStatusSharingDenied: {
                    if (completion) {
                        completion(YES, NO);
                    }
                } break;
            }
        }
    }
    else if (completion) {
        completion(YES, NO);
    }
}

@end

@implementation WBPermissionMediaLibrary

+ (NSInteger)wb_authorizationStatus {
    // if (@available(iOS 9.3, *))
    if (@available(iOS 9.3, *)) {
        return [MPMediaLibrary authorizationStatus];
    } else {
        
        return 3;
    }
}

+ (BOOL)wb_authorized {
    return [self wb_authorizationStatus] == 3;
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    // @available(iOS 9.3, *)
    if (@available(iOS 9.3, *)) {
        
        MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
        
        switch (status) {
            case MPMediaLibraryAuthorizationStatusAuthorized:
            {
                if (completion) {
                    completion(YES, NO);
                }
                
            }
                break;
            case MPMediaLibraryAuthorizationStatusRestricted:
            case MPMediaLibraryAuthorizationStatusDenied:
            {
                if (completion) {
                    completion(NO, NO);
                }
            }
                break;
            case MPMediaLibraryAuthorizationStatusNotDetermined:
            {
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(status == MPMediaLibraryAuthorizationStatusAuthorized, YES);
                        });
                    }
                    
                }];
            }
                break;
            default:
            {
                if (completion) {
                    completion(NO, NO);
                }
                
            }
                break;
        }

    } else {
        completion(YES, NO);
    }
}

@end

@interface WBPermissionData ()

@property (nonatomic, strong) id cellularData;
@property (nonatomic, copy) void (^completion)(BOOL granted,BOOL firstTime);

@end

@implementation WBPermissionData

+ (instancetype)shareManager {
    static WBPermissionData *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WBPermissionData alloc]init];
    });
    return _instance;
}

+ (void)wb_authorizeWithCompletion:(void (^)(BOOL, BOOL))completion {
    if (@available(iOS 10,*)) {
        [WBPermissionData shareManager].completion = completion;
        
        if (![WBPermissionData shareManager].cellularData) {
            
            CTCellularData *cellularData = [[CTCellularData alloc] init];
            
            cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (state == kCTCellularDataNotRestricted) {
                        //没有限制
                        [WBPermissionData shareManager].completion(YES,NO);
                        NSLog(@"有网络权限");
                    }
                    else if (state == kCTCellularDataRestrictedStateUnknown)
                    {
                        //                    completion(NO,NO);
                        NSLog(@"没有请求网络或正在等待用户确认权限?");
                    }
                    else{
                        //
                        [WBPermissionData shareManager].completion(NO,NO);
                        NSLog(@"无网络权限");
                    }
                });
            };
            
            //不存储，对象cellularData会销毁
            [WBPermissionData shareManager].cellularData = cellularData;
        }
    }
    else
    {
        completion(YES,NO);
    }
}

@end

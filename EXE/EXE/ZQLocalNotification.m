//
//  ZQLocalNotification.m
//  EXE
//
//  Created by 祝贺 on 2017/3/6.
//  Copyright © 2017年 zhuhe. All rights reserved.
//
#import "ZQLocalNotification.h"

NSString *notificationDateFormat(NotificationType status) {
    switch (status) {
        case TimerNotification:
            return @"yyyy-MM-dd";
        case CountdownNotification:
            return @"yyyy-MM-dd HH:mm:ss zzz";
    }
}
static NSInteger const afterTime_zq = 20;
#define MY_SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

@implementation ZQLocalNotification

+(void)initialize{

    [self registerNotification];
}


+(void)NotificationType:(NotificationType)notificationType
             Identifier:(NSString  *)identifier
             activityId:(NSInteger  )activityId
              alertBody:(NSString  *)alertBody
             alertTitle:(NSString  *)alertTitle
            alertString:(NSString  *)alertString
            withTimeDay:(NSInteger  )day
                   hour:(NSInteger  )hour
                 minute:(NSInteger  )minute
                 second:(NSInteger  )second;
{
    
    [self registerNotification];
    [self cancleLocationIdentifier:identifier activityIds:activityId];
    NSTimeInterval allTime = [self allTimeWithTimeDay:day hour:hour minute:minute second:second];
    if (MY_SYSTEMVERSION > 10 )
          [self NotificationiOSTenLaterWithKey:identifier activityId:activityId alertBody:alertBody alertTitle:alertTitle time: [self intervalSinceNow:[self stringFromDate:[self getNotificationTimeWithTime:allTime notificationType:notificationType]]] alertString:alertString];
    else
        [self NotificationiOSTenBeforeIdentifier:identifier activityId:activityId alertBody:alertBody alertTitle:alertTitle fireDate:[self getNotificationTimeWithTime:allTime notificationType:notificationType] alertString:alertString];
      
}


+(NSTimeInterval)allTimeWithTimeDay:(NSInteger )day
                               hour:(NSInteger )hour
                             minute:(NSInteger )minute
                             second:(NSInteger )second{
    NSTimeInterval allTime = 0 ;
    if (day) {
        allTime += day * 24 *60 *60;
    }
    
    if (hour) {
        allTime += hour *60*60;
    }
    
    if (minute) {
        allTime += minute *60;
    }
    
    if (second) {
        allTime += second;
    }
    
    //测试延迟 5s
    if (allTime == 0) {
    
        NSLog(@"---设置时间为 nil 或者 0  afterTime_zq后唤起本地通知");
    }
    
    allTime += afterTime_zq;
    
    return allTime;
    
}

+(void)NotificationiOSTenBeforeIdentifier:(NSString *)identifier
                               activityId:(NSInteger )activityId
                                alertBody:(NSString *)alertBody
                               alertTitle:(NSString *)alertTitle
                                 fireDate:(NSDate*)fireDate
                              alertString:(NSString *)alertString{
    
    UILocalNotification *notification           = [[UILocalNotification alloc] init];
    if (notification!=nil) {
        notification.fireDate                   = fireDate;
        notification.repeatInterval             = NSCalendarUnitMonth;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone                   = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = 1; //应用的红色数字
        notification.soundName                  = UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        NSDictionary *dic                       = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:activityId], identifier,nil];
        notification.userInfo                   = dic;
        notification.alertBody                  = alertBody;//提示信息 弹出提示框
        notification.alertAction                = alertString;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

+(void)NotificationiOSTenLaterWithKey:(NSString *)key activityId:(NSInteger )activityId alertBody:(NSString *)alertBody alertTitle:(NSString *)alertTitle time:(NSTimeInterval)time alertString:(NSString *)alertString{
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:alertTitle arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:alertBody arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:key content:content trigger:trigger];
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"error = %@",request);
    }];
}


//针对 ios 10 后的 本地 推送时间
+ (NSTimeInterval)intervalSinceNow:(NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late= [d timeIntervalSince1970]*1;
    
    NSDate *date1 = [[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSTimeInterval now =  [date1 timeIntervalSince1970]*1;
    NSTimeInterval cha = late-now;
    return cha;
}




+(NSDate *)getNotificationTimeWithTime:(NSTimeInterval)time notificationType:(NotificationType)notificationType{
    NSString *dateFormat = notificationDateFormat(notificationType);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [[NSDate alloc]init];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:dateFormat];
    NSDate *date2 = [dateFormatter dateFromString:dateString];
    //        60 * 60 * 24 * 7 + 21*60*60
    NSTimeInterval interval = time;
    NSDate *notificationDate = [date initWithTimeInterval:interval sinceDate:date2];
    return notificationDate;
    
}


+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(void)registerNotification{
    
    if (MY_SYSTEMVERSION >= 10.0) {
#define MY_SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //请求获取通知权限（角标，声音，弹框）
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //获取用户是否同意开启通知
                NSLog(@"request authorization successed!");
            }
        }];
        
#endif
    }else if (MY_SYSTEMVERSION >= 8.0){
        if ([[UIApplication sharedApplication]  respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings* settings=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            NSLog(@"iOS 8.0 ");
        }
    }else if (MY_SYSTEMVERSION >= 7.0){
        if ([[UIApplication sharedApplication]  respondsToSelector:@selector(registerForRemoteNotificationTypes:)]) {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
    }
}

+(void)cancleLocationIdentifier:(NSString *)identifier activityIds:(NSInteger)activityIds{
    
    if (MY_SYSTEMVERSION <10) {
        NSArray *localNotifications  = [[UIApplication sharedApplication] scheduledLocalNotifications];
        [localNotifications enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj && [obj isKindOfClass:[UILocalNotification  class]]) {
                UILocalNotification *notification = (UILocalNotification *)obj;
                NSInteger activityId = [[notification.userInfo objectForKey:identifier] integerValue];
                if (activityId == activityIds) {
                    [[UIApplication sharedApplication] cancelLocalNotification:obj];
                }
            }
        }];
    }else{
#define MY_SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
#endif
        
    }
}

@end

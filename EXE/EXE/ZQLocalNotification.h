
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/*
   TimerNotification 定时器 从当天凌晨开始计算 满足需求是 x 天后的 某个特定的时间唤起通知   例如  3 天后 上午 8:30  或者 6 天后 晚上 20:30(24小时制)
   CountdownNotification 倒计时  从当前时刻开始倒计时
*/
typedef NS_ENUM(NSInteger, NotificationType){

    TimerNotification,
    CountdownNotification,
};

typedef NS_ENUM(NSInteger, repeatRule){
    repeatYear,
    repeatMouth,
    repeatDay,
    repeatHour,
    repeatMinute
};

@interface ZQLocalNotification : NSObject


/**
 @param identifier 字符串唯一标示
 @param activityId 数字唯一标示
 @param alertBody  提醒文字内容
 @param alertTitle 提醒的题头
 @param alertString 按钮文字
 @param day        几天后
 @param hour       几点(24 小时)
 @param minute     几分
 @param second     几秒
 */

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


//未完待续
//+(void)NotificationRepeatWithRepeatRule:(repeatRule )repeatRule
//                                   Year:(NSInteger  )year
//                                  mouth:(NSInteger  )mouth
//                                    Day:(NSInteger  )day
//                                   hour:(NSInteger  )hour
//                                 minute:(NSInteger  )minute;

@end

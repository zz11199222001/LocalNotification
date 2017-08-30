

#import "ViewController.h"
#import "ZQLocalNotification.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ZQLocalNotification NotificationType:CountdownNotification Identifier:@"112122" activityId:1900000 alertBody:@"开始测试了" alertTitle:@"题头" alertString:@"测试" withTimeDay:1 hour:0 minute:0 second:0];

}



@end

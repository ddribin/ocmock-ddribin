//

#import <Foundation/Foundation.h>

#import "OCClassMockObject.h"

@interface OCMockNotificationObserver : OCClassMockObject
{
    NSNotificationCenter * center;
}

+ (id)observerWithNotificationCenter:(NSNotificationCenter *)notificationCenter;

+ (id)observer;

- (id)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter;

- (id)init;

- (void)expectNotification:(NSString *)notificationName;

- (void)expectNotification:(NSString *)notificationName object:(id)object;

- (void)expectNotification:(NSString *)notificationName object:(id)object userInfo:(NSDictionary *)userInfo;

- (void)registerNotification:(NSString *)notificationName;

- (void)registerNotification:(NSString *)notificationName object:(id)object;

- (void)recordNotification:(NSNotification *)notification;

@end

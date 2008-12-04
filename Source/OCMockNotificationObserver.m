//

#import <OCMock/OCMockNotificationObserver.h>
#import "OCClassMockObject.h"
#import "OCProtocolMockObject.h"
#import <OCMock/OCMockRecorder.h>
#import "NSInvocation+OCMAdditions.h"
#import <OCMock/OCMConstraint.h>

@interface OCMockNotificationObserverToMock : NSObject

- (void)recordNotification:(NSString *)notification
                    object:(id)object
                  userInfo:(NSDictionary *)userInfo;

@end

@implementation OCMockNotificationObserverToMock

- (void)recordNotification:(NSString *)notification
                    object:(id)object
                  userInfo:(NSDictionary *)userInfo;
{
}

@end

@interface OCMockNotificationObserver (Mock)

- (void)recordNotification:(NSString *)notification
                    object:(id)object
                  userInfo:(NSDictionary *)userInfo;

@end

@implementation OCMockNotificationObserver

+ (id)observerWithNotificationCenter:(NSNotificationCenter *)notificationCenter;
{
    id o = [[self alloc] initWithNotificationCenter:notificationCenter];
    return [o autorelease];
}

+ (id)observer;
{
    id o = [[self alloc] init];
    return [o autorelease];
}

- (id)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter;
{
    self = [super initWithClass:[OCMockNotificationObserverToMock class]];
    if (self == nil)
        return nil;
    
    center = notificationCenter;
    mockOrderMatters = YES;
    
    return self;
}

- (id)init
{
    return [self initWithNotificationCenter:[NSNotificationCenter defaultCenter]];
}

- (void)dealloc
{
    [center removeObserver:self];
    
    [super dealloc];
}

- (void)registerNotification:(NSString *)notificationName;
{
    [self registerNotification:notificationName object:nil];
}

- (void)registerNotification:(NSString *)notificationName object:(id)object;
{
    [center addObserver:self
               selector:@selector(recordNotification:)
                   name:notificationName
                 object:object];
}

- (void)expectNotification:(NSString *)notificationName;
{
    [self expectNotification:notificationName object:OCMOCK_ANY userInfo:OCMOCK_ANY];
}

- (void)expectNotification:(NSString *)notificationName object:(id)object;
{
    [self expectNotification:notificationName object:object userInfo:OCMOCK_ANY];
}

- (void)expectNotification:(NSString *)notificationName object:(id)object userInfo:(NSDictionary *)userInfo;
{
    [[self expect] recordNotification:notificationName object:object userInfo:userInfo];
}

- (void)recordNotification:(NSNotification *)notification;
{
    [self recordNotification:[notification name]
                      object:[notification object]
                    userInfo:[notification userInfo]];
}

//---------------------------------------------------------------------------------------
//  proxy api
//---------------------------------------------------------------------------------------

- (BOOL)orderMatters
{
    return YES;
}

@end

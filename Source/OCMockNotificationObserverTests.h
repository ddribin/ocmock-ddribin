//

#import <SenTestingKit/SenTestingKit.h>

@class OCMockNotificationObserver;

@interface OCMockNotificationObserverTests : SenTestCase
{
    NSNotificationCenter * center;
    OCMockNotificationObserver * observer;
    id sender1;
    id sender2;
}

@end

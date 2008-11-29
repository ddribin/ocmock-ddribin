//

#import "OCMockNotificationObserverTests.h"
#import "OCMockNotificationObserver.h"

static NSString * OCMockTestNotificationOne = @"OCMockTestNotificationOne";
static NSString * OCMockTestNotificationTwo = @"OCMockTestNotificationTwo";

@implementation OCMockNotificationObserverTests

- (void)setUp
{
    center = [NSNotificationCenter defaultCenter];
    observer = [OCMockNotificationObserver observerWithNotificationCenter:center];
    sender1 = @"sender1";
    sender2 = @"sender2";
}

- (void)testRegisterNoExpect
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    
    [observer verify];
}

- (void)testExpectAndReceiveNoteAnySender1
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer expectNotification:OCMockTestNotificationOne];
    
    [center postNotificationName:OCMockTestNotificationOne object:sender1];

    [observer verify];
}

- (void)testExpectAndReceiveNoteAnySender2
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer expectNotification:OCMockTestNotificationOne];
    
    [center postNotificationName:OCMockTestNotificationOne object:sender2];
    
    [observer verify];
}

- (void)testReceiveUnexpectedNote
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    
    STAssertThrows([center postNotificationName:OCMockTestNotificationOne object:sender1],
                   nil);
}

- (void)testReceiveUnexpectedSecondNote
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer expectNotification:OCMockTestNotificationOne];
    
    [center postNotificationName:OCMockTestNotificationOne object:sender1];

    STAssertThrows([center postNotificationName:OCMockTestNotificationOne object:self],
                   nil);
}

- (void)testReceiveTwoNotes
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer registerNotification:OCMockTestNotificationTwo object:nil];
    [observer expectNotification:OCMockTestNotificationOne];
    [observer expectNotification:OCMockTestNotificationTwo];
    
    [center postNotificationName:OCMockTestNotificationOne object:sender1];
    [center postNotificationName:OCMockTestNotificationTwo object:sender1];

    [observer verify];
}

- (void)testReceiveTwoNotesWrongOrder
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer registerNotification:OCMockTestNotificationTwo object:nil];
    [observer expectNotification:OCMockTestNotificationOne];
    [observer expectNotification:OCMockTestNotificationTwo];
    
    STAssertThrows([center postNotificationName:OCMockTestNotificationTwo object:self], nil);
}

- (void)testReceiveMultipleNotes
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer registerNotification:OCMockTestNotificationTwo object:nil];

    [observer expectNotification:OCMockTestNotificationOne];
    [observer expectNotification:OCMockTestNotificationTwo];
    [observer expectNotification:OCMockTestNotificationOne];
    
    [center postNotificationName:OCMockTestNotificationOne object:sender1];
    [center postNotificationName:OCMockTestNotificationTwo object:sender1];
    [center postNotificationName:OCMockTestNotificationOne object:sender1];

    [observer verify];
}

- (void)testReceiveSpecificObject
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer expectNotification:OCMockTestNotificationOne object:sender1];
    
    [center postNotificationName:OCMockTestNotificationOne object:sender1];
    
    [observer verify];
}

- (void)testReceiveWrongObject
{
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer expectNotification:OCMockTestNotificationOne object:sender1];
    
    STAssertThrows([center postNotificationName:OCMockTestNotificationOne object:sender2], nil);
}

- (void)testReceiveSpecificUserInfo
{
    NSDictionary * expectedUserInfo = [NSDictionary dictionaryWithObject:@"Joe" forKey:@"Name"];
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer expectNotification:OCMockTestNotificationOne object:sender1 userInfo:expectedUserInfo];

    NSDictionary * sentUserInfo = [NSDictionary dictionaryWithObject:@"Joe" forKey:@"Name"];
    [center postNotificationName:OCMockTestNotificationOne object:sender1 userInfo:sentUserInfo];
    
    [observer verify];
}

- (void)testReceiveWrongUserInfo
{
    NSDictionary * expectedUserInfo = [NSDictionary dictionaryWithObject:@"Joe" forKey:@"Name"];
    [observer registerNotification:OCMockTestNotificationOne object:nil];
    [observer expectNotification:OCMockTestNotificationOne object:sender1 userInfo:expectedUserInfo];
    
    NSDictionary * sentUserInfo = [NSDictionary dictionaryWithObject:@"Jane" forKey:@"Name"];

    STAssertThrows([center postNotificationName:OCMockTestNotificationOne object:sender1 userInfo:sentUserInfo],
                   nil);
}

@end

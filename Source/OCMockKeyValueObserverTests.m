//

#import "OCMockKeyValueObserverTests.h"
#import "OCMockKeyValueObserver.h"


@interface TestOCMockPerson : NSObject
{
    NSString * _name;
    int _age;
    NSMutableArray * _children;
}

- (void)setName:(NSString *)name;
- (NSString *)name;

- (void)setAge:(int)age;
- (int)age;

- (void)addChild:(NSString *)child;

@end

@implementation TestOCMockPerson

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _children = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc
{
    [_children release];
    [super dealloc];
}

- (void)setName:(NSString *)name;
{
    [_name autorelease];
    _name = [name retain];
}

- (NSString *)name;
{
    return _name;
}

- (void)setAge:(int)age;
{
    _age = age;
}

- (int)age;
{
    return _age;
}

- (void)addChild:(NSString *)child;
{
    [[self mutableArrayValueForKey:@"children"] addObject:child];
    // This would fail:
    // [_children addObject:child];
}

@end


@implementation OCMockKeyValueObserverTests

- (void)testObserveObjectKeyPath
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"name" object:person options:NSKeyValueObservingOptionNew];

    [observer expectKeyPath:@"name" object:person];
        
    [person setName:@"Jane"];
    [person setAge:25];
    
    [observer verify];
}

- (void)testReceiveUnexpected
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"name" object:person options:NSKeyValueObservingOptionNew];

    [observer expectKeyPath:@"name" object:person];
    
    [person setName:@"Jane"];
    [person setAge:25];
    
    STAssertThrows([person setName:@"Jim"], nil);
}

- (void)testObserveSpecificNewValue
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"name" object:person options:NSKeyValueObservingOptionNew];

    [observer expectKeyPath:@"name" object:person newValue:@"Jane"];
    
    [person setName:@"Jane"];
    [person setAge:25];
    
    [observer verify];
}

- (void)testObserveWrongNewValue
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"name" object:person options:NSKeyValueObservingOptionNew];

    [observer expectKeyPath:@"name" object:person newValue:@"Jane"];
    
    STAssertThrows([person setName:@"Jim"], nil);
}

- (void)testObserveSpecificOldValue
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"name" object:person options:NSKeyValueObservingOptionOld];

    [observer expectKeyPath:@"name" object:person oldValue:@"Joe"];
    
    [person setName:@"Jane"];
    [person setAge:25];
    
    [observer verify];
}

- (void)testObserveWrongOldValue
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"name" object:person options:NSKeyValueObservingOptionOld];
    
    [observer expectKeyPath:@"name" object:person oldValue:@"Jane"];
    
    STAssertThrows([person setName:@"Jim"], nil);
}

- (void)testObserveSpecificIndexesValue
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"children" object:person options:NSKeyValueObservingOptionNew];

    [observer expectKeyPath:@"children" object:person];
    
    [person addChild:@"Jim"];
    
    [observer verify];
}

- (void)testObserveMultipleIndexes
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"children" object:person];
    
    [observer expectKeyPath:@"children" object:person indexes:[NSIndexSet indexSetWithIndex:0]];
    [observer expectKeyPath:@"children" object:person indexes:[NSIndexSet indexSetWithIndex:1]];
    
    [person addChild:@"Jim"];
    [person addChild:@"Jack"];
    
    [observer verify];
}

- (void)testObserveMultipleKeyPaths
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"name" object:person];
    [observer registerKeyPath:@"age" object:person];
    
    [observer expectKeyPath:@"name" object:person];
    [observer expectKeyPath:@"age" object:person];

    [person setName:@"Jim"];
    [person setAge:25];
    
    [observer verify];
}

- (void)testObserveMultipleKeyPathsIncorrectOrder
{
    OCMockKeyValueObserver * observer = [[[OCMockKeyValueObserver alloc] init] autorelease];
    TestOCMockPerson * person = [[[TestOCMockPerson alloc] init] autorelease];
    
    [person setName:@"Joe"];
    [person setAge:30];
    [observer registerKeyPath:@"name" object:person];
    [observer registerKeyPath:@"age" object:person];
    
    [observer expectKeyPath:@"age" object:person];
    [observer expectKeyPath:@"name" object:person];
    
    STAssertThrows([person setName:@"Jim"], nil);
}

@end

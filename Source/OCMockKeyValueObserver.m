//

#import "OCMockKeyValueObserver.h"
#import <OCMock/OCMockRecorder.h>
#import <OCMock/OCMConstraint.h>

@interface OCMockKeyValueObserverToMock : NSObject

- (void)recordKeyPath:(NSString *)keyPath
               object:(id)object
           changeKind:(id)changeKind
            changeOld:(id)changeOld
            changeNew:(id)changeNew
        changeIndexes:(id)changeIndexes;

@end

@implementation OCMockKeyValueObserverToMock

- (void)recordKeyPath:(NSString *)keyPath
               object:(id)object
           changeKind:(id)changeKind
            changeOld:(id)changeOld
            changeNew:(id)changeNew
        changeIndexes:(id)changeIndexes;
{
}

@end

#pragma mark -

@interface OCMockKeyValueObserverHelper : NSObject
{
    // Weak reference
    OCMockKeyValueObserverToMock * _mock;
    NSString * _keyPath;
    id _object;
    BOOL _registered;
}

- (id)initWithMock:(OCMockKeyValueObserverToMock *)mock
           keyPath:(NSString *)keyPath
            object:(id)object
           options:(NSKeyValueObservingOptions)options;

- (void)unregister;

@end

static NSString * kContext = @"OCMockKeyValueObserverHelper context";

@implementation OCMockKeyValueObserverHelper

- (id)initWithMock:(OCMockKeyValueObserverToMock *)mock
           keyPath:(NSString *)keyPath
            object:(id)object
           options:(NSKeyValueObservingOptions)options;
{
    self = [super init];
    if (self == nil)
        return nil;
    
    _mock = mock;
    _keyPath = [keyPath copy];
    _object = [object retain];
    
    [_object addObserver:self
              forKeyPath:_keyPath
                 options:options
                 context:&kContext];
    _registered = YES;

    return self;
}

- (void)dealloc
{
    [self unregister];
    [_object release];
    
    [super dealloc];
}

- (void)finalize
{
    [self unregister];
}

- (void)unregister;
{
    if (_registered)
    {
        [_object removeObserver:self forKeyPath:_keyPath];
        _registered = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == &kContext)
    {
        id changeKind  = [change objectForKey:NSKeyValueChangeKindKey];
        id changeOld = [change objectForKey:NSKeyValueChangeOldKey];
        id changeNew = [change objectForKey:NSKeyValueChangeNewKey];
        id changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey];
        
        [_mock recordKeyPath:keyPath object:object
                  changeKind:changeKind
                   changeOld:changeOld
                   changeNew:changeNew
               changeIndexes:changeIndexes];
    }
}

@end

#pragma mark -

@interface OCMockKeyValueObserver (Mock)

- (void)recordKeyPath:(NSString *)keyPath
               object:(id)object
           changeKind:(NSNumber *)changeKind
            changeOld:(id)changeOld
            changeNew:(id)changeNew
        changeIndexes:(id)changeIndexes;

@end

@implementation OCMockKeyValueObserver

+ (id)observer;
{
    id o = [[self alloc] init];
    return [o autorelease];
}

- (id)init
{
    self = [super initWithClass:[OCMockKeyValueObserverToMock class]];
    if (self == nil)
        return nil;
    
    helpers = [[NSMutableArray alloc] init];
    keyPaths = [[NSMutableArray alloc] init];
        
    return self;
}

- (void)dealloc
{
    [self unregisterAll];
    [super dealloc];
}

- (void)finalize
{
    [self unregisterAll];
}

- (void)unregisterAll;
{
    [helpers makeObjectsPerformSelector:@selector(unregister)];
    [helpers removeAllObjects];
}

- (void)registerKeyPath:(NSString *)keyPath object:(id)object;
{
    [self registerKeyPath:keyPath object:object options:0];
}

- (void)registerKeyPath:(NSString *)keyPath object:(id)object options:(NSKeyValueObservingOptions)options;
{
    OCMockKeyValueObserverHelper * helper = [[OCMockKeyValueObserverHelper alloc] initWithMock:(id)self
                                                                                       keyPath:keyPath
                                                                                        object:object
                                                                                       options:options];
    [helper autorelease];
    
    [helpers addObject:helper];
}

- (void)expectKeyPath:(NSString *)keyPath object:(id)object;
{
    [[self expect] recordKeyPath:keyPath object:object
                      changeKind:OCMOCK_ANY
                       changeOld:OCMOCK_ANY
                       changeNew:OCMOCK_ANY
                   changeIndexes:OCMOCK_ANY];

}

- (void)expectKeyPath:(NSString *)keyPath object:(id)object newValue:(id)value
{
    [[self expect] recordKeyPath:keyPath
                          object:object
                      changeKind:OCMOCK_ANY
                       changeOld:OCMOCK_ANY
                       changeNew:value
                   changeIndexes:OCMOCK_ANY];
}

- (void)expectKeyPath:(NSString *)keyPath object:(id)object oldValue:(id)value
{
    [[self expect] recordKeyPath:keyPath
                          object:object
                      changeKind:OCMOCK_ANY
                       changeOld:value
                       changeNew:OCMOCK_ANY
                   changeIndexes:OCMOCK_ANY];
}

- (void)expectKeyPath:(NSString *)keyPath object:(id)object indexes:(id)indexes
{
    [[self expect] recordKeyPath:keyPath
                          object:object
                      changeKind:OCMOCK_ANY
                       changeOld:OCMOCK_ANY
                       changeNew:OCMOCK_ANY
                   changeIndexes:indexes];
}

//---------------------------------------------------------------------------------------
//  proxy api
//---------------------------------------------------------------------------------------

- (BOOL)orderMatters
{
    return YES;
}

@end

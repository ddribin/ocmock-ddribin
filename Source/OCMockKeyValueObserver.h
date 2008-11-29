//

#import "OCClassMockObject.h"

@interface OCMockKeyValueObserver : OCClassMockObject
{
    NSMutableArray * helpers;
    NSMutableArray * keyPaths;
}

- (void)registerKeyPath:(NSString *)keyPath object:(id)object;

- (void)registerKeyPath:(NSString *)keyPath object:(id)object options:(NSKeyValueObservingOptions)options;

- (void)unregisterAll;

- (void)expectKeyPath:(NSString *)keyPath object:(id)object;

- (void)expectKeyPath:(NSString *)keyPath object:(id)object newValue:(id)value;

- (void)expectKeyPath:(NSString *)keyPath object:(id)object oldValue:(id)value;

- (void)expectKeyPath:(NSString *)keyPath object:(id)object indexes:(id)indexes;

@end

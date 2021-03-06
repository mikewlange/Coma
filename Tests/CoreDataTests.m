//
//  CoreDataTests.m
//  CoreDataTests
//
//  Created by Sam Deane on 06/06/2013.
//  Copyright (c) 2013 Bohemian Coding. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ECUnitTests/ECUnitTests.h>

#import <Coma/Coma.h>

// if this is 1, you need to link in the mogenerator versions of the classes
// if it is 0, you need to link in the Coma versions of the classes

#define TEST_MOGENERATED 0

#if TEST_MOGENERATED

#import "Data/coredata/Mogenerator/Person.h"
#import "Data/coredata/Mogenerator/Job.h"

#else

#import "Data/coredata/Coma/Person.h"
#import "Data/coredata/Coma/Job.h"

#endif

@interface CoreDataTests : ECTestCase

@end

ECDeclareDebugChannel(ComaEngineChannel);
ECDeclareDebugChannel(ComaTemplatesChannel);
ECDeclareDebugChannel(ComaModelChannel);


@interface CoreDataTests()
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) NSManagedObjectModel* model;
@property (strong, nonatomic) NSPersistentStoreCoordinator* coordinator;
@end

@implementation CoreDataTests

+ (void)setUp
{
    // turn on some logging for the tests
    ECEnableChannel(ComaEngineChannel);
    ECEnableChannel(ComaModelChannel);
    ECEnableChannel(ComaTemplatesChannel);
}

- (void)setupCoreData
{
    // create a new model and coordinator
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSBundle* thisBundle = [NSBundle bundleForClass:[self class]];
    NSArray* bundles = (mainBundle == thisBundle) ? @[thisBundle] : @[thisBundle, mainBundle];
    self.model = [NSManagedObjectModel mergedModelFromBundles:bundles];
    NSPersistentStoreCoordinator* coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.model];
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
    context.undoManager = nil;

    self.context = context;
    self.coordinator = coordinator;
    
}


- (void)testTwoWayRelationships
{
    [self setupCoreData];

#if TEST_MOGENERATED
    Person* person = [[Person alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context];
    Job* job = [[Job alloc] initWithEntity:[NSEntityDescription entityForName:@"Job" inManagedObjectContext:self.context] insertIntoManagedObjectContext:self.context];
#else
    Person* person = [[Person alloc] init];
    Job* job = [[Job alloc] init];
#endif

    person.job = job;

    ECTestAssertTrue([job.staff containsObject:person]);

    person.job = nil;

    ECTestAssertFalse([job.staff containsObject:person]);

    NSMutableSet* staff = [job mutableSetValueForKey:@"staff"];
    [staff addObject:person];

    ECTestAssertTrue(person.job == job);

    [staff removeObject:person];

    ECTestAssertFalse(person.job == job);

}

#define WRITE_TO_DESKTOP 1

- (void)testGeneratingComaClasses
{
    NSURL* modelURL = [self URLForTestResource:@"CoreData" withExtension:@"xcdatamodeld" subdirectory:@"Data/coredata"];
    BCComaMomConverter* converter = [BCComaMomConverter new];

    NSError* error;
    NSURL* coreDataURL = [self URLForTestResource:@"CoreDataBase" withExtension:@"json" subdirectory:@"Data/coredata"];
    NSData* coreDataData = [NSData dataWithContentsOfURL:coreDataURL];
    NSDictionary* coreDataBase = [NSJSONSerialization JSONObjectWithData:coreDataData options:0 error:&error];

    NSDictionary* coreDataMerged = [converter mergeModelAtURL:modelURL into:coreDataBase error:&error];
    ECTestAssertNotNil(coreDataMerged);

    NSURL* mergedURL = [modelURL URLByAppendingPathExtension:@"json"];
    NSData* mergedData = [NSJSONSerialization dataWithJSONObject:coreDataMerged options:NSJSONWritingPrettyPrinted error:&error];
    [mergedData writeToURL:mergedURL atomically:YES];

    BCComaEngine* engine = [BCComaEngine new];

    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSURL* templates = [bundle URLForResource:@"generated" withExtension:@"" subdirectory:@"Data/coredata/templates"];

    NSArray* expectedNames = @[@"_Person.h", @"_Person.m", @"_Job.h", @"_Job.m"];
    NSMutableDictionary* expected = [NSMutableDictionary dictionary];
    for (NSString* expectedName in expectedNames)
    {
#if TEST_MOGENERATED
        NSString* engine = @"Mogenerator";
#else
        NSString* engine = @"Coma";
#endif
        NSString* subdirectory = [NSString stringWithFormat:@"Data/coredata/%@/Generated", engine];
        expected[expectedName] = [bundle URLForResource:[expectedName stringByDeletingPathExtension] withExtension:[expectedName pathExtension] subdirectory:subdirectory];
    }

    [engine generateModelAtURL:mergedURL withTemplatesAtURL:templates outputBlock:^(NSString *name, NSString *output, NSError* error) {

        if (output)
        {
            NSURL* expectedURL = expected[name];
            [self assertString:output matchesContentsOfURL:expectedURL mode:ECTestComparisonShowLinesIgnoreWhitespace];

#if WRITE_TO_DESKTOP
            NSURL* outputURL = [NSURL fileURLWithPath:[[@"~/Desktop" stringByStandardizingPath] stringByAppendingPathComponent:name]];
            [output writeToURL:outputURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
#endif

        }
        else
        {
            ECTestFail(@"rendering error %@", error);
        }
        
    }];

}

@end
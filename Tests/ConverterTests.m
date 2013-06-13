//
//  ConverterTests.m
//  LibraryTests
//
//  Created by Sam Deane on 06/06/2013.
//  Copyright (c) 2013 Bohemian Coding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <ECUnitTests/ECUnitTests.h>
#import <Coma/Coma.h>

#import "ExampleBasic.h"
#import "CustomClass.h"


@interface ConverterTests : ECTestCase

@end

ECDeclareDebugChannel(ComaEngineChannel);
ECDeclareDebugChannel(ComaTemplatesChannel);
ECDeclareDebugChannel(ComaModelChannel);


@interface ConverterTests()
@property (strong, nonatomic) NSDate* date;
@end

@implementation ConverterTests

+ (void)setUp
{
    // turn on some logging for the tests
    ECEnableChannel(ComaEngineChannel);
    ECEnableChannel(ComaModelChannel);
    ECEnableChannel(ComaTemplatesChannel);
}


- (void)testLoadModel
{
    NSURL* modelURL = [self URLForTestResource:@"SVGModel" withExtension:@"xcdatamodeld" subdirectory:@"Data"];

    BCComaMomConverter* converter = [BCComaMomConverter new];
    NSError* error;
    NSManagedObjectModel* model = [converter loadModel:modelURL error:&error];

    ECTestAssertNotNil(model);
}

- (void)testEnumerateEntities
{
    NSURL* modelURL = [self URLForTestResource:@"SVGModel" withExtension:@"xcdatamodeld" subdirectory:@"Data"];

    BCComaMomConverter* converter = [BCComaMomConverter new];
    NSError* error;
    NSManagedObjectModel* model = [converter loadModel:modelURL error:&error];
    ECTestAssertNotNil(model);

    [converter enumerateEntitiesInModel:model block:^(BCComaMomConverter *converter, NSEntityDescription *entity) {
        NSLog(@"%@", entity.name);
    }];
}

- (void)testInfoForModel
{
    NSURL* modelURL = [self URLForTestResource:@"SVGModel" withExtension:@"xcdatamodeld" subdirectory:@"Data"];

    BCComaMomConverter* converter = [BCComaMomConverter new];
    NSError* error;
    NSManagedObjectModel* model = [converter loadModel:modelURL error:&error];
    ECTestAssertNotNil(model);

    NSDictionary* info = [converter infoForModel:model];
    ECTestAssertNotNil(info);

    NSURL* expectedURL = [self URLForTestResource:@"SVGConverted" withExtension:@"json" subdirectory:@"Data"];
    NSData* expectedData = [NSData dataWithContentsOfURL:expectedURL];
    NSDictionary* expected = [NSJSONSerialization JSONObjectWithData:expectedData options:0 error:&error];

    ECTestAssertTrue([info isEqualTo:expected]);

#if WRITE_TO_DESKTOP
    NSURL* outputURL = [NSURL fileURLWithPath:[@"~/Desktop/SVGConverted.json" stringByStandardizingPath]];
    NSData* output = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    [output writeToURL:outputURL atomically:YES];
#endif
}

- (void)testMerging
{
    NSURL* modelURL = [self URLForTestResource:@"SVGModel" withExtension:@"xcdatamodeld" subdirectory:@"Data"];

    BCComaMomConverter* converter = [BCComaMomConverter new];

    NSError* error;
    NSURL* svgURL = [self URLForTestResource:@"svg-base" withExtension:@"json" subdirectory:@"Data"];
    NSData* svgData = [NSData dataWithContentsOfURL:svgURL];
    NSDictionary* svgBase = [NSJSONSerialization JSONObjectWithData:svgData options:0 error:&error];

    NSDictionary* svgMerged = [converter mergeModelAtURL:modelURL into:svgBase];
    ECTestAssertNotNil(svgMerged);

    NSURL* expectedURL = [self URLForTestResource:@"svg" withExtension:@"json" subdirectory:@"Data"];
    NSData* expectedData = [NSData dataWithContentsOfURL:expectedURL];
    NSDictionary* expected = [NSJSONSerialization JSONObjectWithData:expectedData options:0 error:&error];

    ECTestAssertTrue([svgMerged isEqualTo:expected]);

#if WRITE_TO_DESKTOP
    NSURL* outputURL = [NSURL fileURLWithPath:[@"~/Desktop/svg.json" stringByStandardizingPath]];
    NSData* output = [NSJSONSerialization dataWithJSONObject:svgMerged options:NSJSONWritingPrettyPrinted error:&error];
    [output writeToURL:outputURL atomically:YES];
#endif
}
@end
//
//  BCComaCommand.m
//  Coma
//
//  Created by Sam Deane on 13/06/2013.
//  Copyright (c) 2013 Bohemian Coding. All rights reserved.
//

#import "BCComaCommand.h"

@implementation BCComaCommand

- (ECCommandLineResult)outputFileWithName:(NSString*)name engine:(ECCommandLineEngine*)engine URL:(NSURL**)url existing:(NSString *__autoreleasing *)existing
{
    ECAssertNonNil(url);

    ECCommandLineResult result = ECCommandLineResultOK;
    BOOL overwriting = [[engine optionForKey:@"overwriting"] boolValue];
    NSString* outputOption = [[engine optionForKey:@"output"] stringByStandardizingPath];
    NSURL* outputURL = [NSURL fileURLWithPath:outputOption ? outputOption : [@"./" stringByStandardizingPath]];

    NSFileManager* fm = [NSFileManager defaultManager];

    // make intermediate directories if necessary
    NSError* error;
    if (![fm createDirectoryAtURL:outputURL withIntermediateDirectories:YES attributes:nil error:&error])
    {
        result = ECCommandLineResultImplementationReturnedError;
    }

    // does the file exist already? if so, can we overwrite it?
    if (result == ECCommandLineResultOK)
    {
        NSURL* fileURL = [outputURL URLByAppendingPathComponent:name];
        NSString* content = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
        BOOL fileExists = [content length] > 0;
        BOOL okToWrite = overwriting || !fileExists;
        if (okToWrite)
        {
            if (url)
                *url = fileURL;

            if (existing)
                *existing = content;
        }
        else
        {
            NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteFileExistsError userInfo:@{}];
            [engine outputError:error format:@"Could not overwrite %@ -- file already exists. Use option --overwriting to force overwriting.", name];
            result = ECCommandLineResultImplementationReturnedError;
        }
    }

    return result;
}
@end

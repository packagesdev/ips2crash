//
//  IPSReport+Obfuscation.m
//  ips2crash
//
//  Created by stephane on 15/07/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSReport+Obfuscating.h"

#import "IPSCrashSummary+Obfuscating.h"
#import "IPSIncident+Obfuscating.h"

typedef NS_OPTIONS(NSUInteger, IPSStringHint)
{
    IPSStringBinary = 1 << 0,
    IPSStringBundleIdentifier = 1 << 1,
    IPSStringPathComponent = 1 << 2,
};

@interface IPSReportObfuscater : NSObject
{
    NSMutableDictionary * _cachedObfuscations;
}

- (NSString *)obfuscatedNameWithProcessName:(NSString *)inProcessName;

- (NSString *)obfuscatedIdentifierWithIdentifier:(NSString *)inBundleIdentifier;

@end

@implementation IPSReportObfuscater

+ (NSMutableDictionary *)defaultCachedObfuscations
{
    return [NSMutableDictionary dictionaryWithDictionary:@{
                                                           @"Contents":@"Contents",
                                                           @"MacOS":@"MacOS",
                                                           @"Library":@"Library",
                                                           @"Resources":@"Resources",
                                                           @"Plugins":@"Plugins",
                                                           @"Frameworks":@"Frameworks"
              }];
}

- (NSString *)generateObfuscatedStringWithHint:(IPSStringHint)inHint
{
    switch(inHint)
    {
        case IPSStringBundleIdentifier:
            
            return @"com.example.";
            
        case IPSStringPathComponent:
            
            return @"";
            
        case IPSStringBinary:
        default:
            
            return @"toto";
    }
}

- (instancetype)init
{
    self=[super init];
    
    if (self!=nil)
    {
        _cachedObfuscations=[IPSReportObfuscater defaultCachedObfuscations];
    }
    
    return self;
}

- (NSString *)obfuscatedStringWithString:(NSString *)inString hint:(IPSStringHint)inHint
{
    NSString * tString=_cachedObfuscations[inString];
    
    if (tString!=nil)
        return tString;
    
    tString=[self generateObfuscatedStringWithHint:inHint];
    
    _cachedObfuscations[inString]=tString;
    
    return tString;
}


- (NSString *)obfuscatedNameWithProcessName:(NSString *)inProcessName
{
    return inProcessName;
}

- (NSString *)obfuscatedIdentifierWithIdentifier:(NSString *)inBundleIdentifier
{
    return inBundleIdentifier;
}

- (IPSIncidentHeader *)obfuscatedIncidentHeaderWithIncidentHeader:(IPSIncidentHeader *)inIncidentHeader
{
    return inIncidentHeader;
}

- (IPSIncident *)obfuscatedIncidentWithIncident:(IPSIncident *)inIncident
{    
    return inIncident;
}

@end

@implementation IPSReport (Obfuscating)

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
    return [[IPSReport alloc] initWithSummary:[((IPSCrashSummary *)self.summary) obfuscateWithObfuscator:inObfuscator]
                                     incident:[self.incident obfuscateWithObfuscator:inObfuscator]];
}

@end

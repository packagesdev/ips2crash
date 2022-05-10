//
//  IPSSummarySerialization.m
//  ips2crash
//
//  Created by stephane on 24/04/2022.
//  Copyright © 2022 Whitebox. All rights reserved.
//

#import "IPSSummarySerialization.h"

#import "IPSError.h"

#import "IPSObjectProtocol.h"

#import "IPSCrashSummary.h"

NSString * const IPSSummarySerializationBugTypeKey=@"bug_type";

@implementation IPSSummarySerialization

#pragma mark -

+ (IPSSummary *)summaryWithData:(NSData *)inData error:(out NSError **)outError
{
    if ([inData isKindOfClass:[NSData class]]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:nil];
        
        return nil;
    }
    
    NSError * tError;
    
    NSDictionary * tSummaryDictionary=[NSJSONSerialization JSONObjectWithData:inData options:NSJSONReadingAllowFragments error:&tError];
    
    if ([tSummaryDictionary isKindOfClass:[NSDictionary class]]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationInvalidTypeOfValueError userInfo:nil];
        
        return nil;
    }
    
    NSString * tString=tSummaryDictionary[IPSSummarySerializationBugTypeKey];
    
    IPSFullCheckStringValueForKey(tString,IPSSummarySerializationBugTypeKey);
    
    NSNumber *tNumber=@([tString integerValue]);
    
    static NSDictionary * sClassesRegistry=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sClassesRegistry=@{
                           @(IPSBugTypeCrash):[IPSCrashSummary class]
                           };
    });
    
    Class tClass=sClassesRegistry[tNumber];
    
    if (tClass==nil)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:IPSErrorDomain
                                          code:IPSUnsupportedBugTypeError
                                      userInfo:@{IPSBugTypeErrorKey:tNumber}];
    }
    
    IPSSummary * tSummary=[[tClass alloc] initWithRepresentation:tSummaryDictionary error:&tError];
    
    if (tSummary==nil)
    {
        if (outError!=NULL)
            *outError=tError;
    }
    
    return tSummary;
}

@end

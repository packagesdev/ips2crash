/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSSummarySerialization.h"

#import "IPSError.h"

#import "IPSObjectProtocol.h"

#import "IPSCrashSummary.h"

NSString * const IPSSummarySerializationBugTypeKey=@"bug_type";

@implementation IPSSummarySerialization

#pragma mark -

+ (IPSSummary *)summaryWithData:(NSData *)inData error:(out NSError **)outError
{
    if ([inData isKindOfClass:NSData.class]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:nil];
        
        return nil;
    }
    
    NSError * tError;
    
    NSDictionary * tSummaryDictionary=[NSJSONSerialization JSONObjectWithData:inData options:NSJSONReadingAllowFragments error:&tError];
    
    if ([tSummaryDictionary isKindOfClass:NSDictionary.class]==NO)
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
                           @(IPSBugTypeCrash):IPSCrashSummary.class
                           };
    });
    
    Class tClass=sClassesRegistry[tNumber];
    
    if (tClass==nil)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:IPSErrorDomain
                                          code:IPSUnsupportedBugTypeError
                                      userInfo:@{IPSBugTypeErrorKey:tNumber}];
        
        return nil;
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

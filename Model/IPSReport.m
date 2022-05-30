/*
 Copyright (c) 2021-2022, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSReport.h"

#import "IPSSummarySerialization.h"

@interface IPSReport ()

    @property (readwrite) IPSSummary * summary;

    @property (readwrite) IPSIncident * incident;

@end

@implementation IPSReport

- (instancetype)initWithContentsOfURL:(NSURL *)inURL error:(out NSError **)outError
{
    if ([inURL isKindOfClass:[NSURL class]]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:nil];
        
        return nil;
    }
    
    NSError * tError=nil;
    NSData * tData=[NSData dataWithContentsOfURL:inURL options:0 error:&tError];
    
    if (tData==nil)
    {
        if (outError!=NULL)
            *outError=tError;
        
        return nil;
    }
    
    return [self initWithData:tData error:outError];
}

- (instancetype)initWithContentsOfFile:(NSString *)inPath error:(out NSError **)outError
{
    if ([inPath isKindOfClass:[NSString class]]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:nil];
        
        return nil;
    }
    
    NSError * tError=nil;
    NSData * tData=[NSData dataWithContentsOfFile:inPath options:0 error:&tError];
    
    if (tData==nil)
    {
        if (outError!=NULL)
            *outError=tError;
        
        return nil;
    }
    
    return [self initWithData:tData error:outError];
}

- (instancetype)initWithData:(NSData *)inData error:(out NSError **)outError;
{
    if ([inData isKindOfClass:[NSData class]]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:nil];
        
        return nil;
    }
    
    NSString * tString=[[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding];
    
    if (tString==nil)
    {
        if (outError!=NULL)
            *outError=nil;  // A COMPLETER
        
        return nil;
    }
    
    return [self initWithString:tString error:outError];
}

- (instancetype)initWithString:(NSString *)inString error:(out NSError **)outError;
{
    if ([inString isKindOfClass:[NSString class]]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:NSPOSIXErrorDomain code:EINVAL userInfo:nil];
        
        return nil;
    }
    
    self=[super init];
    
    if (self!=nil)
    {
        NSError * tError=nil;
        
        NSRange tRange=[inString lineRangeForRange:NSMakeRange(0,1)];
        
        if (tRange.location==NSNotFound)
        {
            if (outError!=NULL)
                *outError=[NSError errorWithDomain:IPSErrorDomain
                                              code:IPSSummaryReadCorruptError
                                          userInfo:@{}];
            
            return nil;
        }
        
        // Summary
        
        NSString * tFirstLine=[inString substringWithRange:tRange];

        if (tFirstLine==nil)
        {
            if (outError!=NULL)
                *outError=[NSError errorWithDomain:IPSErrorDomain
                                              code:IPSSummaryReadCorruptError
                                          userInfo:@{}];
            
            return nil;
        }
        
        _summary=[IPSSummarySerialization summaryWithData:[tFirstLine dataUsingEncoding:NSUTF8StringEncoding] error:&tError];
        
        if (_summary==nil)
        {
            if (outError!=NULL)
                *outError=tError;
            
            return nil;
        }
        
        if (_summary.bugType!=IPSBugTypeCrash)
        {
            if (outError!=NULL)
                *outError=[NSError errorWithDomain:IPSErrorDomain
                                              code:IPSUnsupportedBugTypeError
                                          userInfo:@{IPSBugTypeErrorKey:@(_summary.bugType)}];
            
            return nil;
        }
        
        // Incident
        
        NSString * tIncidentString=[inString substringFromIndex:NSMaxRange(tRange)];
        
        if (tIncidentString==nil)
        {
            NSString * tPathError=@"{Summary}";
            
            if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
                tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];
            
            if (outError!=NULL)
                *outError=[NSError errorWithDomain:IPSErrorDomain
                                              code:tError.code
                                          userInfo:@{IPSKeyPathErrorKey:tPathError}];
            
            return nil;
        }
        
        NSData * tIncidentData=[tIncidentString dataUsingEncoding:NSUTF8StringEncoding];
        
        tError=nil;
        NSDictionary * tIncidentDictionary=[NSJSONSerialization JSONObjectWithData:tIncidentData options:NSJSONReadingAllowFragments error:&tError];
        
        if (tIncidentDictionary==nil)
        {
            if (outError!=NULL)
                *outError=tError;
            
            return nil;
        }
        
        tError=nil;
        _incident=[[IPSIncident alloc] initWithRepresentation:tIncidentDictionary error:&tError];
        
        if (_incident==nil)
        {
            NSString * tPathError=@"{Incident}";
            
            if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
                tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];
            
            if (outError!=NULL)
                *outError=[NSError errorWithDomain:IPSErrorDomain
                                              code:tError.code
                                          userInfo:@{IPSKeyPathErrorKey:tPathError}];
            
            return nil;
        }
    }
    
    return self;
}

@end

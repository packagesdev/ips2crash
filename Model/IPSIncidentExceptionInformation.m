/*
 Copyright (c) 2021, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSIncidentExceptionInformation.h"


NSString * const IPSIncidentExceptionInformationFaultingThreadKey=@"faultingThread";

NSString * const IPSIncidentExceptionInformationLegacyInfoKey=@"legacyInfo";

NSString * const IPSIncidentExceptionInformationExceptionKey=@"exception";

NSString * const IPSIncidentExceptionInformationTerminationKey=@"termination";

NSString * const IPSIncidentExceptionInformationCorpseKey=@"isCorpse";

@interface IPSIncidentExceptionInformation ()

    @property (readwrite) NSUInteger faultingThread;

    @property (readwrite) IPSLegacyInfo * legacyInfo;

    @property (readwrite) IPSException * exception;

    @property (readwrite) IPSTermination * termination;

    @property (readwrite,getter=isCorpse) BOOL corpse;

@end

@implementation IPSIncidentExceptionInformation

- (instancetype)initWithRepresentation:(NSDictionary *)inRepresentation error:(out NSError **)outError
{
    if (inRepresentation==nil)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationNilRepresentationError userInfo:nil];
        
        return nil;
    }
    
    if ([inRepresentation isKindOfClass:[NSDictionary class]]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationInvalidTypeOfValueError userInfo:nil];
        
        return nil;
    }
    
    self=[super init];
    
    if (self!=nil)
    {
        NSNumber * tNumber=inRepresentation[IPSIncidentExceptionInformationFaultingThreadKey];
        
        if ([tNumber isKindOfClass:[NSNumber class]]==NO)
        {
            if (outError!=NULL)
                *outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationInvalidTypeOfValueError userInfo:nil];
            
            return nil;
        }
        
        _faultingThread=[tNumber unsignedIntegerValue];
        
        NSDictionary * tDictionary=inRepresentation[IPSIncidentExceptionInformationExceptionKey];
        
        _exception=[[IPSException alloc] initWithRepresentation:tDictionary error:NULL];
        
        tDictionary=inRepresentation[IPSIncidentExceptionInformationTerminationKey];
        
        _termination=[[IPSTermination alloc] initWithRepresentation:tDictionary error:NULL];
        
        tDictionary=inRepresentation[IPSIncidentExceptionInformationLegacyInfoKey];
        
        _legacyInfo=[[IPSLegacyInfo alloc] initWithRepresentation:tDictionary error:NULL];
        
        tNumber=inRepresentation[IPSIncidentExceptionInformationCorpseKey];
        
        if ([tNumber isKindOfClass:[NSNumber class]]==NO)
        {
            if (outError!=NULL)
                *outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationInvalidTypeOfValueError userInfo:nil];
            
            return nil;
        }
        
        _corpse=[tNumber boolValue];
    }
    
    return self;
}

#pragma mark -

- (NSDictionary *)representation
{
    return @{};
}

@end

/*
 Copyright (c) 2021, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSExternalModificationSummary.h"

NSString * const IPSExternalModificationSummaryCallerKey=@"caller";

NSString * const IPSExternalModificationSummarySystemKey=@"system";

NSString * const IPSExternalModificationSummaryTargeted=@"targeted";

NSString * const IPSExternalModificationSummaryWarningsKey=@"warnings";

@interface IPSExternalModificationSummary ()

    @property (readwrite) IPSExternalModificationStatistics * caller;

    @property (readwrite) IPSExternalModificationStatistics * system;

    @property (readwrite) IPSExternalModificationStatistics * targeted;

    @property (readwrite) NSUInteger warnings;

@end

@implementation IPSExternalModificationSummary

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
        NSDictionary * tDictionary=inRepresentation[IPSExternalModificationSummaryCallerKey];
        
        _caller=[[IPSExternalModificationStatistics alloc] initWithRepresentation:tDictionary error:NULL];
        
        tDictionary=inRepresentation[IPSExternalModificationSummarySystemKey];
        
        _system=[[IPSExternalModificationStatistics alloc] initWithRepresentation:tDictionary error:NULL];
        
        tDictionary=inRepresentation[IPSExternalModificationSummaryTargeted];
        
        _targeted=[[IPSExternalModificationStatistics alloc] initWithRepresentation:tDictionary error:NULL];
        
        NSNumber * tNumber=inRepresentation[IPSExternalModificationSummaryWarningsKey];
        
        IPSFullCheckNumberValueForKey(tNumber,IPSExternalModificationSummaryWarningsKey);
        
        _warnings=[tNumber unsignedIntegerValue];
    }

    return self;
}

#pragma mark -

- (NSDictionary *)representation
{
    return @{
             IPSExternalModificationSummaryCallerKey:[self.caller representation],
             IPSExternalModificationSummarySystemKey:[self.system representation],
             IPSExternalModificationSummaryTargeted:[self.targeted representation],
             IPSExternalModificationSummaryWarningsKey:@(self.warnings)
             };
}

@end

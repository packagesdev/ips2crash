/*
 Copyright (c) 2021, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSIncident.h"

#import "NSArray+WBExtensions.h"

NSString * const IPCIncidentThreadsKey=@"threads";

NSString * const IPSIncidentUsedImagesKey=@"usedImages";

NSString * const IPSIncidentExtModsKey=@"extMods";

NSString * const IPSIncidentVMSummaryKey=@"vmSummary";

@interface IPSIncident ()

    @property (readwrite) IPSIncidentHeader * header;

    @property (readwrite) IPSIncidentExceptionInformation * exceptionInformation;

    @property (readwrite) IPSIncidentDiagnosticMessage * diagnosticMessage;

    @property (readwrite) NSArray<IPSThread *> * threads;

    @property (readwrite) NSArray<IPSImage *> * binaryImages;

    @property (readwrite) IPSExternalModificationSummary * extMods;

    @property (readwrite,copy) NSString * vmSummary;

@end

@implementation IPSIncident

- (instancetype)initWithRepresentation:(NSDictionary *)inRepresentation error:(out NSError **)outError
{
    if ([inRepresentation isKindOfClass:[NSDictionary class]]==NO)
    {
        return nil;
    }
    
    self=[super init];
    
    if (self!=nil)
    {
        _header=[[IPSIncidentHeader alloc] initWithRepresentation:inRepresentation error:NULL];
        
        
        _exceptionInformation=[[IPSIncidentExceptionInformation alloc] initWithRepresentation:inRepresentation error:NULL];
        
        NSArray * tArray=inRepresentation[IPCIncidentThreadsKey];
        
        if ([tArray isKindOfClass:[NSArray class]]==NO)
        {
            return nil;
        }
        
        _threads=[tArray WB_arrayByMappingObjectsUsingBlock:^IPSThread *(NSDictionary * bBThreadRepresentation, NSUInteger bIndex) {
            
            IPSThread * tThread=[[IPSThread alloc] initWithRepresentation:bBThreadRepresentation error:NULL];
            
            return tThread;
        }];
        
        tArray=inRepresentation[IPSIncidentUsedImagesKey];
        
        if ([tArray isKindOfClass:[NSArray class]]==NO)
        {
            return nil;
        }
        
        _binaryImages=[tArray WB_arrayByMappingObjectsUsingBlock:^IPSImage *(NSDictionary * bBinaryImageRepresentation, NSUInteger bIndex) {
            
            IPSImage * tBinaryImage=[[IPSImage alloc] initWithRepresentation:bBinaryImageRepresentation error:NULL];
            
            return tBinaryImage;
        }];
        
        NSDictionary * tDictionary=inRepresentation[IPSIncidentExtModsKey];
        
        _extMods=[[IPSExternalModificationSummary alloc] initWithRepresentation:tDictionary error:NULL];
        
        NSString * tString=inRepresentation[IPSIncidentVMSummaryKey];
        
        if ([tString isKindOfClass:[NSString class]]==NO)
        {
            if (outError!=NULL)
                *outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationInvalidTypeOfValueError userInfo:nil];
            
            return nil;
        }
        
        _vmSummary=[tString copy];
    }
    
    return self;
}

#pragma mark -

- (NSDictionary *)representation
{
    return @{};
}

@end

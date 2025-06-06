/*
 Copyright (c) 2021-2025, Stephane Sudre
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
    if ([inRepresentation isKindOfClass:NSDictionary.class]==NO)
    {
        return nil;
    }
    
    self=[super init];
    
    if (self!=nil)
    {
        NSError * tError=nil;
        
        _header=[[IPSIncidentHeader alloc] initWithRepresentation:inRepresentation error:&tError];
        
        if (_header==nil)
        {
            if (outError!=NULL)
                *outError=tError;
            
            return nil;
        }
        
        tError=nil;
        _exceptionInformation=[[IPSIncidentExceptionInformation alloc] initWithRepresentation:inRepresentation error:&tError];
        
        if (_exceptionInformation==nil)
        {
            if (outError!=NULL)
                *outError=tError;
            
            return nil;
        }
        
        tError=nil;
        _diagnosticMessage=[[IPSIncidentDiagnosticMessage alloc] initWithRepresentation:inRepresentation error:&tError];
        
        NSArray * tArray=inRepresentation[IPCIncidentThreadsKey];
        
        if ([tArray isKindOfClass:NSArray.class]==NO)
        {
            if ([tArray isKindOfClass:NSArray.class]==NO)
            {
                if (outError!=NULL)
                    *outError=[NSError errorWithDomain:IPSErrorDomain
                                                  code:IPSRepresentationInvalidTypeOfValueError
                                              userInfo:@{IPSKeyPathErrorKey:(IPCIncidentThreadsKey)}];
                
                return nil;
            }
        }
		
		__block NSError * tThreadError = nil;
		_threads=[tArray WB_arrayByMappingObjectsUsingBlock:^IPSThread *(NSDictionary * bBThreadRepresentation, NSUInteger bIndex) {
            
			NSError * tError = nil;
			
			IPSThread * tThread=[[IPSThread alloc] initWithRepresentation:bBThreadRepresentation error:&tError];
            
			if (tThread == nil)
			{
				NSString * tPathError=IPCIncidentThreadsKey;
				
				if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
				{
					tPathError=[tPathError stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",bIndex]];
					tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];
				}
				
				tThreadError=[NSError errorWithDomain:IPSErrorDomain
												 code:tError.code
											 userInfo:@{IPSKeyPathErrorKey:tPathError}];
				
				return nil;
			}
			
            return tThread;
        }];
        
		if (_threads==nil)
		{
			if (outError!=NULL)
				*outError=tThreadError;
			
			return nil;
		}
		
        tArray=inRepresentation[IPSIncidentUsedImagesKey];
        
        if (tArray!=nil)
        {
            if ([tArray isKindOfClass:NSArray.class]==NO)
            {
                if (outError!=NULL)
                    *outError=[NSError errorWithDomain:IPSErrorDomain
                                                  code:IPSRepresentationInvalidTypeOfValueError
                                              userInfo:@{IPSKeyPathErrorKey:(IPSIncidentUsedImagesKey)}];
                
                return nil;
            }
            
            _binaryImages=[tArray WB_arrayByMappingObjectsUsingBlock:^IPSImage *(NSDictionary * bBinaryImageRepresentation, NSUInteger bIndex) {
                
                IPSImage * tBinaryImage=[[IPSImage alloc] initWithRepresentation:bBinaryImageRepresentation error:NULL];
                
                return tBinaryImage;
            }];
        }
        
        NSDictionary * tDictionary=inRepresentation[IPSIncidentExtModsKey];
        
        tError=nil;
        _extMods=[[IPSExternalModificationSummary alloc] initWithRepresentation:tDictionary error:&tError];
        
        NSString * tString=inRepresentation[IPSIncidentVMSummaryKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSIncidentVMSummaryKey);
        
            _vmSummary=[tString copy];
        }
    }
    
    return self;
}

#pragma mark -

- (IPSThreadState *)threadState
{
    IPSIncidentExceptionInformation * tExceptionInformation=self.exceptionInformation;
    
    if (tExceptionInformation==nil)
        return nil;
    
    NSUInteger tFaultingThread=tExceptionInformation.faultingThread;
    
    NSArray * tThreads=self.threads;
    
    if (tFaultingThread>=tThreads.count)
        return nil;
    
    IPSThread * tCrashedThread=tThreads[tFaultingThread];
    
    return tCrashedThread.threadState;
}

#pragma mark -

- (NSDictionary *)representation
{
    return @{};
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
    IPSIncident * nIncident=[IPSIncident allocWithZone:inZone];
    
    if (nIncident!=nil)
    {
        nIncident->_header=[self.header copyWithZone:inZone];
        
        nIncident->_exceptionInformation=[self.exceptionInformation copyWithZone:inZone];
        
        nIncident->_diagnosticMessage=[self.diagnosticMessage copyWithZone:inZone];
        
        nIncident->_threads=[self.threads WB_arrayByMappingObjectsUsingBlock:^IPSThread *(IPSThread * bThread, NSUInteger bIndex) {
          
            return [bThread copyWithZone:inZone];
        }];
        
        nIncident->_binaryImages=[self.binaryImages WB_arrayByMappingObjectsUsingBlock:^IPSImage *(IPSImage * bBinaryImage, NSUInteger bIndex) {
            
            return [bBinaryImage copyWithZone:inZone];
        }];
        
        nIncident->_extMods=[self.extMods copyWithZone:inZone];
        
        nIncident->_vmSummary=[self.vmSummary copyWithZone:inZone];
    }
    
    return nIncident;
}

@end

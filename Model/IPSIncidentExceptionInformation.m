/*
 Copyright (c) 2021-2025, Stephane Sudre
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

NSString * const IPSIncidentExceptionInformationExceptionReasonKey=@"exceptionReason";

NSString * const IPSIncidentExceptionInformationLastExceptionBacktraceKey=@"lastExceptionBacktrace";

NSString * const IPSIncidentExceptionInformationTerminationKey=@"termination";

NSString * const IPSIncidentExceptionInformationCorpseKey=@"isCorpse";

NSString * const IPSIncidentExceptionInformationCorpseOldKey=@"is_corpse";


@interface IPSIncidentExceptionInformation ()

    @property (readwrite) NSUInteger faultingThread;

    @property (readwrite) IPSLegacyInfo * legacyInfo;

    @property (readwrite) IPSException * exception;

	@property (readwrite, nullable) IPSExceptionReason * exceptionReason;

	@property (readwrite, nullable) NSArray<IPSThreadFrame *> * lastExceptionBacktrace;

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
    
    if ([inRepresentation isKindOfClass:NSDictionary.class]==NO)
    {
        if (outError!=NULL)
            *outError=[NSError errorWithDomain:IPSErrorDomain code:IPSRepresentationInvalidTypeOfValueError userInfo:nil];
        
        return nil;
    }
    
    self=[super init];
    
    if (self!=nil)
    {
        NSError * tError=nil;
        NSNumber * tNumber=inRepresentation[IPSIncidentExceptionInformationFaultingThreadKey];
        
        if (tNumber==nil)
        {
            // Support for older .ips format to add
        }
        else
        {
            IPSClassCheckNumberValueForKey(tNumber,IPSIncidentExceptionInformationFaultingThreadKey);
        }
        
        _faultingThread=[tNumber unsignedIntegerValue];
        
       
        NSDictionary * tDictionary=inRepresentation[IPSIncidentExceptionInformationExceptionKey];
        
        _exception=[[IPSException alloc] initWithRepresentation:tDictionary error:&tError];
        
        if (_exception==nil)
        {
            NSString * tPathError=IPSIncidentExceptionInformationExceptionKey;
            
            if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
                tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];
            
            if (outError!=NULL)
                *outError=[NSError errorWithDomain:IPSErrorDomain
                                              code:tError.code
                                          userInfo:@{IPSKeyPathErrorKey:tPathError}];
            
            return nil;
        }
		
		tError=nil;
		tDictionary=inRepresentation[IPSIncidentExceptionInformationExceptionReasonKey];
		
		if (tDictionary!=nil)
		{
			_exceptionReason=[[IPSExceptionReason alloc] initWithRepresentation:tDictionary error:&tError];
			
			if (_exceptionReason==nil)
			{
				NSString * tPathError=IPSIncidentExceptionInformationExceptionReasonKey;
				
				if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
					tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];
				
				if (outError!=NULL)
					*outError=[NSError errorWithDomain:IPSErrorDomain
												  code:tError.code
											  userInfo:@{IPSKeyPathErrorKey:tPathError}];
				
				return nil;
			}
		}
		
		NSArray<NSDictionary *> * tArray=inRepresentation[IPSIncidentExceptionInformationLastExceptionBacktraceKey];
		
		if ([tArray isKindOfClass:NSArray.class]==YES)
		{
			NSMutableArray<IPSThreadFrame *> *tBacktrace=[NSMutableArray array];
			
			for(NSDictionary *tFrameRepresentation in tArray)
			{
				IPSThreadFrame * tFrame=[[IPSThreadFrame alloc] initWithRepresentation:tFrameRepresentation error:&tError];
				
				if (tFrame==nil)
				{
					/*NSString * tPathError=IPSIncidentExceptionInformationLastExceptionBacktraceKey;
					
					if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
						tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];
					
					if (outError!=NULL)
						*outError=[NSError errorWithDomain:IPSErrorDomain
													  code:tError.code
												  userInfo:@{IPSKeyPathErrorKey:tPathError}];*/
					
					return nil;
				}
				
				[tBacktrace addObject:tFrame];
			}
			
			_lastExceptionBacktrace=[tBacktrace copy];
		}
        
        tError=nil;
        tDictionary=inRepresentation[IPSIncidentExceptionInformationTerminationKey];
        
        if (tDictionary!=nil)
        {
            _termination=[[IPSTermination alloc] initWithRepresentation:tDictionary error:&tError];
        
            if (_termination==nil)
            {
                NSString * tPathError=IPSIncidentExceptionInformationTerminationKey;
                
                if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
                    tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];
                
                if (outError!=NULL)
                    *outError=[NSError errorWithDomain:IPSErrorDomain
                                                  code:tError.code
                                              userInfo:@{IPSKeyPathErrorKey:tPathError}];
                
                return nil;
            }
        }
        
        tDictionary=inRepresentation[IPSIncidentExceptionInformationLegacyInfoKey];
        
        tError=nil;
        
        if (tDictionary!=nil)
        {
            _legacyInfo=[[IPSLegacyInfo alloc] initWithRepresentation:tDictionary error:&tError];
        
            if (_legacyInfo==nil)
            {
                NSString * tPathError=IPSIncidentExceptionInformationLegacyInfoKey;
                
                if (tError.userInfo[IPSKeyPathErrorKey]!=nil)
                    tPathError=[tPathError stringByAppendingPathComponent:tError.userInfo[IPSKeyPathErrorKey]];
                
                if (outError!=NULL)
                    *outError=[NSError errorWithDomain:IPSErrorDomain
                                                  code:tError.code
                                              userInfo:@{IPSKeyPathErrorKey:tPathError}];
                
                return nil;
            }
        }
        
        tNumber=inRepresentation[IPSIncidentExceptionInformationCorpseOldKey];
        
        if (tNumber!=nil)
        {
            IPSClassCheckNumberValueForKey(tNumber,IPSIncidentExceptionInformationCorpseOldKey);
        }
        else
        {
            tNumber=inRepresentation[IPSIncidentExceptionInformationCorpseKey];
            
            if (tNumber!=nil)
                IPSClassCheckNumberValueForKey(tNumber,IPSIncidentExceptionInformationCorpseKey);
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

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
    IPSIncidentExceptionInformation * nIncidentExceptionInformation=[IPSIncidentExceptionInformation allocWithZone:inZone];
    
    if (nIncidentExceptionInformation!=nil)
    {
        nIncidentExceptionInformation->_faultingThread=self.faultingThread;
        
        nIncidentExceptionInformation->_legacyInfo=[self.legacyInfo copyWithZone:inZone];
        
        nIncidentExceptionInformation->_exception=[self.exception copyWithZone:inZone];
		
		nIncidentExceptionInformation->_exceptionReason=[self.exceptionReason copyWithZone:inZone];
		
		nIncidentExceptionInformation->_lastExceptionBacktrace=[self.lastExceptionBacktrace copyWithZone:inZone];
        
        nIncidentExceptionInformation->_termination=[self.termination copyWithZone:inZone];
        
        nIncidentExceptionInformation->_corpse=self.isCorpse;
    }
    
    return nIncidentExceptionInformation;
}

@end

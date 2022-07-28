/*
 Copyright (c) 2021, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSRegisterState.h"

NSString * const IPSRegisterStateValueKey=@"value";

NSString * const IPSRegisterStateSymbolKey=@"symbol";

NSString * const IPSRegisterStateSymbolLocationKey=@"symbolLocation";

NSString * const IPSRegisterStateSourceFileKey=@"sourceFile";

NSString * const IPSRegisterStateSourceLineKey=@"sourceLine";

NSString * const IPSRegisterStateMatchesCrashFrameKey=@"matchesCrashFrane";

NSString * const IPSRegisterStateDescriptionKey=@"description";

@interface IPSRegisterState ()

    @property (readwrite) NSUInteger value;

    @property (readwrite,copy) NSString * symbol;    // can be nil

    @property (readwrite) NSUInteger symbolLocation;

    @property (readwrite,copy) NSString * sourceFile;    // can be nil

    @property (readwrite) NSUInteger sourceLine;

    @property (readwrite) BOOL matchesCrashFrame;

    @property (readwrite,copy) NSString * r_description;    // can be nil

@end

@implementation IPSRegisterState

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
        NSNumber * tNumber=inRepresentation[IPSRegisterStateValueKey];
        
        IPSFullCheckNumberValueForKey(tNumber,IPSRegisterStateValueKey);
        
        _value=[tNumber unsignedIntegerValue];
        
        NSString * tString=inRepresentation[IPSRegisterStateSymbolKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSRegisterStateSymbolKey);
            
            _symbol=[tString copy];
            
            tNumber=inRepresentation[IPSRegisterStateSymbolLocationKey];
            
            IPSFullCheckNumberValueForKey(tNumber,IPSRegisterStateSymbolLocationKey);
            
            _symbolLocation=[tNumber unsignedIntegerValue];
        }
        
        tString=inRepresentation[IPSRegisterStateSourceFileKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSRegisterStateSourceFileKey);
            
            _sourceFile=[tString copy];
            
            tNumber=inRepresentation[IPSRegisterStateSourceLineKey];
            
            IPSFullCheckNumberValueForKey(tNumber,IPSRegisterStateSourceLineKey);
            
            _sourceLine=[tNumber unsignedIntegerValue];
        }
        
        tNumber=inRepresentation[IPSRegisterStateMatchesCrashFrameKey];
        
        if (tNumber!=nil)
        {
            IPSClassCheckNumberValueForKey(tNumber,IPSRegisterStateMatchesCrashFrameKey);
            
            _matchesCrashFrame=[tNumber boolValue];
        }
        
        tString=inRepresentation[IPSRegisterStateDescriptionKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSRegisterStateDescriptionKey);
            
            _r_description=[tString copy];
        }
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
    IPSRegisterState * nRegisterState=[IPSRegisterState allocWithZone:inZone];
    
    if (nRegisterState!=nil)
    {
        nRegisterState->_value=self.value;
        
        nRegisterState->_symbol=[self.symbol copyWithZone:inZone];
        
        nRegisterState->_symbolLocation=self.symbolLocation;
        
        nRegisterState->_sourceFile=[self.sourceFile copyWithZone:inZone];
        
        nRegisterState->_sourceLine=self.sourceLine;
        
        nRegisterState->_matchesCrashFrame=self.matchesCrashFrame;
        
        nRegisterState->_r_description=[self.r_description copyWithZone:inZone];
    }
    
    return nRegisterState;
}

@end

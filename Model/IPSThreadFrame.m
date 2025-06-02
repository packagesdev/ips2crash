/*
 Copyright (c) 2021-2025, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSThreadFrame.h"

NSString * const IPSThreadFrameImageIndexKey=@"imageIndex";

NSString * const IPSThreadFrameImageOffsetKey=@"imageOffset";

NSString * const IPSThreadFrameSymbolNameKey=@"symbol";

NSString * const IPSThreadFrameSymbolLocationKey=@"symbolLocation";

NSString * const IPSThreadFrameSourceFileKey=@"sourceFile";

NSString * const IPSThreadFrameSourceLineKey=@"sourceLine";

@interface IPSThreadFrame ()

    @property (readwrite) NSUInteger imageIndex;

    @property (readwrite) NSUInteger imageOffset;

    @property (readwrite,copy) NSString * symbol;    // can be nil

    @property (readwrite) NSUInteger symbolLocation;

    @property (readwrite,copy) NSString * sourceFile;    // can be nil

    @property (readwrite) NSUInteger sourceLine;

@end

@implementation IPSThreadFrame

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
        NSNumber * tNumber=inRepresentation[IPSThreadFrameImageIndexKey];
        
        IPSFullCheckNumberValueForKey(tNumber,IPSThreadFrameImageIndexKey);
        
        _imageIndex=[tNumber unsignedIntegerValue];
        
        tNumber=inRepresentation[IPSThreadFrameImageOffsetKey];
        
        IPSFullCheckNumberValueForKey(tNumber,IPSThreadFrameImageOffsetKey);
        
        _imageOffset=[tNumber unsignedIntegerValue];
        
        NSString * tString=inRepresentation[IPSThreadFrameSymbolNameKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSThreadFrameSymbolNameKey);
        
            _symbol=[tString copy];
            
            tNumber=inRepresentation[IPSThreadFrameSymbolLocationKey];
            
            IPSFullCheckNumberValueForKey(tNumber,IPSThreadFrameSymbolLocationKey);
                
            _symbolLocation=[tNumber unsignedIntegerValue];
        }
        
        tString=inRepresentation[IPSThreadFrameSourceFileKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSThreadFrameSourceFileKey);
            
            _sourceFile=[tString copy];
            
            tNumber=inRepresentation[IPSThreadFrameSourceLineKey];
            
            IPSFullCheckNumberValueForKey(tNumber,IPSThreadFrameSourceLineKey);
            
            _sourceLine=[tNumber unsignedIntegerValue];
        }
    }
    
    return self;
}

#pragma mark -

- (NSDictionary *)representation
{
    NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
    
    tMutableDictionary[IPSThreadFrameImageIndexKey]=@(self.imageIndex);
    tMutableDictionary[IPSThreadFrameImageOffsetKey]=@(self.imageOffset);
    
    if (self.symbol!=nil)
    {
        tMutableDictionary[IPSThreadFrameSymbolNameKey]=self.symbol;
    
        tMutableDictionary[IPSThreadFrameSymbolLocationKey]=@(self.symbolLocation);
    }
    
    if (self.sourceFile!=nil)
    {
        tMutableDictionary[IPSThreadFrameSourceFileKey]=self.sourceFile;
        
        tMutableDictionary[IPSThreadFrameSourceLineKey]=@(self.sourceLine);
    }
    
    return [tMutableDictionary copy];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
    IPSThreadFrame * nThreadFrame=[IPSThreadFrame allocWithZone:inZone];
    
    if (nThreadFrame!=nil)
    {
        nThreadFrame->_imageIndex=self.imageIndex;
        
        nThreadFrame->_imageOffset=self.imageOffset;
        
        nThreadFrame->_symbol=[self.symbol copyWithZone:inZone];
        
        nThreadFrame->_symbolLocation=self.symbolLocation;
        
        nThreadFrame->_sourceFile=[self.sourceFile copyWithZone:inZone];
        
        nThreadFrame->_sourceLine=self.sourceLine;
    }
    
    return nThreadFrame;
}

@end

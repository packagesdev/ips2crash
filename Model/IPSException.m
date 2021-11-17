/*
 Copyright (c) 2021, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSException.h"

NSString * const IPSExceptionTypeKey=@"type";

NSString * const IPSExceptionSubtypeKey=@"subtype";

NSString * const IPSExceptionSignalKey=@"signal";

NSString * const IPSExceptionCodesKey=@"codes";

NSString * const IPSExceptionRawCodesKey=@"rawCodes";

@interface IPSException ()

    @property (readwrite,copy) NSString * type;

    @property (readwrite,copy) NSString * subtype;

    @property (readwrite,copy) NSString * signal;

    @property (readwrite,copy) NSString * codes;

    @property (readwrite) NSArray<NSNumber *> * rawCodes;

@end

@implementation IPSException

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
        NSString * tString=inRepresentation[IPSExceptionTypeKey];
        
        IPSFullCheckStringValueForKey(tString,IPSExceptionTypeKey);
        
        _type=[tString copy];
        
        tString=inRepresentation[IPSExceptionSubtypeKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSExceptionSubtypeKey);
        
            _subtype=[tString copy];
        }
        
        tString=inRepresentation[IPSExceptionSignalKey];
        
        IPSFullCheckStringValueForKey(tString,IPSExceptionSignalKey);
        
        _signal=[tString copy];
        
        tString=inRepresentation[IPSExceptionCodesKey];
        
        IPSFullCheckStringValueForKey(tString,IPSExceptionCodesKey);
        
        _codes=[tString copy];
        
        NSArray * tArray=inRepresentation[IPSExceptionRawCodesKey];
        
        if (tArray!=nil)
        {
            IPSClassCheckArrayValueForKey(tArray,IPSExceptionRawCodesKey);
        
            _rawCodes=[tArray copy];
        }
    }
    
    return self;
}

#pragma mark -

- (NSDictionary *)representation
{
    NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                             IPSExceptionTypeKey:self.type,
                                                                                             IPSExceptionSignalKey:self.signal,
                                                                                             IPSExceptionCodesKey:self.codes,
                                                                                             }];
    
    if (self.subtype!=nil)
        tMutableDictionary[IPSExceptionSubtypeKey]=self.subtype;
    
    if (self.rawCodes!=nil)
        tMutableDictionary[IPSExceptionRawCodesKey]=self.rawCodes;
    
    return [tMutableDictionary copy];
}

@end

/*
 Copyright (c) 2021, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSBundleInfo.h"

NSString * const IPSBundleInfoBundleShortVersionStringKey=@"CFBundleShortVersionString";

NSString * const IPSBundleInfoBundleVersionKey=@"CFBundleVersion";

NSString * const IPSBundleInfoBundleIdentifierKey=@"CFBundleIdentifier";

@interface IPSBundleInfo ()

    @property (readwrite,copy) NSString * bundleShortVersionString;

    @property (readwrite,copy) NSString * bundleVersion;

    @property (readwrite,copy) NSString * bundleIdentifier;

@end

@implementation IPSBundleInfo

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
        NSString * tString=inRepresentation[IPSBundleInfoBundleShortVersionStringKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSBundleInfoBundleShortVersionStringKey);
            
            _bundleShortVersionString=[tString copy];
        }
        
        tString=inRepresentation[IPSBundleInfoBundleVersionKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSBundleInfoBundleVersionKey);
            
            _bundleVersion=[tString copy];
        }
        
        tString=inRepresentation[IPSBundleInfoBundleIdentifierKey];
        
        if (tString!=nil)
        {
            IPSClassCheckStringValueForKey(tString,IPSBundleInfoBundleIdentifierKey);
            
            _bundleIdentifier=[tString copy];
        }
    }
    
    return self;
}

#pragma mark -

- (NSDictionary *)representation
{
    NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
    
    if (self.bundleShortVersionString!=nil)
        tMutableDictionary[IPSBundleInfoBundleShortVersionStringKey]=self.bundleShortVersionString;
    
    if (self.bundleVersion!=nil)
        tMutableDictionary[IPSBundleInfoBundleVersionKey]=self.bundleVersion;
    
    if (self.bundleIdentifier!=nil)
        tMutableDictionary[IPSBundleInfoBundleIdentifierKey]=self.bundleIdentifier;
    
    return [tMutableDictionary copy];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)inZone
{
    IPSBundleInfo * nBundleInfo=[IPSBundleInfo allocWithZone:inZone];
    
    if (nBundleInfo!=nil)
    {
        nBundleInfo->_bundleShortVersionString=[self.bundleShortVersionString copyWithZone:inZone];
        
        nBundleInfo->_bundleVersion=[self.bundleVersion copyWithZone:inZone];
        
        nBundleInfo->_bundleIdentifier=[self.bundleIdentifier copyWithZone:inZone];
    }
    
    return nBundleInfo;
}

@end

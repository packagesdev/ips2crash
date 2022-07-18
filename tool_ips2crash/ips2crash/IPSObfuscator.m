/*
 Copyright (c) 2022, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSObfuscator.h"

#import "NSArray+WBExtensions.h"

typedef NS_ENUM(NSUInteger, IPSComponentFamily)
{
    IPSComponentBinary,
    IPSComponentCompanyName,
    IPSComponentBundleIdentifier,
    IPSComponentPathComponent,
    IPSComponentQueueName,
    IPSComponentThreadName,
    IPSComponentObjCClassName,
    IPSComponentObjCMethod,
};

@interface IPSObfuscator ()
{
    NSMutableDictionary * _sharedObjects;
}

@end

@implementation IPSObfuscator

- (instancetype)init
{
    self=[super init];
    
    if (self!=nil)
    {
        _sharedObjects=[NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark -

- (id)sharedObjectForKey:(NSString *)inKey
{
    return _sharedObjects[inKey];
}

- (void)setSharedObject:(id)inObject forKey:(NSString *)inKey
{
    _sharedObjects[inKey]=inObject;
}

#pragma mark -

- (NSString *)sharedObfuscatedComponentWithComponent:(NSString *)inComponent family:(IPSComponentFamily)inFamily
{
    static NSMutableDictionary<NSString *,NSString *> * _cachedObfuscatedComponents=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cachedObfuscatedComponents=[NSMutableDictionary dictionary];
    });
    
    NSString * tObfuscatedString=_cachedObfuscatedComponents[inComponent];
    
    if (tObfuscatedString==nil)
    {
        tObfuscatedString=[NSUUID UUID].UUIDString;
        
        // A COMPLETER
        
        _cachedObfuscatedComponents[inComponent]=tObfuscatedString;
    }
    
    return @"COMPONENT";
    
    //return tObfuscatedString;
}

- (NSString *)obfuscatedBinaryWithBinary:(NSString *)inBinary
{
    if (inBinary==nil)
        return nil;
    
    static NSMutableDictionary<NSString *,NSString *> * sCachedObfuscatedBinaries=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sCachedObfuscatedBinaries=[@{
                                           @"launchd":@"launchd",
                                           } mutableCopy];
    });
    
    NSString * tObfuscatedBinary=sCachedObfuscatedBinaries[inBinary];
    
    if (tObfuscatedBinary==nil)
    {
        tObfuscatedBinary=[self sharedObfuscatedComponentWithComponent:inBinary family:IPSComponentBinary];
        
        sCachedObfuscatedBinaries[inBinary]=tObfuscatedBinary;
    }
    
    return tObfuscatedBinary;
}

- (NSString *)obfuscatedBundleIdentifierComponentWithBundleIdentifierComponent:(NSString *)inBundleIdentifierComponent
{
    static NSMutableDictionary<NSString *,NSString *> * sCachedObfuscatedBundleIdentifierComponents=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sCachedObfuscatedBundleIdentifierComponents=[@{
                                           @"com":@"com",
                                           } mutableCopy];
    });
    
    NSString * tObfuscatedComponent=sCachedObfuscatedBundleIdentifierComponents[inBundleIdentifierComponent];
    
    if (tObfuscatedComponent==nil)
    {
        tObfuscatedComponent=[self sharedObfuscatedComponentWithComponent:inBundleIdentifierComponent family:IPSComponentBundleIdentifier];
        
        sCachedObfuscatedBundleIdentifierComponents[inBundleIdentifierComponent]=tObfuscatedComponent;
    }
    
    return tObfuscatedComponent;
}

- (NSString *)obfuscatedBundleIdentifierWithBundleIdentifier:(NSString *)inBundleIdentifier
{
    if (inBundleIdentifier==nil)
        return nil;
    
    return [[[inBundleIdentifier componentsSeparatedByString:@"."] WB_arrayByMappingObjectsUsingBlock:^NSString *(NSString * bPathComponent, NSUInteger bIndex) {
        
        if (bPathComponent.length==0)
            return bPathComponent;
        
        return [self obfuscatedBundleIdentifierComponentWithBundleIdentifierComponent:bPathComponent];
    }] componentsJoinedByString:@"."];
}

- (NSString *)obfuscatedPathComponentWithPathComponent:(NSString *)inPathComponent
{
    static NSMutableDictionary<NSString *,NSString *> * sCachedObfuscatedPathComponents=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sCachedObfuscatedPathComponents=[@{
                                           @"/":@"/",
                                           @"A":@"A",
                                           @"Applications":@"Applications",
                                           @"Automator":@"Automator",
                                           @"Contents":@"Contents",
                                           @"Current":@"Current",
                                           @"Frameworks":@"Frameworks",
                                           @"LaunchServices":@"LaunchServices",
                                           @"Library":@"Library",
                                           @"MacOS":@"MacOS",
                                           @"Plugins":@"Plugins",
                                           @"QuickLook":@"QuickLook",
                                           @"Resources":@"Resources",
                                           @"Spotlight":@"Spotlight",
                                           @"Utilities":@"Utilities",
                                           @"Versions":@"Versions",
                                           @"XPCServices":@"XPCServices",
                                           } mutableCopy];
    });
    
    NSString * tPathExtension=inPathComponent.pathExtension;
    
    NSString * tKey=inPathComponent.stringByDeletingPathExtension;
    
    NSString * tObfuscatedPathComponent=sCachedObfuscatedPathComponents[tKey];
    
    if (tObfuscatedPathComponent==nil)
    {
        tObfuscatedPathComponent=[self sharedObfuscatedComponentWithComponent:tKey family:IPSComponentPathComponent];
        
        sCachedObfuscatedPathComponents[tKey]=tObfuscatedPathComponent;
    }
    
    return [tObfuscatedPathComponent stringByAppendingPathExtension:tPathExtension];
}

- (NSString *)obfuscatedPathWithPath:(NSString *)inPath
{
    if (inPath==nil)
        return nil;
    
    return [NSString pathWithComponents:[inPath.pathComponents WB_arrayByMappingObjectsUsingBlock:^NSString *(NSString * bPathComponent, NSUInteger bIndex) {
       
        if (bPathComponent.length==0)
            return bPathComponent;
        
        return [self obfuscatedPathComponentWithPathComponent:bPathComponent];
    }]];
}

- (NSString *)obfuscatedQueueWithQueue:(NSString *)inQueue
{
    if (inQueue==nil)
        return nil;
    
    if ([inQueue hasPrefix:@"com.apple."]==YES)
        return [inQueue copy];
    
    // A COMPLETER
    
    return @"QUEUE";
}

- (NSString *)obfuscatedThreadNameWithThreadName:(NSString *)inThreadName
{
    if (inThreadName==nil)
        return nil;
    
    if ([inThreadName hasPrefix:@"com.apple."]==YES)
        return [inThreadName copy];
    
    static NSMutableDictionary<NSString *,NSString *> * sCachedObfuscatedThreadNames=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sCachedObfuscatedThreadNames=[NSMutableDictionary dictionary];
    });
    
    NSString * tObfuscatedThreadName=sCachedObfuscatedThreadNames[inThreadName];
    
    if (tObfuscatedThreadName==nil)
    {
        tObfuscatedThreadName=[self sharedObfuscatedComponentWithComponent:inThreadName family:IPSComponentThreadName];
        
        sCachedObfuscatedThreadNames[inThreadName]=tObfuscatedThreadName;
    }
    
    return tObfuscatedThreadName;
}

- (NSString *)obfuscatedSymbolWithSymbol:(NSString *)inSymbol
{
    if (inSymbol==nil)
        return nil;

    static NSMutableDictionary<NSString *,NSString *> * sCachedObfuscatedSymbols=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sCachedObfuscatedSymbols=[NSMutableDictionary dictionary];
    });
    
    NSString * tObfuscatedSymbol=sCachedObfuscatedSymbols[inSymbol];
    
    if (tObfuscatedSymbol==nil)
    {
        // Decompose the symbol into symbol components (Class, parameter, etc.) as best as we can
        
        NSArray * tComponents=nil;
#warning TO BE COMPLETED
        // A COMPLETER
        
        //[self sharedObfuscatedComponentWithComponent:inThreadName family:IPSComponentThreadName];
        
        sCachedObfuscatedSymbols[inSymbol]=tObfuscatedSymbol;
    }
    
    return @"SYMBOL";
    
    //return tObfuscatedSymbol;

}

#pragma mark -

- (NSString *)obfuscatedStringWithString:(NSString *)inString family:(IPSStringFamily)inFamily
{
    switch(inFamily)
    {
        case IPSStringFamilyBinary:
            
            return [self obfuscatedBinaryWithBinary:inString];
            
        case IPSStringFamilyBundleIdentifier:
            
            return[self obfuscatedBundleIdentifierWithBundleIdentifier:inString];
        
        case IPSStringFamilyPath:
            
            return [self obfuscatedPathWithPath:inString];
            
        case IPSStringFamilyQueue:
            
            return [self obfuscatedQueueWithQueue:inString];
            
        case IPSStringFamilyThreadName:
            
            return [self obfuscatedThreadNameWithThreadName:inString];
        
        case IPSStringFamilySymbol:
            
            return [self obfuscatedSymbolWithSymbol:inString];
            
        default:
            
            return @"default";
    }
}

- (void)finishObfuscating
{
}

@end

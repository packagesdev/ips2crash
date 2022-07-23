/*
 Copyright (c) 2022, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "IPSApplicationSpecificInformation+Obfuscating.h"

#import "IPSObfuscator+Extended.h"

#import "NSArray+WBExtensions.h"

@interface IPSApplicationSpecificInformation (Private)

- (void)setApplicationsInformation:(NSDictionary<NSString *,NSArray<NSString *> *> *)inApplicationsInformation;

- (void)setBacktraces:(NSArray<NSString *> * )inBacktraces;

- (void)setSignatures:(NSArray<NSString *> * )inSignatures;

@end

@implementation IPSApplicationSpecificInformation (Obfuscating)

- (NSString *)obfuscateStackFrame:(NSString *)inStackFrame withObfuscator:(IPSObfuscator *)inObfuscator
{
    NSUInteger tLength=inStackFrame.length;
    NSCharacterSet * tWhitespaceCharacterSet=[NSCharacterSet whitespaceCharacterSet];
    
    NSScanner * tScanner=[NSScanner scannerWithString:inStackFrame];
    
    tScanner.charactersToBeSkipped=tWhitespaceCharacterSet;
    
    NSInteger tFrameIndex=-1;
    
    if ([tScanner scanInteger:&tFrameIndex]==NO)
        return nil;
    
    tScanner.charactersToBeSkipped=[NSCharacterSet characterSetWithCharactersInString:@"\t"];
    
    NSString * tString=nil;
    
    NSUInteger tCurrentScanLocation=tScanner.scanLocation;
    
    if ([tScanner scanUpToString:@"0x" intoString:&tString]==NO)
        return nil;
    
    if (tScanner.scanLocation==tLength)
    {
        // try to find a \t
        
        tScanner.scanLocation=tCurrentScanLocation;
        
        if ([tScanner scanUpToString:@"\t" intoString:&tString]==NO)
            return nil;
    }
    
    NSString *tImageIdentifier=[tString stringByTrimmingCharactersInSet:tWhitespaceCharacterSet];
    
    tScanner.charactersToBeSkipped=tWhitespaceCharacterSet;
    
    unsigned long long tHexaValue=0;
    
    if ([tScanner scanHexLongLong:&tHexaValue]==NO)
        return nil;
    
    NSUInteger tMachineInstructionAddress=tHexaValue;
    
    NSIndexSet * tUserCodeIndexSet=[inObfuscator sharedObjectForKey:@"userCodeIndexSet"];
    
    BOOL tUserCode=([tUserCodeIndexSet containsIndex:tMachineInstructionAddress]==YES);
    
    if ([tScanner scanUpToString:@" +" intoString:&tString]==NO)
        return nil;
    
    NSString * tSymbol=[tString copy];
    
    NSInteger tByteOffset;
    
    if ([tScanner scanInteger:&tByteOffset]==NO)
    {
        if ([tSymbol isEqualToString:@"???"]==NO)
            return nil;
        
        tByteOffset=0;
    }
    
    NSMutableString * tMutableString=[NSMutableString string];
    
    NSString * tFrameIndexString=[NSString stringWithFormat:@"%lu",(unsigned long)tFrameIndex];
    
    NSString * tIndexSpace=[@"    " substringFromIndex:tFrameIndexString.length];
    
    [tMutableString appendFormat:@"%@%@",tFrameIndexString,tIndexSpace];
    
    if (tUserCode==YES)
        tImageIdentifier=[inObfuscator obfuscatedStringWithString:tImageIdentifier family:IPSStringFamilyBinary];
    
    NSUInteger tImageNameLength=tImageIdentifier.length;
    
    if ((tImageNameLength+4)>34)
    {
        [tMutableString appendFormat:@"%@    ",tImageIdentifier];
    }
    else
    {
        NSString * tImageSpace=[@"                                  " substringFromIndex:tImageNameLength];
        
        [tMutableString appendFormat:@"%@%@",tImageIdentifier,tImageSpace];
    }
    
    if (tUserCode==NO)
    {
        [tMutableString appendFormat:@"0x%016lx %@ + %lu",(unsigned long)tMachineInstructionAddress,tSymbol,(unsigned long)tByteOffset];
    }
    else
    {
        [tMutableString appendFormat:@"0x%016lx 0x%lx + %lu",(unsigned long)tMachineInstructionAddress,(unsigned long)(tMachineInstructionAddress-tByteOffset),(unsigned long)tByteOffset];
    }

    return tMutableString;
}

- (id)obfuscateWithObfuscator:(IPSObfuscator *)inObfuscator
{
    IPSApplicationSpecificInformation * nApplicationSpecificInformation=[self copy];
    
    if (nApplicationSpecificInformation!=nil)
    {
        nApplicationSpecificInformation.applicationsInformation=[self.applicationsInformation copy];
        
        nApplicationSpecificInformation.backtraces=[self.backtraces WB_arrayByMappingObjectsUsingBlock:^NSString *(NSString * bBacktrace, NSUInteger bIndex) {
            
            NSMutableArray * tLines=[NSMutableArray array];
            
            [bBacktrace enumerateLinesUsingBlock:^(NSString * bLine, BOOL * bOutStop) {
                
                [tLines addObject:[self obfuscateStackFrame:bLine withObfuscator:inObfuscator]];
            }];
            
            return [tLines componentsJoinedByString:@"\n"];
        }];
        
        nApplicationSpecificInformation.signatures=[self.signatures copy];
    }
    
    return nApplicationSpecificInformation;
}

@end

/*
 Copyright (c) 2021, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

#import "IPSReport.h"

#import "IPSReport+CrashRepresentation.h"

#include <sys/types.h>
#include <unistd.h>
#include <getopt.h>

void usage(void);

void usage(void)
{
    (void)fprintf(stderr, "%s\n","Usage: ips2crash [OPTIONS] file\n"
                  "\n"
                  "Options:\n"
                  "  --output, -o PATH    use this folder as the temporary build folder\n");
    
    exit(EXIT_FAILURE);
}

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        char * tCOutputPath=NULL;
        
        int c;
        
        static struct option tLongOptions[] =
        {
            {"verbose",                        no_argument,        0,    'v'},
            
            {"output",    required_argument,    0,    'o'},
            
            {0, 0, 0, 0}
        };
        
        while (1)
        {
            int tOptionIndex = 0;
            
            c = getopt_long (argc, (char **) argv, "o:",tLongOptions, &tOptionIndex);
            
            /* Detect the end of the options. */
            if (c == -1)
                break;
            
            switch (c)
            {
                case 'o':
                    
                    tCOutputPath=optarg;
                    
                    break;
                    
                case '?':
                default:
                    usage();
                    
                    return EXIT_FAILURE;
            }
        }
        
        argv+=optind;
        argc-=optind;
        
        NSString * tIPSFile=nil;
        NSString * tOutputCrashFile=nil;
        
        NSFileManager * tFileManager=[NSFileManager defaultManager];
        
        NSString * tCurrentDirectory=[tFileManager currentDirectoryPath];
        
        if (tCOutputPath!=NULL)
        {
            tOutputCrashFile=[[NSString stringWithUTF8String:tCOutputPath] stringByStandardizingPath];
            
            if ([tOutputCrashFile characterAtIndex:0]!='/')
                tOutputCrashFile=[tCurrentDirectory stringByAppendingPathComponent:tOutputCrashFile];
        }
        
        if (argc==0 && tOutputCrashFile==nil)
        {
            usage();
            
            return EXIT_FAILURE;
        }
        
        tIPSFile=[NSString stringWithUTF8String:argv[0]];
        
        argv++;
        argc--;
        
        if (argc>0)
        {
            (void)fprintf(stderr, "An error occurred while parsing %s: too many arguments.\n",*argv);
            usage();
            
            return EXIT_FAILURE;
        }
        
        
        NSError * tError=nil;
        IPSReport * tReport=[[IPSReport alloc] initWithContentsOfFile:tIPSFile error:&tError];
        
        if (tReport==nil)
        {
            if ([tError.domain isEqualToString:NSCocoaErrorDomain]==YES)
            {
                switch(tError.code)
                {
                    case NSFileReadNoSuchFileError:
                        
                        (void)fprintf(stderr, "'%s': No such file.\n",tIPSFile.fileSystemRepresentation);
                        
                        break;
                    
                    case NSFileReadNoPermissionError:
                        
                        (void)fprintf(stderr, "'%s': Permission denied.\n",tIPSFile.fileSystemRepresentation);
                        
                        break;
                        
                    default:
                        
                        (void)fprintf(stderr, "'%s': Unable to read file.\n",tIPSFile.fileSystemRepresentation);
                        
                        break;
                }
            }
            else if ([tError.domain isEqualToString:IPSErrorDomain]==YES)
            {
                (void)fprintf(stderr, "'%s': An error occurred when reading the .ips file.\n",tIPSFile.fileSystemRepresentation);
                
                NSString * tKeyPath=tError.userInfo[IPSKeyPathErrorKey];
                
                switch(tError.code)
                {
                    case IPSRepresentationNilRepresentationError:
                        
                        (void)fprintf(stderr, "Missing value for key: %s.\n",tKeyPath.UTF8String);
                        
                        break;
                        
                    case IPSRepresentationInvalidTypeOfValueError:
                        
                        (void)fprintf(stderr, "Invalid type of value for key: %s.\n",tKeyPath.UTF8String);
                        
                        break;
                        
                    case IPSRepresentationInvalidValueError:
                        
                        (void)fprintf(stderr, "Invalid value for key: %s.\n",tKeyPath.UTF8String);
                        
                        break;
                        
                    case IPSSummaryReadCorruptError:
                        
                        (void)fprintf(stderr, "Corrupted ips file.\n");
                        
                        break;
                    
                    case IPSUnsupportedBugTypeError:
                        
                        (void)fprintf(stderr, "Unsupported type of .ips report: %ld.\n",[tError.userInfo[IPSBugTypeErrorKey] integerValue]);
                        
                        break;
                }
            }
            else
            {
                (void)fprintf(stderr, "%s\n",tError.description.UTF8String);
            }
            
            return EXIT_FAILURE;
        }
        
        NSString * tString=[tReport crashTextualRepresentation];
        
        if (tOutputCrashFile==nil)
        {
            (void)fprintf(stdout,"%s",tString.UTF8String);
            
            return EXIT_SUCCESS;
        }
        
        if ([tString writeToFile:tOutputCrashFile atomically:YES encoding:NSUTF8StringEncoding error:&tError]==YES)
            return EXIT_SUCCESS;
        
        (void)fprintf(stderr, "An error occurred when reading the file '%s'.\n",tIPSFile.fileSystemRepresentation);
        
        if ([tError.domain isEqualToString:NSCocoaErrorDomain]==YES)
        {
            // A COMPLETER
        }
        else
        {
            // A COMPLETER
        }
    }
    
    return EXIT_FAILURE;
}

#import <Foundation/Foundation.h>

#import <UniversalDetector/UniversalDetector.h>

int main(int argc,char **argv)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSError *error = nil;
	
	for (int i = 1; i < argc; i++)
	{
		// You need a new detector for each piece of data you want to examine!
		UniversalDetector *detector = [UniversalDetector new];
	
		NSString *filePath = [NSString stringWithUTF8String:argv[i]];
		NSString *fileName = [filePath lastPathComponent];
		
		NSData *data = [NSData dataWithContentsOfFile:filePath
											  options:0
												error:&error];
		
		NSString *str = nil;

		if (data == nil) {
			str = [NSString stringWithFormat:@"%@\n\t%@", fileName, error];
		}

		if (data.length == 0) {
			str = [NSString stringWithFormat:@"%@\n\t%@", fileName, @"Error: empty file!"];
		}
		
		if (str) {
			printf("%s\n\n", [str UTF8String]);
			continue;
		}

		[detector analyzeData:data];
		NSString *MIMECharsetName = [detector MIMECharset];
		NSStringEncoding encoding = [detector encoding];
		
		str = [NSString stringWithFormat:@"%@\n\t\"%@\" (%@) confidence: %.1f%%",
			   fileName,
			   (encoding != 0) ? [NSString localizedNameOfStringEncoding:encoding] : @"UNKNOWN",
			   (MIMECharsetName != nil) ? MIMECharsetName : @"UNKNOWN",
			   ([detector confidence] * 100.0f) 
			   ];
		printf("%s\n\n", [str UTF8String]);
		
	
		[detector release];
	}
	
	[pool release];
	return 0;
}
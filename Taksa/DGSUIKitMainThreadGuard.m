#import <objc/runtime.h>
#import <objc/message.h>

#if defined(DEBUG)

// Compile-time selector checks.
#define PROPERTY(propName) NSStringFromSelector(@selector(propName))

static BOOL DGSReplaceMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block)
{
    NSCParameterAssert(c && origSEL && newSEL && block);
    Method origMethod = class_getInstanceMethod(c, origSEL);
    const char *encoding = method_getTypeEncoding(origMethod);

    // Add the new method.
    IMP impl = imp_implementationWithBlock(block);
    if (!class_addMethod(c, newSEL, impl, encoding))
	{
        NSLog(@"Failed to add method: %@ on %@", NSStringFromSelector(newSEL), c);
        return NO;
    }
	else
	{
        // Ensure the new selector has the same parameters as the existing selector.
        Method newMethod = class_getInstanceMethod(c, newSEL);
        NSCAssert(strcmp(method_getTypeEncoding(origMethod), method_getTypeEncoding(newMethod)) == 0,
				  @"Encoding must be the same.");

        // If original doesn't implement the method we want to swizzle, create it.
        if (class_addMethod(c, origSEL, method_getImplementation(newMethod), encoding))
		{
            class_replaceMethod(c, newSEL, method_getImplementation(origMethod), encoding);
        }
		else
		{
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Tracks down calls to UIKit from a Thread other than Main

static void DGSAssertIfNotMainThread(void)
{
	if ([NSThread isMainThread] == NO)
	{
		NSLog(@"\nERROR: All calls to UIKit need to happen on the main thread. You have a bug in your code. Use dispatch_async(dispatch_get_main_queue(), ^{ ... }); if you're unsure what thread you're in.\n\nBreak on PSPDFAssertIfNotMainThread to find out where.\n\nStacktrace: %@", [NSThread callStackSymbols]);
		abort();
	}
}

// This installs a small guard that checks for the most common threading-errors in UIKit.
// This won't really slow down performance but still only is compiled in DEBUG versions of PSPDFKit.
// \note No private API is used here.
void DGSSetupUIKitMainThreadGuard(void)
{
    @autoreleasepool
	{
        for (NSString *selStr in @[PROPERTY(setNeedsLayout),
								   PROPERTY(setNeedsDisplay),
								   PROPERTY(setNeedsDisplayInRect:)])
		{
            SEL selector = NSSelectorFromString(selStr);
            SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dgs_%@", selStr]);
            if ([selStr hasSuffix:@":"])
			{
                DGSReplaceMethodWithBlock(UIView.class,
										  selector,
										  newSelector,
										  ^(__unsafe_unretained UIView *_self, CGRect r) {
                    DGSAssertIfNotMainThread();
                    ((void ( *)(id, SEL, CGRect))objc_msgSend)(_self, newSelector, r);
                });
            }
			else
			{
                DGSReplaceMethodWithBlock(UIView.class,
										  selector,
										  newSelector,
										  ^(__unsafe_unretained UIView *_self) {
                    DGSAssertIfNotMainThread();
                    ((void ( *)(id, SEL))objc_msgSend)(_self, newSelector);
                });
            }
        }
    }
}

#endif // defined(DEBUG)

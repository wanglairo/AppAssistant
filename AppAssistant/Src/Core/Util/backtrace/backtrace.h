//
//  backtrace.h
//  AppAssistant
//
//  Created by wangbao on 2020/9/30.
//

#ifndef backtrace_h
#define backtrace_h

#include <mach/mach.h>

int df_backtrace(thread_t thread, void** stack, int maxSymbols);

#endif /* backtrace_h */

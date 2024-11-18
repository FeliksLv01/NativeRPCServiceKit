//
//  NativeRPCLog.h
//  NativeRPCServiceKit
//
//  Created by FeliksLv on 2024/11/11.
//

#import <os/log.h>

static os_log_t rpcLog;

__attribute__((constructor))
static void initializeRPCLog() {
    rpcLog = os_log_create("com.itoken.team", "NativeRPCSericeKit");
}

// 日志宏定义
#define RPCLogInfo(format, ...) os_log_info(rpcLog, "[NativeRPCService]: " format, ##__VA_ARGS__)
#define RPCLogError(format, ...) os_log_error(rpcLog, "[NativeRPCService]: " format, ##__VA_ARGS__)
#define RPCLogDebug(format, ...) os_log_debug(rpcLog, "[NativeRPCService]: " format, ##__VA_ARGS__)

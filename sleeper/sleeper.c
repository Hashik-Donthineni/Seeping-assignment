#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#include "include/dart_api.h"
#include "include/dart_api_dl.c"
#include "include/dart_api_dl.h"
#include "include/dart_tools_api.h"
#include "include/dart_version.h"
#include "include/dart_native_api.h"
#include "include/internal/dart_api_dl_impl.h"

#define N 25

pthread_t threads[N];

struct thread_info {
    int64_t id; //Thread ID
    int64_t seconds; //No.of seconds sleep
    Dart_Port native_port; //Dart native port to send data
};

/**
 * Sleeps and calls send_to_dart
 *
 * @param args packed with ID, Seconds
 */
void *thread_sleep(void *args) {
    int64_t id = ((struct thread_info *) args)->id;
    int64_t seconds = ((struct thread_info *) args)->seconds;
    Dart_Port native_port = ((struct thread_info *) args)->native_port;

    // Sleeping for given no.of seconds passed from the Dart code to native code.
    sleep(seconds);

    // Building the message
    Dart_CObject message;
    message.type = Dart_CObject_kInt64;
    message.value.as_int64 =  id;

    // Sending the message through port.
    Dart_PostCObject_DL(native_port, &message);
}

/**
 * Launches a thread to sleep on the thread :)
 *
 * @param id Thread ID
 * @param seconds No.of seconds to sleep
 */
void start_task(int64_t id, int64_t seconds, int64_t port) {
    struct thread_info *info = (struct thread_info *) calloc(1, sizeof(*info));

    info->id = id;
    info->seconds = seconds;
    info->native_port = (Dart_Port) port;
    pthread_create(&threads[id], NULL, &thread_sleep, (void *) info);
}

/**
 * Initializing the native API.
 *
 * @param data NativeApi.initializeApiDLData
 * @return
 */
intptr_t init(void *data){
    return Dart_InitializeApiDL((Dart_InitializeParams *) data);
}
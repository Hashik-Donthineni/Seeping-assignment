#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include "include/dart_api.h"
#include "include/dart_native_api.h"

#define N 25

pthread_t threads[N];

struct thread_info {
    int64_t id; //Thread ID
    int64_t seconds; //No.of seconds sleep
};

/**
 * Sends the ID to Dart via a Websocket. To notify finish.
 *
 * @param id
 */
void send_to_dart(int id){
    int sockfd; // Socket file descriptor

    //Writing the ID to a string.
    char id_string[N];
    sprintf(id_string, "%d", id);

    struct sockaddr_in dart_address;

    // Creating socket FD
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        exit(EXIT_FAILURE);
    }

    memset(&dart_address, 0, sizeof(dart_address));

    // Filling server information
    dart_address.sin_family = AF_INET;
    dart_address.sin_port = htons(4444);
    dart_address.sin_addr.s_addr = INADDR_ANY;

    // Sending to Dart after the sleep.
    sendto(sockfd, (const char *) id_string, strlen(id_string),
           MSG_CONFIRM, (const struct sockaddr *) &dart_address,
           sizeof(dart_address));
}
/**
 * Sleeps and calls send_to_dart
 *
 * @param args packed with ID, Seconds
 */
void *thread_sleep(void *args) {
    int64_t id = ((struct thread_info *) args)->id;
    int64_t seconds = ((struct thread_info *) args)->seconds;

    //Sleeping for given no.of seconds passed from the Dart code to native code.
    sleep(seconds);

    send_to_dart(id);
}

/**
 * Launches a thread to sleep on the thread :)
 *
 * @param id Thread ID
 * @param seconds No.of seconds to sleep
 */
void start_task(int64_t id, int64_t seconds) {
    struct thread_info *info = (struct thread_info *) calloc(1, sizeof(*info));

    info->id = id;
    info->seconds = seconds;
    pthread_create(&threads[id], NULL, &thread_sleep, (void *) info);
}
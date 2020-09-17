# Readme
Working [video](https://youtu.be/vpGDtWfNk8Y) of the project. I added a loading animation to notice any kind of blocking in the UI thread.

Hello Equalitie team! Peter told me the assignment would be the same for me on the 14th at midnight (my time), so I started working on the 15th. I am submitting this a early, in 2 days time (on 16th) in hopes that you folks would let me know if anything needs to be improved before the deadline, like the UI/architecture or the code. There isn't any fancy UI and architecture, just a functional piece of code designed to do the task at hand. Please reach out to me if you folks think I need to implement any architecture, design patter or any UI requirements, before or after the deadline.

For the most part, the assignment is straight forward. I love C, albeit my knowledge is a bit rusty as it has been years the last time I used it, it still is my fav language, and didn't cause any issues. The flutter part of the assignment is straight forward. However, the thing that is a little challenging here is the callback.

# Goals:
- Don't spawn new threads/isolates in Dart as that would kill the purpose of launching another thread to sleep in native.
- Take callback from C code and remove the process from the list in the UI.


## Approach 1: [Failed]
Passing a Dart function and calling the function with function pointer is a straight forward approach but that will not work as the thread is outside the MainUI thread or the isolate it will error with "Cannot invoke native callback outside an isolate."
``` c
struct thread_info{
    int64_t id;
    int64_t seconds;
    void (*func_ptr)(void);
};
void *thread_sleep(void *args){
    void (*function_pointer)();
    ...
    function_pointer = ((struct thread_info*) args) -> func_ptr;
    ...
    sleep(seconds);
    (void) (* function_pointer)(id);
}
void start_task(int64_t id, int64_t seconds, void (*callback)(int64_t)){
    ...
    info ->func_ptr = callback;
    ...
    pthread_create(&threads[id], NULL, &thread_sleep, (void *) info);
}
```
## Approach 2: [Works] Implemented in this test project
Using socket to communicate b/w threads. The relation is 1:N Dart will be listenening to events on Socket while each thread in C will have a Socket to communicate with the Dart's Socket.

## Approach 3: [Works | Suggested] Using the Dart Native Port
## IMPORTANT: Check out "nativeport" branch for this implementation.
- Passing the ReceivePort of dart (as NativePort)
- Setting listener of ReceivePort 
- Using native APIs `Dart_PostCObject_DL` to send the data back to Dart

## Approach 4: [Not Implemented] Polling C from Dart to see if the data is available.
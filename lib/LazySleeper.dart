import 'dart:ffi' as ffi;
import 'dart:io';

import 'dart:isolate';

//Bindings
typedef start_task = ffi.Void Function(ffi.Int64, ffi.Int64);

ffi.DynamicLibrary library = loadSleeperLibrary("sleeper");
final void Function(int, int) startTask =
    library.lookup<ffi.NativeFunction<start_task>>('start_task').asFunction();

class LazySleeper {
  // Callback to main
  Function callBack;

  // ignore: missing_return
  LazySleeper(this.callBack) {
    // Initiating and listening on the Socket.
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 4444)
        .then((RawDatagramSocket communicationSocket) {
      communicationSocket.listen((RawSocketEvent e) {
        Datagram datagram = communicationSocket.receive();
        if (datagram == null) return;

        int processID =
            int.parse(new String.fromCharCodes(datagram.data).trim());
        callBack(processID);
      });
    });
  }

  void startSleeping(int id, int time) {
    print("Starting task: ID: $id for $time seconds");
    startTask(id, time);
  }
}

ffi.DynamicLibrary loadSleeperLibrary(final String libraryName) {
  try {
    return ffi.DynamicLibrary.open("lib$libraryName.so");
  } catch (e) {
    return ffi.DynamicLibrary.process();
  }
}

import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:isolate';

//Bindings
typedef start_task = ffi.Void Function(ffi.Int64, ffi.Int64, ffi.Int64);

ffi.DynamicLibrary library = loadSleeperLibrary("sleeper");
final void Function(int, int, int) startTask =
    library.lookup<ffi.NativeFunction<start_task>>('start_task').asFunction();

final initializeApi = library.lookupFunction<
    ffi.IntPtr Function(ffi.Pointer<ffi.Void>),
    int Function(Pointer<Void>)>("init");

ReceivePort receivePort;

class LazySleeper {
  // Callback to main
  Function callBack;

  // ignore: missing_return
  LazySleeper(this.callBack) {
    if (initializeApi(NativeApi.initializeApiDLData) != 0) {
      print("Failed to initialize native API");
    }

    receivePort = ReceivePort();
    receivePort.listen((message) {
      // Sending a callback to remove the process from the list.
      callBack(message);
    });
  }

  void startSleeping(int id, int time) {
    print("Starting task: ID: $id for $time seconds");
    startTask(id, time, receivePort.sendPort.nativePort);
  }
}

ffi.DynamicLibrary loadSleeperLibrary(final String libraryName) {
  try {
    return ffi.DynamicLibrary.open("lib$libraryName.so");
  } catch (e) {
    return ffi.DynamicLibrary.process();
  }
}

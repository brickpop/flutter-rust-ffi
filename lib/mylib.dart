import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// Use typedef for more readable type definitions below
// typedef greeting_func = Pointer<Utf8> Function(Pointer<Utf8>);

// Load the library

final DynamicLibrary nativeExampleLib = Platform.isAndroid
    ? DynamicLibrary.open("libexample.so")
    : DynamicLibrary.process();

// Find the symbols we want to use

final Pointer<Utf8> Function(Pointer<Utf8>) rustGreeting = nativeExampleLib
    .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
        "rust_greeting")
    .asFunction();

final void Function(Pointer<Utf8>) freeCString = nativeExampleLib
    .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>("rust_cstr_free")
    .asFunction();

String nativeGreeting(String name) {
  if (nativeExampleLib == null)
    return "ERROR: The library is not initialized 🙁";

  print("- Mylib bindings found 👍");
  print("  ${nativeExampleLib.toString()}"); // Instance info

  final argName = Utf8.toUtf8(name);
  print("- Calling rust_greeting with argument:  $argName");

  // The actual native call
  final resultPointer = rustGreeting(argName);
  print("- Result pointer:  $resultPointer");

  final greetingStr = Utf8.fromUtf8(resultPointer);
  print("- Response string:  $greetingStr");

  // Free the string pointer, as we already have
  // an owned String to return
  print("- Freing the native char*");
  freeCString(resultPointer);

  return greetingStr;
}

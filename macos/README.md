
1. Run `flutter create --platforms=macos .`
2. Remove unnecessary new files created in step 2
3. Add some lines from `ios/mylib.podspec` to `macos/mylib.podspec`
4. Replace `macos/Classes/*` with `ios/Classes/*`
5. Few more changes in source code to compatibility with new ffi and ffigen

If you start `flutter run` at this point you will get something like that
```
══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
The following ArgumentError was thrown attaching to the render tree:
Invalid argument(s): Failed to lookup symbol (dlsym(RTLD_DEFAULT, rust_greeting): symbol not found)
```

You can try changing `example/macos/Podfile` to resolve this error, but there is 
[one more recipe](https://flutter.dev/docs/development/platform-integration/c-interop#compiled-dynamic-library-macos)
to do that.
If you using this sources you need to change Library Search Paths manually 
(full path to `rust/target/x86_64-apple-darwin/release`)

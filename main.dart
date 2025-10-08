// main.dart
import 'dart:ffi';
import 'dart:io';

// Step 1: Define the C function signatures
// Native signature (as it exists in C)
typedef AddNative = Int32 Function(Int32 a, Int32 b);
typedef MultiplyNative = Int32 Function(Int32 a, Int32 b);
typedef FactorialNative = Int32 Function(Int32 n);

// Dart signature (how we'll call it from Dart)
typedef AddDart = int Function(int a, int b);
typedef MultiplyDart = int Function(int a, int b);
typedef FactorialDart = int Function(int n);

// Step 2: Create a class to manage the native library
class NativeMath {
  late final DynamicLibrary _lib;

  // Function references
  late final AddDart add;
  late final MultiplyDart multiply;
  late final FactorialDart factorial;

  NativeMath() {
    // Load the dynamic library based on platform
    if (Platform.isLinux) {
      _lib = DynamicLibrary.open('./build/libnative_math.so');
    } else if (Platform.isMacOS) {
      _lib = DynamicLibrary.open('./build/libnative_math.dylib');
    } else if (Platform.isWindows) {
      _lib = DynamicLibrary.open('./build/native_math.dll');
    } else if (Platform.isAndroid) {
      _lib = DynamicLibrary.open('./build/libnative_math.so');
    } else if (Platform.isIOS) {
      // On iOS, you typically use DynamicLibrary.process() if the library
      // is statically linked, or DynamicLibrary.open() for frameworks
      _lib = DynamicLibrary.process();
    } else {
      throw UnsupportedError('Platform not supported');
    }

    // Bind the C functions to Dart functions
    add = _lib
        .lookup<NativeFunction<AddNative>>('add')
        .asFunction<AddDart>();

    multiply = _lib
        .lookup<NativeFunction<MultiplyNative>>('multiply')
        .asFunction<MultiplyDart>();

    factorial = _lib
        .lookup<NativeFunction<FactorialNative>>('factorial')
        .asFunction<FactorialDart>();
  }
}

// Step 3: Use the native functions
void main() {
  print('=== Dart FFI C Integration Example ===\n');

  // Create an instance of our native library wrapper
  final nativeMath = NativeMath();

  // Call the add function
  int sum = nativeMath.add(15, 27);
  print('add(15, 27) = $sum');

  // Call the multiply function
  int product = nativeMath.multiply(6, 7);
  print('multiply(6, 7) = $product');

  // Call the factorial function
  int fact = nativeMath.factorial(5);
  print('factorial(5) = $fact');

  // Demonstrate synchronous nature - no async/await needed!
  print('\n=== Performance Test ===');
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < 1000000; i++) {
    nativeMath.add(i, i + 1);
  }

  stopwatch.stop();
  print('1,000,000 FFI calls completed in ${stopwatch.elapsedMilliseconds}ms');
  print('This demonstrates FFI\'s synchronous and fast nature!');
}

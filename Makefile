build/libnative_math.so: native_math.c
	gcc -shared -fPIC -o ./build/libnative_math.so native_math.c

build/libnative_math.dylib: native_math.c
	gcc -shared -fPIC -o ./build/libnative_math.dylib native_math.c

run: ./build/libnative_math.so ./build/libnative_math.dylib
	dart main.dart

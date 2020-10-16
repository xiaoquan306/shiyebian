cmake_minimum_required(VERSION 3.4.1)  # for example

add_library( write_hash

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             ../../ios/Classes/write_hash/writeHashLib.c
             ../../ios/Classes/write_hash/app1.c
             ../../ios/Classes/write_hash/app5.c
             ../../ios/Classes/write_hash/common.c
             ../../ios/Classes/write_hash/exif.c
             ../../ios/Classes/write_hash/sha256.c
             ../../ios/Classes/write_hash/sha256.c )
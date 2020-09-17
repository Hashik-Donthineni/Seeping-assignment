cmake_minimum_required(VERSION 3.4.1)  

add_subdirectory(include)
add_library( sleeper

             SHARED

             sleeper.c
        )
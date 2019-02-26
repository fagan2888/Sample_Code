cmake_minimum_required(VERSION 3.6)
project(project7)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Werror -Wextra -pedantic -pedantic-errors")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

set(SOURCE_FILES
    FifoPointAgenda.h
    LifoPointAgenda.h
    Main.cpp
    Maze.cpp
    Maze.h
    MazeSolver.cpp
    MazeSolver.h
    Point.cpp
    Point.h
    PointAgenda.h
    Queue_t.h
    Stack_t.h)

add_executable(project7 ${SOURCE_FILES})
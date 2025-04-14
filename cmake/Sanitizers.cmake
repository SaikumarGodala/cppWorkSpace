option(ENABLE_SANITIZERS "Enable sanitizers in debug builds" OFF)
option(ENABLE_TSAN "Enable ThreadSanitizer (TSan)" OFF)

if(ENABLE_SANITIZERS AND CMAKE_BUILD_TYPE MATCHES "Debug|Test")
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        set(SANITIZER_FLAGS "-fsanitize=address,undefined,leak -fno-omit-frame-pointer")
        add_compile_options(${SANITIZER_FLAGS})
        add_link_options(${SANITIZER_FLAGS})
    endif()
endif()

if(ENABLE_TSAN AND CMAKE_BUILD_TYPE MATCHES "Debug|Test")
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        set(TSAN_FLAGS "-fsanitize=thread")
        add_compile_options(${TSAN_FLAGS})
        add_link_options(${TSAN_FLAGS})
    endif()
endif()
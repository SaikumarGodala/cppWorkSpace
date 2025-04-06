# Function to apply compiler options to a target
function(apply_compiler_options target_name)
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
        target_compile_options(${target_name} PRIVATE
            $<$<CONFIG:Debug>:-g -O0 -Wall -Wextra -Wpedantic>
            $<$<CONFIG:Release>:-O3 -DNDEBUG -Wall -Wextra -Wpedantic>
        )
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        target_compile_options(${target_name} PRIVATE
            $<$<CONFIG:Debug>:/Zi /Od /W4>
            $<$<CONFIG:Release>:/O2 /DNDEBUG /W4>
        )
    endif()
endfunction()

# Apply compiler options globally to the library and executable targets
if (TARGET ${PROJECT_NAME}_lib)
    apply_compiler_options(${PROJECT_NAME}_lib)
else()
    message(WARNING "Target ${PROJECT_NAME}_lib does not exist. Skipping compiler options.")
endif()

if (TARGET ${PROJECT_NAME})
    apply_compiler_options(${PROJECT_NAME})
endif()
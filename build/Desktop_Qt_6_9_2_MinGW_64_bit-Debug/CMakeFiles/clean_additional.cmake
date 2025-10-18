# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appEverySecondCounts_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appEverySecondCounts_autogen.dir\\ParseCache.txt"
  "appEverySecondCounts_autogen"
  )
endif()

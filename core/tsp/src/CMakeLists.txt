SET(LIBRARY_OUTPUT_PATH ../../../lib/)
LINK_LIBRARIES(${GAUL_LIBRARIES} ${GAUL_UTIL_LIBRARIES})
ADD_LIBRARY(routing_tsp ${LIBRARY_MODE_TARGET} tsp.c tsp.h tsp_solver.cpp)
IF(APPLE)
    SET_TARGET_PROPERTIES(routing_tsp
        PROPERTIES
        LINK_FLAGS "-bundle_loader ${POSTGRESQL_EXECUTABLE} -bundle")
ENDIF(APPLE)
MESSAGE("Installation directory for libraries is set to ${LIBRARY_INSTALL_PATH}")
INSTALL(TARGETS routing_tsp DESTINATION ${LIBRARY_INSTALL_PATH})


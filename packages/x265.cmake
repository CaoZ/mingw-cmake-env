ExternalProject_Add(
  x265
  GIT_REPOSITORY https://github.com/zhongflyTeam/x265_git.git
  UPDATE_COMMAND ""
  CONFIGURE_COMMAND
    ${EXEC} cmake -H<SOURCE_DIR>/source -B<BINARY_DIR>
    ${cmake_conf_args}
    -DCHECKED_BUILD=OFF
    -DDETAILED_CU_STATS=OFF
    -DENABLE_AGGRESSIVE_CHECKS=OFF
    -DENABLE_ASSEMBLY=ON
    -DENABLE_CLI=OFF
    -DENABLE_HDR10_PLUS=ON
    -DENABLE_PIC=OFF
    -DENABLE_PPA=OFF
    -DENABLE_SHARED=OFF
    -DENABLE_SVT_HEVC=OFF
    -DENABLE_VTUNE=OFF
    -DHIGH_BIT_DEPTH=ON
    -DMAIN12=OFF
    -DSTATIC_LINK_CRT=ON
    -DWARNINGS_AS_ERRORS=OFF
    -DWINXP_SUPPORT=OFF
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
  BUILD_COMMAND ${NINJA} -C <BINARY_DIR>
  INSTALL_COMMAND ${NINJA} -C <BINARY_DIR> install
  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_INSTALL 1)

force_rebuild_git(x265)

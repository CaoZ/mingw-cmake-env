get_property(src_graphengine TARGET graphengine PROPERTY _EP_SOURCE_DIR)

ExternalProject_Add(
  libzimg
  DEPENDS graphengine
  GIT_REPOSITORY https://github.com/sekrit-twc/zimg.git
  GIT_SHALLOW 1
  UPDATE_COMMAND ""
  CONFIGURE_COMMAND ""
    COMMAND bash -c "rm -rf <SOURCE_DIR>/graphengine"
    COMMAND bash -c "ln -s ${src_graphengine} <SOURCE_DIR>/graphengine"
    COMMAND ${EXEC} <SOURCE_DIR>/autogen.sh && <SOURCE_DIR>/configure
      ${autotools_conf_args}
  BUILD_COMMAND ${MAKE}
  INSTALL_COMMAND ${MAKE} install
    COMMAND bash -c "git -C ${src_graphengine} clean -dfx"
  BUILD_IN_SOURCE 1
  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_INSTALL 1)

force_rebuild_git(libzimg)

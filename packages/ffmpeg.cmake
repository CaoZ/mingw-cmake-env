ExternalProject_Add(ffmpeg
    DEPENDS
        bzip2
        game-music-emu
        gmp
        lame
        libass
        libbluray
        libmodplug
        libpng
        libsoxr
        libvpx
        libzimg
        opus
        speex
        vorbis
        x264
        xvidcore
    GIT_REPOSITORY git://github.com/mpv-player/ffmpeg-mpv.git
    GIT_CONFIG remote.upstream.url=git://github.com/FFmpeg/FFmpeg.git
               remote.upstream.fetch=+refs/heads/*:refs/remotes/upstream/*
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} <SOURCE_DIR>/configure
    --cross-prefix=${TARGET_ARCH}-
    --prefix=${MINGW_INSTALL_PREFIX}
    --arch=${TARGET_CPU}
    --target-os=mingw32
    --target-exec=wine
    --pkg-config-flags=--static
    --enable-cross-compile
    --enable-runtime-cpudetect
    --enable-gpl
    --enable-version3
    --enable-nonfree
    --enable-avresample
    --enable-postproc
    --enable-avisynth
    --enable-gmp
    --enable-libass
    --enable-libbluray
    --enable-libfreetype
    --enable-libfribidi
    --enable-libgme
    --enable-libmodplug
    --enable-libmp3lame
    --enable-libopus
    --enable-libsoxr
    --enable-libspeex
    --enable-libvorbis
    --enable-libvpx
    --enable-libx264
    --enable-libxvid
    --enable-libzimg
    --enable-schannel
    --enable-cuda
    --enable-cuvid
    --disable-w32threads
    "--extra-libs='-lsecurity -lschannel'" # ffmpeg’s build system is retarded
    "--extra-cflags=-DMODPLUG_STATIC"
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

ExternalProject_Add_Step(ffmpeg rebase-upstream
    DEPENDEES download update force-update
    DEPENDERS patch configure build install
    WORKING_DIRECTORY <SOURCE_DIR>
    COMMAND git pull -r upstream master
    LOG 1
)

force_rebuild_git(ffmpeg)
extra_step(ffmpeg)

#########################################################################
# QT5
#########################################################################
sudo apt-get build-dep qt4-x11
sudo apt-get build-dep libqt5gui5
sudo apt-get build-dep qt5-default
sudo apt-get install build-essential perl python git
sudo apt-get install libx11-dev libxext-dev 
# Qt libxcdb
sudo apt-get install libxcb-xinerama0-dev libxcb-xinerama0 libxcb1 libxcb1-dev libx11-xcb1 libx11-xcb-dev libxcb-keysyms1 libxcb-keysyms1-dev libxcb-image0 libxcb-image0-dev libxcb-shm0 libxcb-shm0-dev libxcb-icccm4 libxcb-icccm4-dev libxcb-sync1 libxcb-sync-dev libxcb-render-util0 libxcb-render-util0-dev libxcb-xfixes0-dev libxrender-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-glx0-dev libxi-dev libdrm-dev libssl-dev 
sudo apt-get install '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev
sudo apt-get install libicu-dev
#Qt Webkit
sudo apt-get install flex bison gperf libicu-dev libxslt-dev ruby
# QT WebEngine
sudo apt-get install libssl-dev libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libdbus-1-dev libfontconfig1-dev libcap-dev libxtst-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev libxss-dev libegl1-mesa-dev libts-dev gperf
# QT Multimedia
sudo apt-get install libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-tools gstreamer1.0-plugins-good libavcodec-dev libavformat-dev libgst-dev libpng-dev libpng-tools
# libjpeg9-dev already have turbo jpg
# Qt Document generation tool
sudo apt install libclang-6.0-dev llvm-6.0
# sql database
sudo apt-get install libsqlite3-dev libsqlite3-dev libmysqlclient-dev 
sudo apt-get install libfreetype6-dev 
sudo apt-get install libglib2.0-dev libcups2-dev freetds-dev  libpq-dev 
# Can not do
# sudo apt-get install libiodbc2-dev # removes ros
# 
sudo apt-get install firebird-dev 
# Latest Long Term Support Release
wget http://download.qt.io/official_releases/qt/5.12/5.12.4/single/qt-everywhere-src-5.12.4.tar.xz
tar -xJf qt-everywhere-src-5.12.4.tar.xz
cd qt-everywhere-src-5.12.4

# Option 1) ./configure // make does not complete
# Option 2) ./configure --prefix=/home/pauly/tk/Qt/qt-4.8.2 -no-webkit -fast -nomake demos -nomake tools -nomake examples -no-multimedia -no-phonon -no-qt3support -opensource // old version of Qt, options not available
# Option 3) developer build creates debug version, release creates release version, speed up with nomake

./configure -v -confirm-license -optimized-qmake -reduce-exports -release -nomake tools -nomake examples -opensource -make libs -qt-pcre -prefix /usr/local/qt5 &> output
make  &> output_make
sudo make install &> output_make_install

#########################
# git clone git://code.qt.io/qt/qt5.git
# cd qt5
# git checkout v5.12.4 # latest long term support
# perl init-repository
#########################

#
# Qt congigure options:
#
####################################################################################
Top-level installation directories:
  -prefix <dir> ...... The deployment directory, as seen on the target device.
                       [/usr/local/Qt-$QT_VERSION; qtbase build directory if
                       -developer-build]
  -extprefix <dir> ... The installation directory, as seen on the host machine.
                       [SYSROOT/PREFIX]
  -hostprefix [dir] .. The installation directory for build tools running on
                       the host machine. If [dir] is not given, the current
                       build directory will be used. [EXTPREFIX]
  -external-hostbindir <path> ... Path to Qt tools built for this machine.
                       Use this when -platform does not match the current
                       system, i.e., to make a Canadian Cross Build.

Fine tuning of installation directory layout. Note that all directories
except -sysconfdir should be located under -prefix/-hostprefix:

  -bindir <dir> ......... Executables [PREFIX/bin]
  -headerdir <dir> ...... Header files [PREFIX/include]
  -libdir <dir> ......... Libraries [PREFIX/lib]
  -archdatadir <dir> .... Arch-dependent data [PREFIX]
  -plugindir <dir> ...... Plugins [ARCHDATADIR/plugins]
  -libexecdir <dir> ..... Helper programs [ARCHDATADIR/bin on Windows,
                          ARCHDATADIR/libexec otherwise]
  -importdir <dir> ...... QML1 imports [ARCHDATADIR/imports]
  -qmldir <dir> ......... QML2 imports [ARCHDATADIR/qml]
  -datadir <dir> ........ Arch-independent data [PREFIX]
  -docdir <dir> ......... Documentation [DATADIR/doc]
  -translationdir <dir> . Translations [DATADIR/translations]
  -sysconfdir <dir> ..... Settings used by Qt programs [PREFIX/etc/xdg]
  -examplesdir <dir> .... Examples [PREFIX/examples]
  -testsdir <dir> ....... Tests [PREFIX/tests]

  -hostbindir <dir> ..... Host executables [HOSTPREFIX/bin]
  -hostlibdir <dir> ..... Host libraries [HOSTPREFIX/lib]
  -hostdatadir <dir> .... Data used by qmake [HOSTPREFIX]

Conventions for the remaining options: When an option's description is
followed by a list of values in brackets, the interpretation is as follows:
'yes' represents the bare option; all other values are possible prefixes to
the option, e.g., -no-gui. Alternatively, the value can be assigned, e.g.,
--gui=yes. Values are listed in the order they are tried if not specified;
'auto' is a shorthand for 'yes/no'. Solitary 'yes' and 'no' represent binary
options without auto-detection.

Configure meta:

  -help, -h ............ Display this help screen
  -verbose, -v ......... Print verbose messages during configuration
  -continue ............ Continue configure despite errors
  -redo ................ Re-configure with previously used options.
                         Additional options may be passed, but will not be
                         saved for later use by -redo.
  -recheck [test,...] .. Discard cached negative configure test results.
                         Use this after installing missing dependencies.
                         Alternatively, if tests are specified, only their
                         results are discarded.
  -recheck-all ......... Discard all cached configure test results.

  -feature-<feature> ... Enable <feature>
  -no-feature-<feature>  Disable <feature> [none]
  -list-features ....... List available features. Note that some features
                         have dedicated command line options as well.

  -list-libraries ...... List possible external dependencies.

Build options:

  -opensource .......... Build the Open-Source Edition of Qt
  -commercial .......... Build the Commercial Edition of Qt
  -confirm-license ..... Automatically acknowledge the license

  -release ............. Build Qt with debugging turned off [yes]
  -debug ............... Build Qt with debugging turned on [no]
  -debug-and-release ... Build two versions of Qt, with and without
                         debugging turned on [yes] (Apple and Windows only)
  -optimize-debug ...... Enable debug-friendly optimizations in debug builds
                         [auto] (Not supported with MSVC or Clang toolchains)
  -optimize-size ....... Optimize release builds for size instead of speed [no]
  -optimized-tools ..... Build optimized host tools even in debug build [no]
  -force-debug-info .... Create symbol files for release builds [no]
  -separate-debug-info . Split off debug information to separate files [no]
  -gdb-index ........... Index the debug info to speed up GDB
                         [no; auto if -developer-build with debug info]
  -strip ............... Strip release binaries of unneeded symbols [yes]
  -gc-binaries ......... Place each function or data item into its own section
                         and enable linker garbage collection of unused
                         sections. [auto for static builds, otherwise no]
  -force-asserts ....... Enable Q_ASSERT even in release builds [no]
  -developer-build ..... Compile and link Qt for developing Qt itself
                         (exports for auto-tests, extra checks, etc.) [no]

  -shared .............. Build shared Qt libraries [yes] (no for UIKit)
  -static .............. Build static Qt libraries [no] (yes for UIKit)
  -framework ........... Build Qt framework bundles [yes] (Apple only)

  -platform <target> ... Select host mkspec [detected]
  -xplatform <target> .. Select target mkspec when cross-compiling [PLATFORM]
  -device <name> ....... Cross-compile for device <name>
  -device-option <key=value> ... Add option for the device mkspec

  -appstore-compliant .. Disable code that is not allowed in platform app stores.
                         This is on by default for platforms which require distribution
                         through an app store by default, in particular Android,
                         iOS, tvOS, watchOS, and Universal Windows Platform. [auto]

  -qtnamespace <name> .. Wrap all Qt library code in 'namespace <name> {...}'.
  -qtlibinfix <infix> .. Rename all libQt5*.so to libQt5*<infix>.so.

  -testcocoon .......... Instrument with the TestCocoon code coverage tool [no]
  -gcov ................ Instrument with the GCov code coverage tool [no]

  -trace [backend] ..... Enable instrumentation with tracepoints.
                         Currently supported backends are 'etw' (Windows) and
                         'lttng' (Linux), or 'yes' for auto-detection. [no]

  -sanitize {address|thread|memory|undefined}
                         Instrument with the specified compiler sanitizer.
                         Note that some sanitizers cannot be combined;
                         for example, -sanitize address cannot be combined with
                         -sanitize thread.

  -c++std <edition> .... Select C++ standard <edition> [c++1z/c++14/c++11]
                         (Not supported with MSVC)

  -sse2 ................ Use SSE2 instructions [auto]
  -sse3/-ssse3/-sse4.1/-sse4.2/-avx/-avx2/-avx512
                         Enable use of particular x86 instructions [auto]
                         Enabled ones are still subject to runtime detection.
  -mips_dsp/-mips_dspr2  Use MIPS DSP/rev2 instructions [auto]

  -qreal <type> ........ typedef qreal to the specified type. [double]
                         Note: this affects binary compatibility.

  -R <string> .......... Add an explicit runtime library path to the Qt
                         libraries. Supports paths relative to LIBDIR.
  -rpath ............... Link Qt libraries and executables using the library
                         install path as a runtime library path. Similar to
                         -R LIBDIR. On Apple platforms, disabling this implies
                         using absolute install names (based in LIBDIR) for
                         dynamic libraries and frameworks. [auto]

  -reduce-exports ...... Reduce amount of exported symbols [auto]
  -reduce-relocations .. Reduce amount of relocations [auto] (Unix only)

  -plugin-manifests .... Embed manifests into plugins [no] (Windows only)
  -static-runtime ...... With -static, use static runtime [no] (Windows only)

  -pch ................. Use precompiled headers [auto]
  -ltcg ................ Use Link Time Code Generation [no]
  -use-gold-linker ..... Use the GNU gold linker [auto]
  -incredibuild-xge .... Use the IncrediBuild XGE [no] (Windows only)
  -ccache .............. Use the ccache compiler cache [no] (Unix only)
  -make-tool <tool> .... Use <tool> to build qmake [nmake] (Windows only)
  -mp .................. Use multiple processors for compilation (MSVC only)

  -warnings-are-errors . Treat warnings as errors [no; yes if -developer-build]
  -silent .............. Reduce the build output so that warnings and errors
                         can be seen more easily

Build environment:

  -sysroot <dir> ....... Set <dir> as the target sysroot
  -gcc-sysroot ......... With -sysroot, pass --sysroot to the compiler [yes]

  -pkg-config .......... Use pkg-config [auto] (Unix only)

  -D <string> .......... Pass additional preprocessor define
  -I <string> .......... Pass additional include path
  -L <string> .......... Pass additional library path
  -F <string> .......... Pass additional framework path (Apple only)

  -sdk <sdk> ........... Build Qt using Apple provided SDK <sdk>. The argument
                         should be one of the available SDKs as listed by
                         'xcodebuild -showsdks'.
                         Note that the argument applies only to Qt libraries
                         and applications built using the target mkspec - not
                         host tools such as qmake, moc, rcc, etc.

  -android-sdk path .... Set Android SDK root path [$ANDROID_SDK_ROOT]
  -android-ndk path .... Set Android NDK root path [$ANDROID_NDK_ROOT]
  -android-ndk-platform  Set Android platform
  -android-ndk-host .... Set Android NDK host (linux-x86, linux-x86_64, etc.)
                         [$ANDROID_NDK_HOST]
  -android-arch ........ Set Android architecture (armeabi, armeabi-v7a,
                         arm64-v8a, x86, x86_64, mips, mips64)
  -android-toolchain-version ... Set Android toolchain version
  -android-style-assets  Automatically extract style assets from the device at
                         run time. This option makes the Android style behave
                         correctly, but also makes the Android platform plugin
                         incompatible with the LGPL2.1. [yes]

Component selection:

  -skip <repo> ......... Exclude an entire repository from the build.
  -make <part> ......... Add <part> to the list of parts to be built.
                         Specifying this option clears the default list first.
                         [libs and examples, also tools if not cross-building,
                         also tests if -developer-build]
  -nomake <part> ....... Exclude <part> from the list of parts to be built.
  -compile-examples .... When unset, install only the sources of examples
                         [no on WebAssembly, otherwise yes]
  -gui ................. Build the Qt GUI module and dependencies [yes]
  -widgets ............. Build the Qt Widgets module and dependencies [yes]
  -no-dbus ............. Do not build the Qt D-Bus module
                         [default on Android and Windows]
  -dbus-linked ......... Build Qt D-Bus and link to libdbus-1 [auto]
  -dbus-runtime ........ Build Qt D-Bus and dynamically load libdbus-1 [no]
  -accessibility ....... Enable accessibility support [yes]
                         Note: Disabling accessibility is not recommended.

Qt comes with bundled copies of some 3rd party libraries. These are used
by default if auto-detection of the respective system library fails.

Core options:

  -doubleconversion .... Select used double conversion library [system/qt/no]
                         No implies use of sscanf_l and snprintf_l (imprecise).
  -glib ................ Enable Glib support [no; auto on Unix]
  -eventfd ............. Enable eventfd support
  -inotify ............. Enable inotify support
  -iconv ............... Enable iconv(3) support [posix/sun/gnu/no] (Unix only)
  -icu ................. Enable ICU support [auto]
  -pcre ................ Select used libpcre2 [system/qt]
  -pps ................. Enable PPS support [auto] (QNX only)
  -zlib ................ Select used zlib [system/qt]

  Logging backends:
    -journald .......... Enable journald support [no] (Unix only)
    -syslog ............ Enable syslog support [no] (Unix only)
    -slog2 ............. Enable slog2 support [auto] (QNX only)

Network options:

  -ssl ................. Enable either SSL support method [auto]
  -no-openssl .......... Do not use OpenSSL [default on Apple and WinRT]
  -openssl-linked ...... Use OpenSSL and link to libssl [no]
  -openssl-runtime ..... Use OpenSSL and dynamically load libssl [auto]
  -securetransport ..... Use SecureTransport [auto] (Apple only)

  -sctp ................ Enable SCTP support [no]

  -libproxy ............ Enable use of libproxy [no]
  -system-proxies ...... Use system network proxies by default [yes]

Gui, printing, widget options:

  -cups ................ Enable CUPS support [auto] (Unix only)

  -fontconfig .......... Enable Fontconfig support [auto] (Unix only)
  -freetype ............ Select used FreeType [system/qt/no]
  -harfbuzz ............ Select used HarfBuzz-NG [system/qt/no]
                         (Not auto-detected on Apple and Windows)

  -gtk ................. Enable GTK platform theme support [auto]

  -lgmon ............... Enable lgmon support [auto] (QNX only)

  -no-opengl ........... Disable OpenGL support
  -opengl <api> ........ Enable OpenGL support. Supported APIs:
                         es2 (default on Windows), desktop (default on Unix),
                         dynamic (Windows only)
  -opengles3 ........... Enable OpenGL ES 3.x support instead of ES 2.x [auto]
  -angle ............... Use bundled ANGLE to support OpenGL ES 2.0 [auto]
                         (Windows only)
  -combined-angle-lib .. Merge LibEGL and LibGLESv2 into LibANGLE (Windows only)

  -qpa <name> .......... Select default QPA backend(s) (e.g., xcb, cocoa, windows)
                         A prioritized list separated by semi-colons.
  -xcb-xlib............. Enable Xcb-Xlib support [auto]

  Platform backends:
    -direct2d .......... Enable Direct2D support [auto] (Windows only)
    -directfb .......... Enable DirectFB support [no] (Unix only)
    -eglfs ............. Enable EGLFS support [auto; no on Android and Windows]
    -gbm ............... Enable backends for GBM [auto] (Linux only)
    -kms ............... Enable backends for KMS [auto] (Linux only)
    -linuxfb ........... Enable Linux Framebuffer support [auto] (Linux only)
    -mirclient ......... Enable Mir client support [no] (Linux only)
    -xcb ............... Enable X11 support. Select used xcb-* libraries [system/qt/no]
                         (-qt-xcb still uses system version of libxcb itself)

  Input backends:
    -libudev............ Enable udev support [auto]
    -evdev ............. Enable evdev support [auto]
    -imf ............... Enable IMF support [auto] (QNX only)
    -libinput .......... Enable libinput support [auto]
    -mtdev ............. Enable mtdev support [auto]
    -tslib ............. Enable tslib support [auto]
    -xcb-xinput ........ Enable XInput2 support [auto]
    -xkbcommon ......... Enable key mapping support [auto]

  Image formats:
    -gif ............... Enable reading support for GIF [auto]
    -ico ............... Enable support for ICO [yes]
    -libpng ............ Select used libpng [system/qt/no]
    -libjpeg ........... Select used libjpeg [system/qt/no]

Database options:

  -sql-<driver> ........ Enable SQL <driver> plugin. Supported drivers:
                         db2 ibase mysql oci odbc psql sqlite2 sqlite tds
                         [all auto]
  -sqlite .............. Select used sqlite3 [system/qt]

Qt3D options:

  -assimp .............. Select used assimp library [system/qt/no]
  -qt3d-profile-jobs ... Enable jobs profiling [no]
  -qt3d-profile-gl ..... Enable OpenGL profiling [no]
  -qt3d-simd ........... Select level of SIMD support [no/sse2/avx2]
  -qt3d-render ......... Enable the Qt3D Render aspect [yes]
  -qt3d-input .......... Enable the Qt3D Input aspect [yes]
  -qt3d-logic .......... Enable the Qt3D Logic aspect [yes]
  -qt3d-extras ......... Enable the Qt3D Extras aspect [yes]
  -qt3d-animation....... Enable the Qt3D Animation aspect [yes]

Further image format options:

  -jasper .............. Enable JPEG-2000 support using the JasPer library [no]
  -mng ................. Enable MNG support [no]
  -tiff ................ Enable TIFF support [system/qt/no]
  -webp ................ Enable WEBP support [system/qt/no]

Multimedia options:

  -pulseaudio .......... Enable PulseAudio support [auto] (Unix only)
  -alsa ................ Enable ALSA support [auto] (Unix only)
  -no-gstreamer ........ Disable support for GStreamer
  -gstreamer [version] . Enable GStreamer support [auto]
                         With no parameter, 1.0 is tried first, then 0.10.
  -mediaplayer-backend <name> ... Select media player backend (Windows only)
                                  Supported backends: directshow (default), wmf
  -evr ................. Enables EVR in DirectShow and WMF [auto]

WebEngine options:

  -webengine-alsa ................ Enable ALSA support [auto] (Linux only)
  -webengine-pulseaudio .......... Enable PulseAudio support [auto]
                                   (Linux only)
  -webengine-embedded-build ...... Enable Linux embedded build [auto]
                                   (Linux only)
  -webengine-icu ................. Use system ICU libraries [system/qt]
                                   (Linux only)
  -webengine-ffmpeg .............. Use system FFmpeg libraries [system/qt]
                                   (Linux only)
  -webengine-opus ................ Use system Opus libraries [system/qt]
                                   (Linux only)
  -webengine-webp ................ Use system WebP libraries [system/qt]
                                   (Linux only)
  -webengine-pepper-plugins ...... Enable use of Pepper Flash and Widevine
                                   plugins [auto]
  -webengine-printing-and-pdf .... Enable use of printing and output to PDF
                                   [auto]
  -webengine-proprietary-codecs .. Enable support for proprietary codecs [no]
  -webengine-spellchecker ........ Enable support for spellchecker [yes]
  -webengine-native-spellchecker . Enable support for native spellchecker [no]
                                   (macOS only)
  -webengine-webrtc .............. Enable support for WebRTC [auto]
(08:27 AM)uutzinger@nano:~/qt-everywhere-src-5.12.4$ 



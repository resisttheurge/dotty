@echo off

rem ###############################################################
rem # adapted from dotc script (in this directory) and scalac.bat #
rem # (included in the Scala 2.11.7 Windows distribution)         #
rem ###############################################################

rem ##########################
rem # start of actual script #
rem ##########################

setlocal

call :configure

goto :end

rem ########################
rem # end of actual script #
rem ########################

rem ###############
rem # subroutines #
rem ###############

rem #################
rem # configuration #
rem #################

rem # simple aggregation subroutine to set default configurations and call other
rem # configuration subroutines
:configure
  call :unconfigure
  call :configure_name
  call :configure_defaults
  call :configure_classes
  call :configure_root
  call :configure_versions
  call :configure_jars
  call :log_configuration
goto :eof

rem # simple unset subroutine to ensure no pollution to or from the global
rem # environment. Can be used as an index of relevant variables.
:unconfigure
  set PROGRAM_NAME=

  set BOOTCP=
  set BOOTSTRAPPED=
  set DEFAULT_JAVA_OPTS=
  set DEBUG=

  set COMPILER_MAIN=
  set FROM_TASTY=
  set REPL_MAIN=

  set DOTTY_ROOT=

  set SCALA_VERSION=
  set SCALA_BINARY_VERSION=
  set SCALA_COMPILER_VERSION=
  set DOTTY_VERSION=
  set JLINE_VERSION=

  set MAIN_JAR=
  set TEST_JAR=
  set DOTTY_JAR=
goto :eof

rem # sets the program (i.e., this script) name
:configure_name
  set PROGRAM_NAME=%~n0
goto :eof

rem # sets default flags and options
:configure_defaults
  set BOOTCP=true
  set BOOTSTRAPPED=false
  set "DEFAULT_JAVA_OPTS=-Xmx768m -Xms768m"
  set DEBUG=false
goto :eof

rem # sets fully-qualified class names of runnables
:configure_classes
  set COMPILER_MAIN=dotty.tools.dotc.Main
  set FROM_TASTY=dotty.tools.dotc.FromTasty
  set REPL_MAIN=test.DottyRepl
goto :eof

rem # uses the location of this script to set the dotty root path
rem # assuming that the path of this script is %DOTTY_ROOT%\bin\dotc.bat
:configure_root
  pushd %~dp0..
  set DOTTY_ROOT=%CD%
  popd
goto :eof

rem # sets exact versions of jars to use on the classpath
rem # TODO: extract version numbers from %DOTTY_ROOT%\project\Build.scala
:configure_versions
  set SCALA_VERSION=2.11.5
  set SCALA_BINARY_VERSION=2.11
  set SCALA_COMPILER_VERSION=2.11.5-20151022-113908-7fb0e653fd
  set DOTTY_VERSION=0.1-SNAPSHOT
  set JLINE_VERSION=2.12
goto :eof

rem # sets exact jar paths for sbt-packaged jars
:configure_jars
  set "MAIN_JAR=%DOTTY_ROOT%\target\scala-%SCALA_BINARY_VERSION%\dotty_%SCALA_BINARY_VERSION%-%DOTTY_VERSION%.jar"
  set "TEST_JAR=%DOTTY_ROOT%\target\scala-%SCALA_BINARY_VERSION%\dotty_%SCALA_BINARY_VERSION%-%DOTTY_VERSION%-tests.jar"
  set "DOTTY_JAR=%DOTTY_ROOT%\dotty.jar"
goto :eof

:log_configuration
  call :log PROGRAM_NAME=%PROGRAM_NAME%
  call :log BOOTCP=%BOOTCP%
  call :log BOOTSTRAPPED=%BOOTSTRAPPED%
  call :log DEFAULT_JAVA_OPTS=%DEFAULT_JAVA_OPTS%
  call :log DEBUG=%DEBUG%
  call :log COMPILER_MAIN=%COMPILER_MAIN%
  call :log FROM_TASTY=%FROM_TASTY%
  call :log REPL_MAIN=%REPL_MAIN%
  call :log DOTTY_ROOT=%DOTTY_ROOT%
  call :log SCALA_VERSION=%SCALA_VERSION%
  call :log SCALA_BINARY_VERSION=%SCALA_BINARY_VERSION%
  call :log SCALA_COMPILER_VERSION=%SCALA_COMPILER_VERSION%
  call :log DOTTY_VERSION=%DOTTY_VERSION%
  call :log JLINE_VERSION=%JLINE_VERSION%
  call :log MAIN_JAR=%MAIN_JAR%
  call :log TEST_JAR=%TEST_JAR%
  call :log DOTTY_JAR=%DOTTY_JAR%
goto :eof

rem #############
rem # utilities #
rem #############

:log
  if %DEBUG%=="true" echo %*
goto :eof

rem #########################
rem # end of script cleanup #
rem #########################

:end
endlocal

rem # exit code fix, see
rem # http://stackoverflow.com/questions/4632891/exiting-batch-with-exit-b-x-where-x-1-acts-as-if-command-completed-successfu
"%COMSPEC%" /C exit %errorlevel% > nul

clang_include := env('CLANG_RESOURCE_DIR')

set positional-arguments
set quiet

build_name := env('BUILD_NAME',file_name(justfile_directory()))
build_dir := "build/"
install_dir := env("INSTALL_PREFIX", "$HOME/.local/bin")
src_dir := "src/"
test_dir := "test/"

# build and run a file;
[no-cd]
run input="src/main.c":
  #!/usr/bin/env bash
  just build "{{input}}"
  output=$(just _get-output {{input}})
  "$output"

[no-cd]
build input="src/main.c":
  #!/usr/bin/env bash
  mkdir -p {{build_dir}}
  output=$(just _get-output {{input}})

  clang \
    -Wall -Wextra  -std=c99 -fsanitize=address \
    -I{{src_dir}} -I{{clang_include}} \
    $(fd -e c -E main.c . src) {{input}} -o $output

[no-cd]
test filter=".":
  #!/usr/bin/env bash
  test_exit_code=0
  for f in $(fd -e c {{filter}} {{test_dir}}); do
    outfile="{{build_dir}}$(basename $f .c)"
    build_log=$(just build $f 2>&1)

    if [[ $? -ne 0 ]]; then
      echo "\033[31mCould not build test: $f\033[0m"
      echo "$build_log"  # Show the build error
      exit 1
    fi

    $("$outfile")
    test_exit_code=$?

    if [[ $test_exit_code -ne 0 ]]; then
      echo -e "\033[31mFAILED\033[0m\t$f"
      break
    else
      echo -e "\033[32mPASSED\033[0m\t$f"
    fi
  done

  if [[ $test_exit_code -eq 0 ]]; then
    echo -e "All tests passed" | boxes -d ansi | lolcat -S 47
  fi

build-commands:
  bear -- just build

clean:
  rm -rf {{build_dir}}

_get-output input="src/main.c":
  #!/usr/bin/env bash
  if [[ "{{input}}" == "src/main.c" ]]; then
    echo "{{build_dir}}{{build_name}}"
  else
    echo "{{build_dir}}$(basename {{input}} .c)"
  fi


watch *args:
  fd | entr -rc just $@

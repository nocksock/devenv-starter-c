{ pkgs,  config, ... }:
{
  env.BUILD_OUTDIR = "out/";
  env.BUILD_DEFAULT_FILE = "main.c";
  env.MallocNanoZone = "0"; # prevent ASan issues on macOS

  packages = with pkgs; [ 
    clang clang-tools bear
    gdb
    lolcat boxes
  ];

  tasks = {
    "init:create-out" = {
      exec = ''
        if [[ ! -d out ]]; then
          mkdir out
        fi
      '';
      before = [ "dev:build-commands" ];
    };
    "dev:build-commands" = {
      exec = ''
        if [[ ! -f compile_commands.json ]]; then
          dev-build-commands
        fi
      '';
      before = [ "devenv:enterShell" ];
    };
  };

  scripts = {
    dev-build-commands.exec = ''
      cd ${config.env.DEVENV_ROOT};
      input="''${1:-${config.env.BUILD_DEFAULT_FILE}}";

      bear -- dev-build
    '';
    dev-build.exec = ''
      cd ${config.env.DEVENV_ROOT};
      input="''${1:-${config.env.BUILD_DEFAULT_FILE}}";
      output="${config.env.BUILD_OUTDIR}/$(basename $input .c)";

      clang \
        -Wall -Wextra -Werror -std=c99 -fsanitize=address \
        -I${pkgs.clang}/resource-root/include \
        -o "$output" "$input"
    '';
    dev-run.exec = ''
      cd ${config.env.DEVENV_ROOT}
      input="''${1:-${config.env.BUILD_DEFAULT_FILE}}";
      output="${config.env.BUILD_OUTDIR}/$(basename $input .c)";

      dev-build "$input" && "$output"
    '';
  };

  enterShell = ''
    cat <<'EOF' | boxes -d ansi-double | lolcat
      Dev Environment loaded!
      
      Available commands:
        - dev-build [filename]  : build the program (defaults to main.c)
        - dev-run [filename]    : build and run the program (defaults to main.c)
        - dev-build-commands    : generate compile_commands.json for clang tooling
    EOF
  '';
}

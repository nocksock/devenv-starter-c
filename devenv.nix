{ pkgs,  config, ... }:
{
  env.GREET = "devenv";
  env.BUILD_OUTFILE = "out/main";
  env.BUILD_INFILE = "main.c";

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
      bear -- dev-build
    '';
    dev-build.exec = ''
      cd ${config.env.DEVENV_ROOT};
      clang \
        -Wall -Wextra -std=c99 \
        -I${pkgs.clang}/resource-root/include \
        -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL \
        -o ${config.env.BUILD_OUTFILE} ${config.env.BUILD_INFILE}
    '';
    dev-run.exec = ''
      dev-build && ${config.env.DEVENV_ROOT}/${config.env.BUILD_OUTFILE}
    '';
  };

  enterShell = ''
    cat <<'EOF' | boxes -d ansi-double | lolcat
      Dev Environment loaded!
      
      Available commands:
        - dev-build           : Build the program
        - dev-run             : Build and run the program
        - dev-build-commands  : Generate compile_commands.json for clang tooling
    EOF
  '';
}

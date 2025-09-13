{ pkgs,  config, ... }:
{
  env.GREET = "devenv";
  env.BUILD_OUTFILE = "out/main";
  env.BUILD_INFILE = "main.c";

  packages = with pkgs; [ 
    clang clang-tools bear
    gdb
    raylib
    lolcat boxes
  ];

  tasks = {
    "init:create-out" = {
      exec = ''
        if [[ ! -d out ]]; then
          mkdir out
        fi
      '';
      before = [ "ray:build-commands" ];
    };
    "ray:build-commands" = {
      exec = ''
        if [[ ! -f compile_commands.json ]]; then
          ray-build-commands
        fi
      '';
      before = [ "devenv:enterShell" ];
    };
  };

  scripts = {
    ray-build-commands.exec = ''
      cd ${config.env.DEVENV_ROOT};
      bear -- ray-build
    '';
    ray-build.exec = ''
      cd ${config.env.DEVENV_ROOT};
      clang \
        -Wall -Wextra -std=c99 \
        -I${pkgs.raylib}/include \
        -I${pkgs.clang}/resource-root/include \
        -L${pkgs.raylib}/lib -lraylib \
        -framework CoreVideo -framework IOKit -framework Cocoa -framework GLUT -framework OpenGL \
        -o ${config.env.BUILD_OUTFILE} ${config.env.BUILD_INFILE}
    '';
    ray-run.exec = ''
      ray-build && ${config.env.DEVENV_ROOT}/${config.env.BUILD_OUTFILE}
    '';
  };

  enterShell = ''
    cat <<'EOF' | boxes -d ansi-double | lolcat
      Dev Environment loaded!
      
      Available commands:
        - ray-build           : Build the program
        - ray-run             : Build and run the program
        - ray-build-commands  : Generate compile_commands.json for clang tooling
    EOF
  '';
}

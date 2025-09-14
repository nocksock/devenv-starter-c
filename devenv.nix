{ pkgs,  config, ... }:
{
  env.CLANG_RESOURCE_DIR = "${pkgs.clang}/resource-root/include";
  env.MallocNanoZone = "0"; # prevent print of odd ASan issue on macOS

  packages = with pkgs; [ 
    # app dependencies
    git

    # dev tools
    clang clang-tools bear
    gdb
    just fd lolcat boxes
  ];

  enterTest = ''
    just test
  '';

  tasks = {
    "dev:build-commands" = {
      exec = ''
        just build-commands
      '';
      before = [ "devenv:enterShell" ];
    };
  };

  enterShell = ''
    cat <<'EOF' | boxes -d ansi-double | lolcat
      Dev Environment loaded!
      
      Available commands:
        - just run       # build and run src/main.c
        - just build     # Build the application
        - just test      # Build and run tests

      all commands take a file argument to specify a different source file

      EXAMPLE:
        just run src/main.c
        just test test/options_test.c
    EOF
  '';
}

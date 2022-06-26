{ lib, ... }: with lib; {
  imports = [
    ./plugins
  ];

  options = with types; {
    ftplugin = {
      type = attrsOf string;
      description = ''
        contents of ftplugins to load
      '';
    };

    setup = mkOption {
      type = attrsOf package;
      description = ''
        Lua config packages to link into $XDG_CONFIG_HOME/nvim/lua
      '';
    };

    plugins = {
      start = mkOption {
        type = listOf package;
        default = [];
        description = ''
          Plugins to load on start
        '';
      };

      opt = mkOption {
        type = listOf package;
        default = [];
        description = ''
          Plugins to optionally load
        '';
      };
    };
  };
}

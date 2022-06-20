{ lib, ... }: with lib; {
  imports = [
    ./ftplugin
    ./plugins
  ];

  options = with types; {
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

    ftplugins = mkOption {
      type = attrsOf string;
      description = ''
        files to write to $XDG_CONFIG_HOME/nvim/ftplugin
      '';
    };
  };
}

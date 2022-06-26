{ pkgs, config, lib, ... }: let
  name = "telescope";
  cfg = config.${name};
in {
  options.${name}.enable = lib.mkEnableOption "Enable ${name}";

  config = lib.mkIf cfg.enable {
    plugins.start = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
    ];

    setup.${name} = pkgs.stdenv.mkDerivation {
      name = "${name}-setup";
      src = ./.;
      propagatedBuildInputs = [pkgs.fd];
      buildCommand = ''
        mkdir -p "$out"
        echo 'local fdPath = "${pkgs.fd}/bin/fd"' >> "$out/config.lua"
        cat "$src/config.lua" >> "$out/config.lua"
      '';
    };
  };
}

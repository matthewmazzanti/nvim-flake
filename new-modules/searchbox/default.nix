{ pkgs, config, lib, ... }: let
  name = "searchbox";
  cfg = config.${name};
in {
  options.${name}.enable = lib.mkEnableOption "Enable ${name}";

  config = lib.mkIf cfg.enable {
    plugins.start = with pkgs.vimPlugins; [
      vim-searchbox
    ];

    setup.${name} = pkgs.stdenv.mkDerivation {
      name = "${name}-setup";
      src = ./.;
      buildCommand = ''
        mkdir -p "$out"
        cp "$src/config.lua" "$out"
      '';
    };
  };
}

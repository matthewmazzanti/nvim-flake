{ pkgs, config, lib, ... }: let
  name = "cmp";
  cfg = config.${name};
in {
  options.${name}.enable = lib.mkEnableOption "Enable ${name}";

  config = lib.mkIf cfg.enable {
    # TODO: Make this configurable
    plugins.start = with pkgs.vimPlugins; [
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      luasnip
      cmp_luasnip
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

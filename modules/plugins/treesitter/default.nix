{ pkgs, config, lib, ... }: let
  name = "treesitter";
  cfg = config.${name};
in {
  options.${name}.enable = lib.mkEnableOption "Enable ${name}";

  config = lib.mkIf cfg.enable {
    # TODO: Make grammars configurable
    plugins.start = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      nvim-treesitter-textobjects
      nvim-ts-autotag
      # Disabled for now
      # spellsitter-nvim
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

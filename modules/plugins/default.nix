{ pkgs, lib, ... }: with lib; let
  # Add modules for simple vim plugins just based off of a plugin package
  mkBasicModule = name: plugin: { pkgs, lib, config, ... }: let
    cfg = config.${name};
  in with lib; {
    options.${name}.enable = mkEnableOption "Enable ${name}";

    config = mkIf cfg.enable {
      plugins.start = [plugin];
    };
  };

  # Definitions for basic plugins
  basicPlugins = attrValues (mapAttrs mkBasicModule (with pkgs.vimPlugins; {
    "python-indent" = vim-python-pep8-indent;
    "fugitive" = vim-fugitive;
    "signature" = vim-signature;
    "nix" = vim-nix;
    "wordmotion" = vim-wordmotion;
  }));
in {
  imports = basicPlugins ++ [
    ./camelcasemotion
    ./cmp
    ./easyclip
    ./fine-cmdline
    ./gruvbox
    ./lspconfig
    ./lualine
    ./sandwich
    ./searchbox
    ./telescope
    ./treesitter
  ];
}

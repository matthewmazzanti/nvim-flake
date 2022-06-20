{ pkgs, config, lib, ... }: let
  name = "lspconfig";
  cfg = config.${name};

  # TODO: Find a way to write this in nix and convert to lua
  servers = with pkgs; ''
    local language_servers = {
      rust_analyzer = {
        "${rust-analyzer}/bin/rust-analyzer"
      },
      gopls = {
        "${gopls}/bin/gopls"
      },
      pylsp = {
        "${python3Packages.python-lsp-server}/bin/pylsp"
      },
      tsserver = {
        "${nodePackages.typescript-language-server}/bin/typescript-language-server",
        "--stdio"
      },
      hls = {
        "${haskell-language-server}/bin/haskell-language-server"
      },
      ccls = {
        "${ccls}/bin/ccls"
      },
      rnix = {
        "${rnix-lsp}/bin/rnix-lsp"
      },
      bashls = {
        "${nodePackages.bash-language-server}/bin/bash-language-server",
        "start"
      },
    }

    local sumneko_lua = "${sumneko-lua-language-server}/bin/lua-language-server"
  '';

in {
  options.${name}.enable = lib.mkEnableOption "Enable ${name}";

  config = lib.mkIf cfg.enable {
    plugins.start = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];

    setup.${name} = pkgs.stdenv.mkDerivation {
      name = "lspconfig-setup";
      src = ./.;
      buildCommand = ''
        mkdir -p "$out"
        cat << "EOF" >> "$out/config.lua"
        ${servers}
        EOF

        cat "$src/config.lua" >> "$out/config.lua"
      '';
    };
  };
}

{ pkgs }: let
  # TODO: Find a way to write this in nix and convert to lua
  servers = with pkgs; ''
    local language_servers = {
      rust_analyzer = {
        "${rust-analyzer}/bin/rust-analyzer"
      },
      gopls = {
        "${gopls}/bin/gopls"
      },
      pyright = {
        "${nodePackages.pyright}/bin/pyright-langserver",
        "--stdio"
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

in ''
  ${servers}
  ${builtins.readFile ./config.lua}
''

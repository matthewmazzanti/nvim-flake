{
  inputs = {
    vim-easyclip-src = {
      url = "github:svermeulen/vim-easyclip/master";
      flake = false;
    };

    gruvbox-community-src = {
      url = "github:gruvbox-community/gruvbox/master";
      flake = false;
    };

    vim-pgsql-src = {
      url = "github:lifepillar/pgsql.vim/master";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: let
    system = "x86_64-linux";

    # Add flake inputs as vim plugins
    pluginOverlay = (self: super: let
      buildPlugin = super.vimUtils.buildVimPluginFrom2Nix;
      versionOf = src: builtins.toString src.lastModified;
    in {
      vimPlugins = super.vimPlugins // {
        gruvbox-community = buildPlugin {
          pname = "gruvbox-community";
          version = versionOf inputs.gruvbox-community-src;
          src = inputs.gruvbox-community-src;
        };

        vim-easyclip = buildPlugin {
          pname = "vim-easyclip";
          version = versionOf inputs.vim-easyclip-src;
          src = inputs.vim-easyclip-src;
          dependencies = with super.vimPlugins; [ vim-repeat ];
        };

        vim-pgsql = buildPlugin {
          pname = "vim-pgsql";
          version = versionOf inputs.vim-pgsql-src;
          src = inputs.vim-pgsql-src;
        };
      };
    });

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        pluginOverlay
      ];
    };

  in rec {
    packages.${system}.default = pkgs.callPackage ./neovim.nix {
      config = {
        easyclip.enable = true;
        lspconfig.enable = true;
        treesitter.enable = true;
        telescope.enable = true;
      };
    };
    devShell.${system} = (pkgs.mkShell {
      packages = with pkgs; [
        neovim
      ];
    });
  };
}

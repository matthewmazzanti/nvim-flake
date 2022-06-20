{
  inputs = {
    vim-easyclip-src = {
      url = "github:svermeulen/vim-easyclip/master";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: let
    system = "x86_64-linux";

    # Add flake inputs as vim plugins
    # TODO: Upstream easyclip - or un-upstream everything?
    pluginOverlay = self: super: let
      buildPlugin = super.vimUtils.buildVimPluginFrom2Nix;
      versionOf = src: builtins.toString src.lastModified;
    in {
      vimPlugins = super.vimPlugins // {
        vim-easyclip = buildPlugin {
          pname = "vim-easyclip";
          version = versionOf inputs.vim-easyclip-src;
          src = inputs.vim-easyclip-src;
          dependencies = with super.vimPlugins; [ vim-repeat ];
        };
      };
    };

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        pluginOverlay
      ];
    };

  in rec {
    packages.${system}.default = pkgs.callPackage ./neovim.nix {
      config = {
        camelcasemotion.enable = true;
        easyclip.enable = true;
        gruvbox.enable = true;
        lspconfig.enable = true;
        python-indent.enable = true;
        sandwich.enable = true;
        telescope.enable = true;
        treesitter.enable = true;
      };
    };

    devShell.${system} = (pkgs.mkShell {
    });
  };
}

{ pkgs, lib, ... }: with builtins; {
  config = {
    vim = {
      ftplugin = import ./ftplugin;
      init = readFile ./init.lua;
      compile = false;
    };

    plugins = {
      # Language intellegence
      lspconfig = {
        enable = true;
        config = import ./lspconfig pkgs;
      };
      treesitter = {
        enable = true;
        config = readFile ./treesitter.lua;
        /*
        plugins = {
          textobjects.enable = true;
          autotag.enable = true;
          spellsitter.enable = false;
        };
        */
      };
      cmp = {
        enable = true;
        config = readFile ./cmp.lua;
      };

      # Indentation plugins - hopefully phased out with treesitter
      nix.enable = true;
      python-indent.enable = true;


      # Motion improvements
      wordmotion.enable = true;
      sandwich = {
        enable = true;
        config = readFile ./sandwich.lua;
      };
      easyclip = {
        enable = true;
        config = readFile ./easyclip.lua;
      };

      # Visual enhancements
      signature.enable = true;
      gruvbox = {
        enable = true;
        config = readFile ./gruvbox.lua;
      };
      lualine = {
        enable = true;
        config = readFile ./lualine.lua;
      };

      # Misc improvements
      fugitive.enable = true;
      telescope = {
        enable = true;
        config = ''
          local fdPath = "${pkgs.fd}/bin/fd"
          ${readFile ./telescope.lua}
        '';
      };

      # WIP
      # TODO: Improve these plugins - would love to move commandline to something more eye-candy
      fine-cmdline.enable = false;
      searchbox.enable = false;
    };
  };
}

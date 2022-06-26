{ lib, ... }: with builtins; {
  config = {
    ftplugin = import ./ftplugin;

    plugins = {
      # Language intellegence
      lspconfig = {
        enable = true;
        config = import ./lspconfig inputs;
      };
      treesitter = {
        enable = true;
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
      };

      # WIP
      # TODO: Improve these plugins - would love to move commandline to something more eye-candy
      fine-cmdline.enable = false;
      searchbox.enable = false;
    };
  };
}

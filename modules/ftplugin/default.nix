{ pkgs, ... }: let
  two-space = builtins.readFile ./two_space.lua;
  tab = builtins.readFile ./tab.lua;

  # Make a script from an dict. Map each key/value to a string, collect into list, and join together
  # mkScript :: (Key -> a -> String) -> Dict -> String
  mkScript = with builtins; fn: set: concatStringsSep "\n" (attrValues (mapAttrs fn set));

  # Link ftplugins into config/ftplugin directory
  writeFtPlugins = with builtins; let
    # Render a single ftplugin to a file
    writeFtPlugin = (name: text: ''
      cat << "EOF" >> "$out/ftplugin/${name}.lua"
      ${text}
      EOF
    '');
  in ftplugins: ''
    mkdir -p "$out/ftplugin"
    ${mkScript writeFtPlugin ftplugins}
  '';

  ftplugins = {
    # Tab based languages
    go = tab;
    c = tab;

    # Four space languages
    python = ''
      vim.opt_local.colorcolumn = "80"
      vim.opt_local.textwidth = 79
    '';
    # Use vim :help for Lua files
    lua = ''
      vim.opt_local.keywordprg = ""
    '';

    # Two-space languages
    javascript = two-space;
    typescript = two-space;
    html = two-space;
    css = two-space;
    json = two-space;
    yaml = two-space;
    nix = two-space;
    cpp = two-space;
    markdown = ''
      ${two-space}
      vim.opt_local.spell = true
    '';
  };

  ftpluginDrv = pkgs.stdenv.mkDerivation {
    name = "ftplugin";
    src = ./.;
    buildCommand = writeFtPlugins ftplugins;
  };
in {
  config.plugins.start = [ftpluginDrv];
}

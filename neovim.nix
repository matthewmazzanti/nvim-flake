{ config, pkgs, lib, stdenv, neovim, makeWrapper, vimPlugins }:
let
  module = lib.evalModules {
    modules = [
      { imports = [ ./modules ]; }
      config
    ];

    specialArgs = {
      inherit pkgs;
    };
  };

  cfg = module.config;

  pack = (vimPlugins:
    let
      # Generate code to link a single vim plugin into place
      linkPlugin = (plugin: ''
        ln -sf "${plugin}" "$start/${plugin.pname}"
      '');

      # Generate code for each plugin, render into usable script
      linkPlugins = (plugins: builtins.concatStringsSep "\n" (map linkPlugin plugins));

    in stdenv.mkDerivation {
      name = "packdir";
      buildCommand = ''
        start="$out/pack/nix/start"
        mkdir -p "$start"
        ${linkPlugins vimPlugins}
      '';
    }
  );

  plugins = with vimPlugins; cfg.plugins.start ++ [
    # Visuals
    lightline-vim

    # Tree sitter / LSP
    nvim-compe
  ];

  # Make a script from an dict. Map each key/value to a string, collect into list, and join together
  # mkScript :: (Key -> a -> String) -> Dict -> String
  mkScript = with builtins; fn: set: concatStringsSep "\n" (attrValues (mapAttrs fn set));

  # Link ftplugins into config/ftplugin directory
  linkFtPlugins = with builtins; let
    # Render a single ftplugin to a file
    linkFtPlugin = (name: text: ''
      cat << "EOF" >> "$cfg/ftplugin/${name}.lua"
      ${text}
      EOF
    '');
  in ftplugins: ''
    mkdir -p "$cfg/ftplugin"
    ${mkScript linkFtPlugin ftplugins}
  '';

  # Lua to load plugins. Happens in two phases:
  # require, where the plugin is required and result added to the plugins table
  # setup, where the plugin's `setup` method is called, if present, with the above plugin table
  loadSetup = let
    load = mkScript (name: pkg: ''plugins["${name}"] = load_plugin("${pkg}/config.lua")'');
  in setups: ''
    local function load_plugin(path)
      local res = dofile(path)

      if res == nil then
        return true
      end

      return res
    end

    plugins = {}
    ${load setups}

    for name, plugin in pairs(plugins) do
      if type(plugin) == "table" and plugin["setup"] ~= nil then
        plugin.setup(plugins)
      end
    end
  '';

in stdenv.mkDerivation {
  name = "test";
  src = ./cfg;
  buildInputs = [ makeWrapper ];
  buildCommand = ''
    set -eo pipefail

    # Unwrapped neovim
    nvim="${neovim}/bin/nvim"

    # Wrapped path
    bin="$out/bin/nvim"

    # Configuration directory
    cfg="$out/cfg/nvim"

    # Load config into config directory
    mkdir -p "$cfg"

    # setup init.lua
    init="$cfg/init.lua"

    cat << "EOF" >> "$init"
    vim.opt.packpath:prepend({"${pack plugins}"})
    EOF

    cat "$src/init.lua" >> "$init"

    cat << "EOF" >> "$init"
    ${loadSetup cfg.setup}
    EOF

    ${linkFtPlugins cfg.ftplugins}

    # TODO: According to docs, there are a lot more startup options that can
    # load files into the runtime - may be smart to unset those if they cause
    # problems
    makeWrapper "$nvim" "$bin" --set XDG_CONFIG_HOME "$(dirname $cfg)"
  '';
}

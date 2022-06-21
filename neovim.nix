{ config, pkgs, lib, stdenv, neovim, makeWrapper, vimPlugins, vimUtils, writeTextFile }:
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

  packDir = vimUtils.packDir {
    neovim = {
      start = cfg.plugins.start;
      opt = cfg.plugins.opt;
    };
  };

  # Make a script from an dict. Map each key/value to a string, collect into list, and join together
  # mkScript :: (Key -> a -> String) -> Dict -> String
  mkScript = with builtins; fn: set: concatStringsSep "\n" (attrValues (mapAttrs fn set));

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

  init = writeTextFile {
    name = "init.lua";
    text = ''
      vim.opt.packpath:prepend({"${packDir}"})

      ${builtins.readFile ./init.lua}

      ${loadSetup cfg.setup}
    '';
  };

in stdenv.mkDerivation {
  name = "test";
  buildInputs = [ makeWrapper ];
  buildCommand = ''
    # TODO: According to docs, there are a lot more startup options that can
    # load files into the runtime - may be smart to unset those if they cause
    # problems
    makeWrapper \
      "${neovim}/bin/nvim" \
      "$out/bin/nvim" \
      --add-flags '-u "${init}"' \
      --prefix PATH : "${pkgs.xdg-utils}/bin"
  '';
}

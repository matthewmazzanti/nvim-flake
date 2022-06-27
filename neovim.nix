{
  profile ? null,
  configure ? null,
  # Core nixpkgs imports
  pkgs, lib, stdenv,
  # Derivation utils
  makeWrapper, writeTextFile,
  # Vim specific stuff
  neovim, vimPlugins, vimUtils
}: let
  cfg = let
    module = lib.evalModules {
      modules =
        [ ./options.nix ]
        ++ (if profile == null then [] else [(import ./config).${profile}])
        ++ (if configure == null then [] else [configure]);

      specialArgs = {
        inherit pkgs;
        inherit lib;
      };
    };
  in module.config.vim;

  init = let
    packDir = vimUtils.packDir {
      neovim = {
        start = [ftpluginDrv] ++ cfg.plugins.start;
        opt = cfg.plugins.opt;
      };
    };
  in writeTextFile {
    name = "init.lua";
    text = ''
      vim.opt.packpath:prepend({"${packDir}"})
      vim.opt.runtimepath:prepend({"${packDir}"})

      ${cfg.init}

      ${loadSetup cfg.setup}
    '';
  };

  # TODO: Ensure that this is sourced with a higher priority than other plugins
  ftpluginDrv = with builtins; let
    # Render a single ftplugin to a file
    # TODO: Use writeFile derivations for this?
    writeFtPlugin = name: text: ''
      cat << "EOF" >> "$out/ftplugin/${name}.lua"
      ${text}
      EOF
    '';

   # Render all ftplugins into new plugins ftplugin directory
    writeFtPlugins = ftplugins: ''
      mkdir -p "$out/ftplugin"
      ${mkScript writeFtPlugin ftplugins}
    '';
  in pkgs.stdenv.mkDerivation {
    name = "ftplugin";
    buildCommand = writeFtPlugins cfg.ftplugin;
  };

  # Make a script from an dict. Map each key/value to a string, collect into list, and join together
  # mkScript :: (Key -> a -> String) -> Dict -> String
  mkScript = with builtins; fn: set: concatStringsSep "\n" (attrValues (mapAttrs fn set));

  # Lua to load plugins. Happens in two phases:
  # require, where the plugin is required and result added to the plugins table
  # setup, where the plugin's `setup` method is called, if present, with the above plugin table
  loadSetup = let
    load = mkScript (name: pkg: ''plugins["${name}"] = load_plugin("${pkg}")'');
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
  buildInputs = [ makeWrapper ];
  # TODO: According to docs, there are a lot more startup options that can load files into the
  # runtime - may be smart to unset those if they cause problems
  buildCommand = ''
    makeWrapper \
      "${neovim}/bin/nvim" \
      "$out/bin/nvim" \
      --add-flags '-u "${init}"' \
      --prefix PATH : "${pkgs.xdg-utils}/bin"
  '';
}

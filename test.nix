let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;

  flatMap = flatMapRec [];

  /*
  --- flatMapRec ---
  Recursively traverse attribute set, and apply a function to the path and
  value when recursion terminates

  --- Args ---
  path: List of strings for the path within the recursive set
  cond: Recursion condition. Will recurse on true, will apply function on false
  fn: Function to apply. Will recieve a path and a value
  set: Recursive set to apply to
  */
  flatMapRec = path: cond: fn: set: let
    load = name: let
      # Value of set at this attribute
      value = builtins.getAttr name set;

      # Generate new path for current level
      path' = path ++ [name];

      # Recurse into attrset
      recurse = flatMapRec path' cond fn value;

      # Apply function to path + value
      apply = fn path' value;
    in
      # If condition is true, recurse otherwise apply the function
      if cond path value then recurse else apply;

  in
    lib.flatten (map load (builtins.attrNames set));

in {
  fn = path: value: "${builtins.concatStringsSep "/" path}-${value}";

  flatMap = flatMap;
}

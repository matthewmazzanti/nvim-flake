{ lib, ... }: with lib; {
  imports = [
    ./easyclip
    ./lspconfig
    ./treesitter
  ];
}

{ lib, ... }: with lib; {
  imports = [
    ./easyclip
    ./lspconfig
    ./telescope
    ./treesitter
  ];
}

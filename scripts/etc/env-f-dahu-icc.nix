let nixpkgs = import <nixpkgs> {};

in nixpkgs.mkShell.override { stdenv = nixpkgs.stdenvNoCC; } {
  buildInputs = with nixpkgs; [
    cmake
    pkg-config
    nur.repos.gricad.openmpi4
    nur.repos.gricad.intel-compilers-2019
  ];
  NIX_SHELL_PROMPT_TAG = "idefix";
}

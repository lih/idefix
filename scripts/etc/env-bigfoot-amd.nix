let nixpkgs = import <nixpkgs> {};

in nixpkgs.mkShell {
  buildInputs = with nixpkgs; [
    cmake
    pkg-config
    nur.repos.gricad.openmpi4
    nur.repos.gricad.ucx
    rocmPackages.rocm-smi
    rocmPackages.clr
    rocmPackages.rocthrust
    rocmPackages.rocprim
  ];
  NIX_SHELL_PROMPT_TAG = "idefix";
  # IDEFIX_CUDA_INCLUDE = "${nixpkgs.lib.getDev cudatoolkit}/include";
}

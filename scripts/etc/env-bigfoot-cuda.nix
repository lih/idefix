let nixpkgs = import <nixpkgs> {};

in nixpkgs.mkShell.override { stdenv = nixpkgs.stdenvNoCC; } {
  buildInputs = with nixpkgs; [
    gcc11
    cmake
    pkg-config
    (nur.repos.gricad.openmpi4.override {
      cudaSupport = true;
      inherit cudatoolkit;
    })
    cudatoolkit
  ];
  NIX_SHELL_PROMPT_TAG = "idefix";
  CUDA_RUNTIME = "${nixpkgs.linuxPackages.nvidia_x11}";
}

#!/usr/bin/env bash
function setup_env() {
    set +ue
    source /applis/site/nix.sh >/dev/null 2>&1
    set -ue

    local cache=~/.nix-cache/nix-shell-idefix
    if [ ! -e "$cache" ]; then
        mkdir -p ~/.nix-cache
        nix-instantiate --add-root "$cache.drv" --expr 'with import <nixpkgs> {}; bashInteractive'
        nix-store --realise --add-root "$cache" "$cache.drv"
    fi
}

function set_compiler_options() {
    local model="$1"; shift
    local compiler="$1"; shift
    case "$model" in
        V100)
            GPU_FLAVOR=cuda
            IDEFIX_CMAKE_OPTIONS+=( -DKokkos_ENABLE_CUDA=ON -DKokkos_ARCH_VOLTA70=ON )
            ;;
        A100)
            GPU_FLAVOR=cuda
            IDEFIX_CMAKE_OPTIONS+=( -DKokkos_ENABLE_CUDA=ON -DKokkos_ARCH_AMPERE80=ON )
            ;;
        H100)
            GPU_FLAVOR=cuda
            IDEFIX_CMAKE_OPTIONS+=( -DKokkos_ENABLE_CUDA=ON -DKokkos_ARCH_HOPPER90=ON )
            ;;
        Mi200)
            GPU_FLAVOR=amd
            IDEFIX_CMAKE_OPTIONS+=( -DKokkos_ENABLE_HIP=ON -DCMAKE_CXX_COMPILER=hipcc -DKokkos_ARCH_VEGA90A=ON )
            ;;
        '') ;;
        *)
            printf "Error: unknown gpu architecture '%s'\n" "$model"
            return 1
    esac
}

function in_env_raw() {
    local -a cmd="$1"
    local drvfile="$IDEFIX_DIR/scripts/etc/env-bigfoot-$GPU_FLAVOR.drv"
    if [ ! -e "$drvfile" ]; then
        printf "Cacheing an Idefix shell derivation in %s\n" "$drvfile" >&2
        nix-instantiate --add-root "$drvfile" "$IDEFIX_DIR/scripts/etc/env-bigfoot-$GPU_FLAVOR.nix" >/dev/null
    fi
    printf "Running command: %s\n" "$cmd" >&2
    NIX_BUILD_SHELL="$HOME/.nix-cache/nix-shell/bin/bash" nix-shell "$drvfile" --run "$cmd"
}
function in_env() {
    local -a cmd=( "$@" )
    in_env_raw "$(declare -p cmd); "'"${cmd[@]}"'
}

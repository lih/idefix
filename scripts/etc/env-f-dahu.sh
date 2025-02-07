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
    IDEFIX_COMPILER="$compiler"
    IDEFIX_CMAKE_OPTIONS+=(  -DCMAKE_CXX_COMPILER="$IDEFIX_COMPILER" )
}

function in_env_raw() {
    local cmd="$1"; shift
    local prelude=":"
    local drvfile="$IDEFIX_DIR/scripts/etc/env-f-dahu-$IDEFIX_COMPILER.drv"
    if [ ! -e "$drvfile" ]; then
        printf "Cacheing an Idefix shell derivation in %s\n" "$drvfile" >&2
        nix-instantiate --add-root "$drvfile" "$IDEFIX_DIR/scripts/etc/env-f-dahu-$IDEFIX_COMPILER.nix" >/dev/null
    fi
    printf "Running command: %s\n" "$cmd" >&2
    NIX_BUILD_SHELL="$HOME/.nix-cache/nix-shell-idefix/bin/bash" nix-shell "$drvfile" --run "$prelude; $cmd"
}
function in_env() {
    local -a cmd=( "$@" )
    in_env_raw "$(declare -p cmd); "'"${cmd[@]}"'
}

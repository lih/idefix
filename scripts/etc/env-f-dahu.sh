#!/usr/bin/env bash
function setup_env() {
    set +ue
    source /applis/site/nix.sh >/dev/null 2>&1
    set -ue
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
    if [ "$IDEFIX_COMPILER" == icc ]; then
        prelude="source $INTEL_ONEAPI/setvars.sh"
    fi
    bash -c "$prelude; $cmd"
}
function in_env() {
    local -a cmd=( "$@" )
    in_env_raw "$(declare -p cmd); "'"${cmd[@]}"'
}

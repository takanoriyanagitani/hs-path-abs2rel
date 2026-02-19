#!/bin/sh

bname=hs-path-abs2rel
bin=$(cabal exec -- which "${bname}")

input(){
    ls -d "${PWD}"/* |
        sort
}

native(){
    input |
        "${bin}" \
        "${PWD}"
}

wasi(){
    input |
        wasmtime \
            run ./hs-path-abs2rel.wasm \
            "${PWD}"
}

#native
wasi

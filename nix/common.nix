{ darwin, iconv, lib, system, ... }:
with darwin.apple_sdk.frameworks; {

  RUSTFLAGS = lib.optionalString ("${system}" == "aarch64-darwin")
    "-Ctarget-cpu=apple-m1 " + "-C link-arg=-fuse-ld=lld";

  buildInputs = [ iconv ]
    ++ [ AudioUnit AudioToolbox CoreMIDI IOKit OpenAL CoreAudio ];

  COREAUDIO_SDK_PATH = "${CoreAudio}/Library/Frameworks";
  # LIBCLANG_PATH="${clang_17}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-fuse-ld=lld";
}

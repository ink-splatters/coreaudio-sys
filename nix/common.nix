{ darwin, iconv, lib, system, ... }:
with darwin.apple_sdk.frameworks; {

  RUSTFLAGS = lib.optionalString ("${system}" == "aarch64-darwin")
    "-Ctarget-cpu=apple-m1 " + "-C link-arg=-fuse-ld=lld";

  buildInputs = [ iconv ]
    ++ [ AudioUnit AudioToolbox CoreMIDI OpenAL CoreAudio ];
}

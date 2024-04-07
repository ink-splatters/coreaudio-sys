{ darwin, iconv, lib, system, ... }: {

  RUSTFLAGS = lib.optionalString ("${system}" == "aarch64-darwin")
    "-Ctarget-cpu=apple-m1 " + "-C link-arg=-fuse-ld=lld";

  buildInputs = with darwin.apple_sdk.frameworks; [ iconv CoreAudio ];
}

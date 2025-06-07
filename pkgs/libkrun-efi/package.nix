{
  cargo,
  fetchFromGitHub,
  lib,
  libepoxy,
  pkg-config,
  rustc,
  rustPlatform,
  rutabaga_gfx,
  stdenv,
  virglrenderer,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libkrun-efi";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0VDgCTTFgEeQYs1IK+3CBdW84eEnAhcYVTO2IxjyMF0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-dRGoaqfyXFCd5S3w88FL0Lva6uxRMPWccUN6iLcs+OE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cargo
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libepoxy
    virglrenderer
    rutabaga_gfx
  ];

  makeFlags = [
    "EFI=1"
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    mkdir -p $dev/lib
    mv $out/lib/pkgconfig $dev/lib
    mv $out/include $dev
  '';

  meta = with lib; {
    description = "Dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    platforms = platforms.darwin;
  };
})

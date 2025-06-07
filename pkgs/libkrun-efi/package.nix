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
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iFPJnv86wb0hU4QngdCCXP9cOpspDNVM8yFgS0XMdqg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-lDyY7InY3cUnbMg0Gw2oUL/xZOMCJD0tp1/Q9UdENR0=";
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

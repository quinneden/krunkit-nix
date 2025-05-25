{
  cargo,
  darwin,
  pkg-config,
  rustc,
  stdenv,
  fetchFromGitHub,
  libepoxy,
  libkrun-efi,
  rustPlatform,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krunkit";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "krunkit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iOd4UjmSrVuJPvWwP8GV2DWYsTWAXAXguXK4VxiDOko=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-9a76zZQqYoEVhh2rAysMLKA+dfjhtAFx5qXQkyCA8d0=";
  };

  nativeBuildInputs = [
    cargo
    darwin.sigtool
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libepoxy
    libkrun-efi
  ];

  makeFlags = [
    "LIBKRUN_EFI=${libkrun-efi}/lib/libkrun-efi.dylib"
    "PREFIX=${placeholder "out"}"
  ];

  dontStrip = true;

  postFixup = ''
    install_name_tool -change \
      libkrun-efi.dylib \
      ${libkrun-efi}/lib/libkrun-efi.dylib \
      $out/bin/krunkit

    codesign -f -s - \
      --entitlements ${finalAttrs.src}/krunkit.entitlements \
      $out/bin/krunkit
  '';

  meta = with lib; {
    description = "CLI tool to start VMs with libkrun";
    homepage = "https://github.com/containers/krunkit";
    license = licenses.asl20;
    maintainers = with maintainers; [ quinneden ];
    platforms = lib.platforms.darwin;
  };
})

final: prev: {
  virglrenderer = prev.virglrenderer.overrideAttrs (old: rec {
    version = "0.10.4d";
    src = prev.fetchurl {
      url = "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/${version}-krunkit/virglrenderer-${version}-krunkit.tar.bz2";
      hash = "sha256-M/buj97QUeY6CYeW0VICD5F6FBPi9ATPGHpNA48xL3o=";
    };
    buildInputs = with prev; [
      libepoxy
      moltenvk.dev
      vulkan-headers
      vulkan-loader
    ];
    mesonFlags = [
      (prev.lib.mesonBool "venus" true)
      (prev.lib.mesonBool "render-server" false)
      (prev.lib.mesonEnable "drm" false)
    ];
  });

  moltenvk = prev.moltenvk.overrideAttrs rec {
    version = "1.3.0";
    src = prev.fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "MoltenVK";
      rev = "v${version}";
      hash = "sha256-V69P1t48XP/pAPgpVsnFeCBidhHk60XGHRkHF6AEke0=";
    };
    patches = [ ];
  };
}

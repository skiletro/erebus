{
  sources,
  rustPlatform,
  stdenvNoCC,
  pkgs,
  ...
}:
let
  inherit (stdenvNoCC.hostPlatform) isDarwin isLinux;
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit (sources.pake) pname version src;

  cargoHash = "sha256-2a76j1BqhfiTwv2LcJdxfzzUHFfC0f3xzH5Ebvrhyas=";

  nativeBuildInputs =
    with pkgs;
    [
      cargo-tauri.hook
      nodejs
      pnpm_10.configHook
      pkg-config
    ]
    ++ lib.optionals isLinux [ pkgs.wrapGAppsHook4 ]
    ++ lib.optionals isDarwin [ pkgs.apple-sdk_11 ];

  buildInputs =
    with pkgs;
    lib.optionals isLinux [
      glib-networking
      openssl
      webkitgtk_4_1
    ];
    

    MACOSX_DEPLOYMENT_TARGET = "11.3";

  pnpmDeps = pkgs.pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-VmYEUyqyCJAzRDqR5rOLv+EbYfJ0NWBTljee85tUsZE=";
  };

  cargoRoot = "src-tauri";

  buildAndTestSubdir = finalAttrs.cargoRoot;
})

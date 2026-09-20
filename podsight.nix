# PodSight (https://github.com/arsin305/podsight) isn't in nixpkgs, so this
# builds it from source the way its own install.sh would: a pure-Python/GTK3
# app with no build step, just files copied into place and wrapped.
{
  lib,
  stdenv,
  python3,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  libwnck,
  glib,
  gdk-pixbuf,
  gtk-layer-shell,
  libayatana-appindicator,
  libx11,
  libxcomposite,
  libxrender,
  wmctrl,
  xdotool,
  src,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.pygobject3
    ps.pycairo
  ]);
in
stdenv.mkDerivation {
  pname = "podsight";
  version = "unstable-2026-08-28";

  inherit src;

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = [
    gtk3
    libwnck
    glib
    gdk-pixbuf
    gtk-layer-shell
    libayatana-appindicator
  ];

  dontBuild = true;
  dontConfigure = true;

  # NixOS has no ldconfig cache, so ctypes.util.find_library() — which
  # podsight uses to dlopen libX11/libXcomposite/libXrender directly for
  # fast XComposite thumbnail capture and global hotkeys — can't resolve
  # sonames the normal way and silently falls back to slow/disabled paths.
  # Point it at the exact store paths instead.
  postPatch = ''
    substituteInPlace podsight_pkg/platform.py \
      --replace-fail 'import ctypes, ctypes.util' \
      'import ctypes, ctypes.util
_NIX_LIB_PATHS = {
    "X11": "${lib.getLib libx11}/lib/libX11.so.6",
    "Xcomposite": "${lib.getLib libxcomposite}/lib/libXcomposite.so.1",
    "Xrender": "${lib.getLib libxrender}/lib/libXrender.so.1",
}
_orig_find_library = ctypes.util.find_library
def _find_library(name):
    return _NIX_LIB_PATHS.get(name) or _orig_find_library(name)
ctypes.util.find_library = _find_library'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/podsight
    cp podsight.py $out/share/podsight/
    cp -r podsight_pkg $out/share/podsight/

    install -Dm444 assets/podsight.svg \
      $out/share/icons/hicolor/scalable/apps/podsight.svg

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/podsight \
      --add-flags "$out/share/podsight/podsight.py" \
      --prefix PATH : ${lib.makeBinPath [ wmctrl xdotool ]}

    runHook postInstall
  '';

  meta = {
    description = "Live thumbnail previews for multiboxing EVE Online on Linux";
    homepage = "https://github.com/arsin305/podsight";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "podsight";
  };
}

{
  lib,
  stdenvNoCC,
  makeWrapper,
  python3,
  features ? { },
}:
let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      typer
    ]
  );
in
stdenvNoCC.mkDerivation {
  pname = "rig";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.fileFilter (f: f.hasExt "py") ./.;
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/rig
    cp -r ./. $out/lib/rig/
    mkdir -p $out/lib/features
    touch $out/lib/features/__init__.py

    ${lib.concatLines (
      lib.mapAttrsToList (name: src: ''
        cp -r ${src} $out/lib/features/${name}
      '') features
    )}

    chmod -R u+w $out/lib
    ${pythonEnv}/bin/python3 -m compileall -q $out/lib || true

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/rig \
      --add-flags "-m rig" \
      --prefix PYTHONPATH : "$out/lib"

    runHook postInstall
  '';

  meta.mainProgram = "rig";
}

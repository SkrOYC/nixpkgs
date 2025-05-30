{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  addDriverRunpath,
  makeWrapper,
  ocl-icd,
  vulkan-loader,
}:

let
  inherit (stdenv.hostPlatform.uname) processor;
  version = "6.4.0";
  sources = {
    "x86_64-linux" = {
      url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
      hash = "sha256-Q4MwU3dIFheKKSMxzCBZI8XoForaN41BuRGVMhJaUKw=";
    };
    "aarch64-linux" = {
      url = "https://cdn.geekbench.com/Geekbench-${version}-LinuxARMPreview.tar.gz";
      hash = "sha256-PZ95w2X4sqTLZGZ5wygt7WjSK4Gfgtdh/UCPo+8Ysc8=";
    };
  };
  geekbench_avx2 = lib.optionalString stdenv.hostPlatform.isx86_64 "geekbench_avx2";
in
stdenv.mkDerivation {
  inherit version;
  pname = "geekbench";

  src = fetchurl (
    sources.${stdenv.system} or (throw "unsupported system ${stdenv.hostPlatform.system}")
  );

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r geekbench.plar geekbench-workload.plar geekbench6 geekbench_${processor} ${geekbench_avx2} $out/bin

    for f in geekbench6 geekbench_${processor} ${geekbench_avx2} ; do
      wrapProgram $out/bin/$f \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            addDriverRunpath.driverLink
            ocl-icd
            vulkan-loader
          ]
        }"
    done

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform benchmark";
    homepage = "https://geekbench.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      michalrus
      asininemonkey
    ];
    platforms = builtins.attrNames sources;
    mainProgram = "geekbench6";
  };
}

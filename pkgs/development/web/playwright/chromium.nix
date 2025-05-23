{
  runCommand,
  makeWrapper,
  fontconfig_file,
  chromium,
  fetchzip,
  revision,
  suffix,
  system,
  throwSystem,
  ...
}:
let
  chromium-linux =
    runCommand "playwright-chromium"
      {
        nativeBuildInputs = [
          makeWrapper
        ];
      }
      ''
        mkdir -p $out/chrome-linux

        # See here for the Chrome options:
        # https://github.com/NixOS/nixpkgs/issues/136207#issuecomment-908637738
        # We add --disable-gpu to be able to run in gpu-less environments such
        # as headless nixos test vms.
        makeWrapper ${chromium}/bin/chromium $out/chrome-linux/chrome \
          --set-default SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
          --set-default FONTCONFIG_FILE ${fontconfig_file}
      '';
  chromium-darwin = fetchzip {
    url = "https://playwright.azureedge.net/builds/chromium/${revision}/chromium-${suffix}.zip";
    stripRoot = false;
    hash =
      {
        x86_64-darwin = "sha256-IJxCYtHTOtBxQdGbiLz+PODQL4rmBn4WXNJ3QNr0D/I=";
        aarch64-darwin = "sha256-6QP1OY1krhcfMf5rNzbd55W/Wg02LnbqaU7aKWhJ7qM=";
      }
      .${system} or throwSystem;
  };
in
{
  x86_64-linux = chromium-linux;
  aarch64-linux = chromium-linux;
  x86_64-darwin = chromium-darwin;
  aarch64-darwin = chromium-darwin;
}
.${system} or throwSystem

{
  stdenv,
  lib,
  fetchFromGitea,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "soundtouch";
  version = "2.3.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "soundtouch";
    repo = "soundtouch";
    rev = version;
    hash = "sha256-imeeTj+3gXxoGTuC/13+BAplwcnQ0wRJdSVt7MPlBxc=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  preConfigure = "./bootstrap";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Program and library for changing the tempo, pitch and playback rate of audio";
    homepage = "https://www.surina.net/soundtouch/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ orivej ];
    mainProgram = "soundstretch";
    platforms = platforms.all;
  };
}

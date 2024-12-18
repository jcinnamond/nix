{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "monolisa-jc";
  version = "0.x";
  src = ./ttf;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -r $src/*.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "My monolisa download";
    homepage = "https://monolisa.dev/";
    platforms = platforms.all;
  };
}

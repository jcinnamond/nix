{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "monolisa-jc-nerdfonts";
  version = "0.x";
  src = ./ttf;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -r $src/*.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "My monolisa download patched with Nerd Fonts";
    homepage = "https://monolisa.dev/";
    platforms = platforms.all;
  };
}

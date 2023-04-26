{ lib
, stdenv
}:

stdenv.mkDerivation {
  pname = "example";
  version = "1.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/linuxtage << EOF
    #!/usr/bin/env sh
    echo "Hello, world! Welcome to Grazer Linuxtage 2023!"
    EOF
    chmod +x $out/bin/linuxtage
  '';

  meta = with lib; {
    description = "An example package";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.totoroot ];
  };
}

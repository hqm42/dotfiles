with import <nixpkgs> {};

{
  rbenv = stdenv.mkDerivation rec {
    name = "rbenv";
   
    src = fetchFromGitHub {
      owner = "rbenv";
      repo = "rbenv";
      rev = "c7dcaf12593837eeb8d46b69bccf3d28666b728c";
      sha256 = "1857phpp7vlq533f4akns26xhgszg229yxq0frh1rxd30447wlfs";
    };
   
    dontBuild = true;
   
    installPhase = ''
      mkdir $out
      cp -r * $out
    '';
  };

  rubybuild =  stdenv.mkDerivation rec {
    name = "rubybuild";
   
    src = fetchFromGitHub {
      owner = "rbenv";
      repo = "ruby-build";
      rev = "c9ba074411871b956133e98676a66c40a33395bd";
      sha256 = "0c6b1yqrx41wa4aw156a0bs2ls9ndlchnrn4s6rsvyxbgw29gq1v";
    };
   
    dontBuild = true;
   
    installPhase = ''
      mkdir $out
      PREFIX=$out ./install.sh
    '';
  };

  elasticsearchPlugins.elasticsearch_kopf = stdenv.mkDerivation rec {
    name = "elasticsearch-kopf-${version}";
    pluginName = "elasticsearch-kopf";
    version = "2.1.1";
    src = fetchurl {
      url = "https://github.com/lmenezes/elasticsearch-kopf/archive/v${version}.zip";
      sha256 = "1nwwd92g0jxhfpkxb1a9z5a62naa1y7hvlx400dm6mwwav3mrf4v";
    };

    unpackPhase = "true";

    buildInputs = [ unzip nettools ];

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${elasticsearch2}/lib $out/lib
      ES_HOME=$out ${elasticsearch2}/bin/elasticsearch-plugin install file://$src
    '';
  };

  mybackground = stdenv.mkDerivation rec {
    name = "mybackground-hqm42";
    
    Background = fetchurl {
      url = https://raw.githubusercontent.com/beekay-/earthview-wallpapers/ecd5cceccd40a2a99a8836a72292dbca3d080419/img/mellum-germany-49.jpg;
      sha256 = "0m1mx5mfazrqicxh5ckvw19qb1z9cqjdqsjbn056jgf7m0l5qa0y";
    };

    unpackPhase = "true";

    installPhase = ''
      mkdir -p $out/share/background
      ln -s $Background $out/share/background/background.jpg
    '';
  };
}

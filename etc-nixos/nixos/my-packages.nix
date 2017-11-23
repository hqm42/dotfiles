with import <nixpkgs> {};

{
  rbenv = stdenv.mkDerivation rec {
    name = "rbenv";
   
    src = fetchFromGitHub {
      owner = "rbenv";
      repo = "rbenv";
      rev = "4f8925abe7e4b373156bba9cc5310e8e0d04a28a";
      sha256 = "08rcx60snlvwgj2s8jj4b7lg9bncm2149rqimbly00h5ilkh1n5p";
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
      rev = "0e561adbe6c5b1280b2d47f20de47bea18267d92";
      sha256 = "1zvb3fh0jkrl5gikv32qm9fa84249c7m67plcnrk637j546plppb";
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

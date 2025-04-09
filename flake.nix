{
  description = "fastplotlib";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    pypkgs = pkgs.python312Packages;
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    cmap = pypkgs.buildPythonPackage rec {
      pname = "cmap";
      version = "0.6.0";
      build-system = with pypkgs; [ hatchling hatch-vcs ];
      propagatedBuildInputs = with pypkgs; [ numpy ];
      format = "pyproject";
      src = pypkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-JrMFhH59ci8b5CwrM5QXIicR2hOFL5oSOleg0QCCcZc=";
      };
    };
    pylinalg = pypkgs.buildPythonPackage rec {
      pname = "pylinalg";
      version = "0.6.7";
      build-system = with pypkgs; [ flit ];
      propagatedBuildInputs = with pypkgs; [ numpy ];
      format = "pyproject";
      src = pypkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-w/DQHZNhKexLnPzdLMT2g4Kno+3gpalEgJEnnhGH8gQ=";
      };
    };
    rendercanvas = pypkgs.buildPythonPackage rec {
      pname = "rendercanvas";
      version = "2.0.3";
      propagatedBuildInputs = with pypkgs; [ sniffio ];
      build-system = with pypkgs; [ flit ];
      format = "pyproject";
      src = pypkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-WBfNZSqMxHbPYLAmh4uljhemBg6WWBUt4UO/wjQuCuQ=";
      };
    };
    pygfx = pypkgs.buildPythonPackage rec {
      pname = "pygfx";
      version = "0.9.0";
      build-system = with pypkgs; [ flit ];
      propagatedBuildInputs = with pypkgs; [ rendercanvas wgpu-py pylinalg numpy freetype-py uharfbuzz jinja2 hsluv ];
      format = "pyproject";
      src = pypkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-gJKMMOlSVJK6i5+pDkVCLoM95wLHIhB0JQ0Pn2HZ838=";
      };
    };
    fastplotlib = pypkgs.buildPythonPackage rec {
      pname = "fastplotlib";
      version = "0.4.0";
      buildInputs = with pypkgs; [ setuptools ];
      propagatedBuildInputs = with pypkgs; [ wgpu-py numpy pygfx cmap];
      format = "pyproject";
      src = pkgs.python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "sha256-V9kqz5f+rfIAn5xOEtK+114LwZnIAWzRTQnNj5wBtSk=";
      };
    };
  in {
    packages.x86_64-linux.fastplotlib = fastplotlib;
    devShell.x86_64-linux = pkgs.mkShell {
      name = "fpl-dev-shell";
      buildInputs = [
        fastplotlib
        pypkgs.pyqt6
      ];
    };
  };
}

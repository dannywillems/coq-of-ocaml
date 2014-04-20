# CoqOfOCaml

Compiler of OCaml to Coq. Still experimental.

## Compile
You have two parts to compile in order.

### The Coq library
Go to `OCaml/` and run:

    ./configure.sh
    make
    make install

### The compiler
Run:

    make
    make test

## Usage
It compiles the `.cmt` files (generated by the OCaml compiler using the option `-bin-annot`) to Coq definitions and print it on the standard output:

    ./coqOfOCaml.native -mode coq file.cmt

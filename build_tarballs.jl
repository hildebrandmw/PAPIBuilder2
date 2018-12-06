# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "papi"
version = v"0.1.0"

# Collection of sources required to build papi
sources = [
    "https://bitbucket.org/icl/papi.git" =>
    #"2a7e8e3b1d609dcc3a93b6e7daf36a372c35b3f8", # master
    "b2d6558c481391f15000ae023c5dc4fee73dc4e6", # stable-5.5.1
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd papi/src
./configure --prefix=$prefix --host=$target
make -j${nprocs}
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libpapi", :libpapi),
    LibraryProduct(prefix, "libpfm", :libpfm)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)



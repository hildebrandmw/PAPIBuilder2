# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "papi"
version = v"0.2.0"

# Collection of sources required to build papi
sources = [
    "https://sourceforge.net/projects/perfmon2/files/libpfm4/libpfm-4.10.1.tar.gz" =>
    "c61c575378b5c17ccfc5806761e4038828610de76e2e34fac9f7fa73ba844b49",

    "https://bitbucket.org/icl/papi.git" =>
    "0fdac4fc7f95f0ac8039e431419a5133088911af",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libpfm-4.10.1/
make -j${nprocs}
make PREFIX=$prefix install
mkdir $prefix/bin
cp examples/showevtinfo $prefix/bin/showevtinfo
cp examples/check_events $prefix/bin/check_events

cd ../papi/src
./configure --prefix=$prefix --host=$host --enable-perfevent-rdpmc=no
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
    LibraryProduct(prefix, "libpfm", :libpfm),
    ExecutableProduct(prefix, "check_events", :check_events),
    ExecutableProduct(prefix, "showevtinfo", :showevtinfo),
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)



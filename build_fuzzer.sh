ANGORA_LOC=/local_home/cheong/Angora_func
FUZZ_LOC=${ANGORA_LOC}

mkdir ${FUZZ_LOC}/subjects
mkdir ${FUZZ_LOC}/FInfos

rm -rf ../oniguruma_build
mkdir ../oniguruma_build

rm -rf ../oniguruma_install
mkdir ../oniguruma_install

rm ./CMakeCache.txt
cd ../oniguruma_build

CC=gclang CXX=gclang++ cmake -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_INSTALL_PREFIX=/local_home/cheong/subjects/oniguruma_install \
  ../oniguruma
make -j 5
make install

cd ../oniguruma
gclang++ fuzzer.cpp -L../oniguruma_install/lib -I../oniguruma_install/include -lonig -o oniguruma_fuzzer
get-bc oniguruma_fuzzer
${FUZZ_LOC}/bin/angora-clang oniguruma_fuzzer.bc -o ${FUZZ_LOC}/subjects/oniguruma_fuzzer.fast
mv FuncInfo.txt ${FUZZ_LOC}/FInfos/FuncInfo-oniguruma.txt
USE_TRACK=1 ${FUZZ_LOC}/bin/angora-clang oniguruma_fuzzer.bc -o ${FUZZ_LOC}/subjects/oniguruma_fuzzer.tt

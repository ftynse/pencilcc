#! /bin/sh
set -e # Fail if any subcommand fails

echo "pwd=`pwd`"
echo "PENCILCC=${PENCILCC}"
echo "TESTSRCDIR=${TESTSRCDIR}"
echo "TESTBUILDDIR=${TESTBUILDDIR}"

cd "${TESTBUILDDIR}"
${PENCILCC} -vv -O3 --target=cuda -Werror "${TESTSRCDIR}/multilink_kernel1.pencil.c" "${TESTSRCDIR}/multilink_kernel2.pencil.c" "${TESTSRCDIR}/multilink_main.c" --run
#!/bin/sh

CC="${1}"
# Make sure we have enough version components
HDR_VER="${2}.0.0"

HDR_M="${HDR_VER%%.*}"
HDR_V="${HDR_VER#*.}"
HDR_m="${HDR_V%%.*}"

EXEC="/tmp/br.check-headers.$(uuidgen)"

# By the time we get here, we do not always have the staging-dir
# already populated (think external toolchain), so we can not use
# it.
# So we just ask the cross compiler what its default sysroot is.
# For multilib-aware toolchains where we should use a non-default
# sysroot, it's not really a problem since the version of the kernel
# headers is the same for all sysroots.
SYSROOT=$(${CC} -print-sysroot)

# We do not want to account for the patch-level, since headers are
# not supposed to change for different patchlevels, so we mask it out.
# This only applies to kernels >= 3.0, but those are the only one
# we actually care about; we treat all 2.6.x kernels equally.
${HOSTCC} -imacros "${SYSROOT}/usr/include/linux/version.h" \
          -x c -o "${EXEC}" - <<_EOF_
#include <stdio.h>
#include <stdlib.h>

int main(int argc __attribute__((unused)),
         char** argv __attribute__((unused)))
{
    if((LINUX_VERSION_CODE & ~0xFF)
        != KERNEL_VERSION(${HDR_M},${HDR_m},0))
    {
        printf("Incorrect selection of kernel headers: ");
        printf("expected %d.%d.x, got %d.%d.x\n", ${HDR_M}, ${HDR_m},
               ((LINUX_VERSION_CODE>>16) & 0xFF),
               ((LINUX_VERSION_CODE>>8) & 0xFF));
        return 1;
    }
    return 0;
}
_EOF_

"${EXEC}"
ret=${?}
rm -f "${EXEC}"
exit ${ret}

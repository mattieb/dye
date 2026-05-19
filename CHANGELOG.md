# 1.0.0

Initial version.

# 1.1.0

-   Adds [templates](./README.md#templates) and the "dye print" and "dye write" commands to use them. Templates are more concise than any other way of using dye and are expected to be the main interface in future major versions.

-   Deprecated [wrapping text](./README.md#wrapping-text) because of its sharp edges.

-   Fixed an issue where, if dye decided to disable color, "unbound variable" errors could be printed in some circumstances.

# 1.1.1

-   SECURITY: Changes the implementation of dye template expressions to stop shell commands from being injected in text. For a full writeup, see [Security advisory: dye template injection](https://mattiebee.io/dye-template-advisory/). This issue was discovered and fixed by dye's author, and is not known to be exploited.

# 1.1.2

-   Adds support for Debian's [Policy-compliant Ordinary SHell](https://tracker.debian.org/pkg/posh).

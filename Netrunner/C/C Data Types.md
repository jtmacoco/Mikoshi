**Source**: [[Netrunner]]
**Tags**: #data-types #c
**Description**: Reference for C data types
## Basic Integer Types

| Type | Typical Size (bytes) | Range (typical, signed unless noted) | Format Specifier | Notes |
|---|---|---|---|---|
| `char` | 1 | -128 to 127 (implementation-defined signedness) | `%c` | Smallest addressable unit; size guaranteed to be 1 byte by standard |
| `signed char` | 1 | -128 to 127 | `%c` / `%hhd` | Explicitly signed |
| `unsigned char` | 1 | 0 to 255 | `%c` / `%hhu` | Often used for raw byte data |
| `short` / `short int` | 2 | -32,768 to 32,767 | `%hd` | At least 16 bits guaranteed |
| `unsigned short` | 2 | 0 to 65,535 | `%hu` | |
| `int` | 4 | -2,147,483,648 to 2,147,483,647 | `%d` / `%i` | At least 16 bits guaranteed (4 on most modern systems) |
| `unsigned int` | 4 | 0 to 4,294,967,295 | `%u` | |
| `long` / `long int` | 4 (Windows) / 8 (Linux/macOS) | -2,147,483,648 to 2,147,483,647 (32-bit) | `%ld` | At least 32 bits guaranteed; size varies by platform/OS |
| `unsigned long` | 4 or 8 | 0 to 4,294,967,295 (32-bit) | `%lu` | |
| `long long` / `long long int` | 8 | -9.2×10¹⁸ to 9.2×10¹⁸ | `%lld` | At least 64 bits guaranteed (C99+) |
| `unsigned long long` | 8 | 0 to 1.8×10¹⁹ | `%llu` | |

## Floating-Point Types

| Type | Typical Size (bytes) | Precision | Range (approx) | Format Specifier |
|---|---|---|---|---|
| `float` | 4 | ~6-7 significant digits | ±3.4×10³⁸ | `%f` |
| `double` | 8 | ~15-16 significant digits | ±1.7×10³⁰⁸ | `%lf` |
| `long double` | 8, 12, or 16 (platform-dependent) | ~18-19+ significant digits | ±1.1×10⁴⁹³² (x86 extended) | `%Lf` |

## Other Basic Types

| Type | Typical Size (bytes) | Notes |
|---|---|---|
| `void` | n/a (incomplete type) | Represents "no type"; used for functions returning nothing, generic pointers (`void*`) |
| `_Bool` / `bool` (C99, via `<stdbool.h>`) | 1 | Values `0` or `1`; `bool`, `true`, `false` are macros from `stdbool.h` |
| `wchar_t` (`<wchar.h>`) | 2 (Windows) / 4 (Linux) | Wide character type, platform-dependent size |
| `char16_t` (C11, `<uchar.h>`) | 2 | UTF-16 code unit |
| `char32_t` (C11, `<uchar.h>`) | 4 | UTF-32 code unit |

## Derived / Compound Types

| Type                            | Size                                    | Notes                                                                                          |
| ------------------------------- | --------------------------------------- | ---------------------------------------------------------------------------------------------- |
| Pointer (`int*`, `char*`, etc.) | 4 (32-bit systems) / 8 (64-bit systems) | Size is consistent across pointer types on a given platform (except some exotic architectures) |
| Array (`int arr[10]`)           | `sizeof(type) * n`                      | Contiguous block of elements                                                                   |
| `struct`                        | Sum of members + padding                | Size affected by alignment/padding rules; use `sizeof()` to check                              |
| `union`                         | Size of largest member                  | All members share the same memory                                                              |
| `enum`                          | Typically 4 (same as `int`)             | Implementation-defined; compiler may choose smaller type if values fit                         |
| Function pointer                | 4 or 8 (platform-dependent)             | Same general size as data pointers on most platforms                                           |

## Fixed-Width Integer Types (`<stdint.h>`, C99+)

| Type        | Size (bytes) | Range                                   |
| ----------- | ------------ | --------------------------------------- |
| `int8_t`    | 1            | -128 to 127                             |
| `uint8_t`   | 1            | 0 to 255                                |
| `int16_t`   | 2            | -32,768 to 32,767                       |
| `uint16_t`  | 2            | 0 to 65,535                             |
| `int32_t`   | 4            | -2,147,483,648 to 2,147,483,647         |
| `uint32_t`  | 4            | 0 to 4,294,967,295                      |
| `int64_t`   | 8            | -9.2×10¹⁸ to 9.2×10¹⁸                   |
| `uint64_t`  | 8            | 0 to 1.8×10¹⁹                           |
| `intptr_t`  | 4 or 8       | Large enough to hold a pointer          |
| `uintptr_t` | 4 or 8       | Unsigned version of above               |
| `intmax_t`  | 8            | Largest signed integer type available   |
| `uintmax_t` | 8            | Largest unsigned integer type available |

## Size/Utility Types (various headers)

| Type        | Header                  | Typical Size                  | Notes                                                         |
| ----------- | ----------------------- | ----------------------------- | ------------------------------------------------------------- |
| `size_t`    | `<stddef.h>`            | 4 or 8 (matches pointer size) | Unsigned; returned by `sizeof`, used for array indexing/loops |
| `ssize_t`   | `<sys/types.h>` (POSIX) | 4 or 8                        | Signed version of `size_t`, used for error returns (-1)       |
| `ptrdiff_t` | `<stddef.h>`            | 4 or 8                        | Signed; result of subtracting two pointers                    |
| `time_t`    | `<time.h>`              | 4 or 8                        | Represents calendar time                                      |
| `clock_t`   | `<time.h>`              | 4 or 8                        | Represents processor time                                     |
| `FILE`      | `<stdio.h>`             | implementation-defined        | Opaque struct for file streams                                |

## Quick Notes

- **Sizes are not guaranteed by the C standard** — only minimum ranges are guaranteed. Always use `sizeof()` to confirm on your target platform.
- The only standard-guaranteed relationship: `sizeof(char) <= sizeof(short) <= sizeof(int) <= sizeof(long) <= sizeof(long long)`.
- `sizeof(char)` is always exactly `1` byte by definition (though a "byte" isn't always 8 bits on exotic systems).
- Use `<stdint.h>` fixed-width types (`int32_t`, `uint64_t`, etc.) when you need guaranteed, portable sizes.
- Data model naming for reference: `LP64` (Linux/macOS 64-bit: long & pointer = 8 bytes), `LLP64` (Windows 64-bit: long = 4 bytes, long long & pointer = 8 bytes), `ILP32` (32-bit systems: int, long, pointer = 4 bytes).
---
title: Enums
source: "[[C++]]"
tags:
  - cpp
  - enums
type: reference
created: 2026-08-16
---
## Enums and Enum Classes

```cpp
enum class Color { Red, Green, Blue };  // scoped, type-safe (preferred)
enum LegacyColor { RED, GREEN, BLUE };  // unscoped, leaks into enclosing scope
```

## When to use

- `enum class` for any new code — avoids naming collisions and implicit conversions to `int`.
- Plain `enum` mainly for legacy compatibility or interop with C APIs.

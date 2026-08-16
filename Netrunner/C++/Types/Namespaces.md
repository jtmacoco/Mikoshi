---
title: Namespaces
source: "[[C++]]"
tags:
  - cpp
  - namespace
type: reference
created: 2026-08-16
---
# Namespaces

Namespaces group related names (functions, [[Classes|classes]], variables) to avoid naming collisions.

```cpp
namespace geometry {
    struct Point { double x, y; };

    double distance(const Point& a, const Point& b);
}

// Usage
geometry::Point p{1.0, 2.0};
```

## Key facts

- Prevents collisions between libraries/modules that might define the same name (e.g., two libraries both defining `Vector`).
- `using namespace X;` brings names into scope — convenient but risky in headers (pollutes every file that includes it).
- Can be nested: `namespace outer::inner { ... }` (C++17+).
- Anonymous namespaces (`namespace { ... }`) give internal linkage — similar to `static` at file scope, hiding symbols from other translation units.

## When to use

- Organizing a library or large codebase into logical modules (`app::ui`, `app::network`, etc.).
- Avoiding symbol clashes when integrating multiple third-party libraries.
- Preventing accidental use of internal-only helper functions (via anonymous namespaces).
- Math functionality
- No instances, no state, no behavior, just label scope

## Avoid

- `using namespace std;` in header files — leaks into every file that includes the header.
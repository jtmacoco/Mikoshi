---
title: Structs
source: "[[C++]]"
tags:
  - structs
  - cpp
type: reference
created: 2026-08-16
---
## Structs

A `struct` groups related data together.

```cpp
struct Point {
    double x;
    double y;
};

Point p1 {3.0, 4.0};
```

## Key facts

- Members are `public` by default.
- Inheritance is `public` by default.
- Can have constructors, methods, operator overloads, and even virtual functions — in C++, structs are functionally almost identical to [[Classes|classes]].

## When to use

- Plain data containers ("POD" — Plain Old Data) with little or no behavior.
- When you want a lightweight, public-by-default aggregate (e.g., a 3D vector, a config struct, a return type bundling multiple values).
- Conventionally signals "this is just data" to other developers, even though the compiler doesn't enforce that meaning.

cpp

```cpp
struct Config {
    int width = 800;
    int height = 600;
    bool fullscreen = false;
};
```

## Struct vs Class — rule of thumb

| Use `struct`                | Use [[Classes\|class]]          |
| --------------------------- | ------------------------------- |
| Passive data, no invariants | Data with invariants to enforce |
| Public access is fine       | Need to hide/protect internals  |
| Small, simple aggregates    | Any complex behavio             |
## Links

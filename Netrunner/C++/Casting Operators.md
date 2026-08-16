---
title: Casting Operators
source: "[[C++]]"
tags:
  - cpp
  - casting
type: cheatsheet
created: 2026-08-15
---
---

# C++ Casting Operators — Cheat Sheet

> [!summary] Quick Reference
> 
> |Operator|Checked at|Typical Use|
> |---|---|---|
> |`static_cast`|Compile-time|Related types, numeric conversions, up/downcasts (unchecked)|
> |`dynamic_cast`|Run-time|Safe downcasting in polymorphic hierarchies|
> |`const_cast`|Compile-time|Add/remove `const` or `volatile`|
> |`reinterpret_cast`|None (raw bitwise)|Low-level reinterpretation (pointers, integers)|
> |C-style `(T)x`|—|Avoid — does one of the above, unclear which|

---

## `static_cast`

### What is

The general-purpose, compile-time-checked cast. Converts between related types (numeric types, pointer up/downcasts, enum ↔ int, etc.) where the compiler can verify the conversion makes sense.

Basically tell the compiler these two types are related enough that this conversion makes sense. The compiler checks that conversion is reasonable at compile time, but it doesn't do any safety checks while the program is running.

### Example / Usage

```cpp
double d = 3.14;
int i = static_cast<int>(d);          // narrowing numeric conversion

Base* b = new Derived();
Derived* d2 = static_cast<Derived*>(b); // downcast, NOT checked at runtime

enum class Color { Red, Green, Blue };
int c = static_cast<int>(Color::Green);
```

### When to Use

- Converting between numeric types (`int` ↔ `float`, etc.)
- Upcasting (Derived → Base) — always safe
- Downcasting when you are **certain** of the actual type
- Converting `void*` back to a known type
- Enum ↔ integer conversions

> [!warning] Watch Out For
> 
> - No runtime check — downcasting to the wrong type is **undefined behavior**, not an error.
> - Silently truncates/narrows numeric values (e.g. `double` → `int` drops the fraction) with no warning.
> - Can't cast away `const`/`volatile` — use `const_cast` for that.

---

## `dynamic_cast`

### What is

A **runtime-checked** cast used almost exclusively for safely navigating polymorphic class hierarchies (classes with at least one `virtual` function).

### Example / Usage

```cpp
class Animal { public: virtual ~Animal() = default; };
class Dog : public Animal { public: void bark() {} };

Animal* a = new Dog();

// Pointer form: returns nullptr on failure
if (Dog* d = dynamic_cast<Dog*>(a)) {
    d->bark();
}

// Reference form: throws std::bad_cast on failure
try {
    Dog& dref = dynamic_cast<Dog&>(*a);
} catch (const std::bad_cast& e) {
    // handle failed cast
}
```

### When to Use

- Downcasting when you're **not sure** the object is actually the derived type
- Implementing visitor-like patterns or type checks in a class hierarchy
- Any time correctness matters more than speed

> [!warning] Watch Out For
> 
> - Requires the base class to be **polymorphic** (have a vtable) — won't compile otherwise.
> - Has runtime overhead (RTTI lookup) — avoid in hot loops.
> - Pointer form returns `nullptr` on failure (check it!); reference form **throws** — mismatched handling is a common bug.
> - Frequent use often signals a design smell (consider virtual functions instead).

---

## `const_cast`

### What is

The only cast that can add or remove `const` (or `volatile`) qualification. Does not change the underlying type or bit pattern.

### Example / Usage

```cpp
void legacyFunction(char* str); // doesn't modify str, but isn't marked const

void wrapper(const char* str) {
    legacyFunction(const_cast<char*>(str));
}

const int x = 10;
int& ref = const_cast<int&>(x); // dangerous, see below
```

### When to Use

- Interfacing with older/legacy APIs that aren't `const`-correct but you know won't mutate the data
- Calling a non-const overload of a member function from within a const one (rare, careful use)

> [!warning] Watch Out For
> 
> - If the original object was actually declared `const`, modifying it through the cast is **undefined behavior**.
> - It's a code smell — usually signals the API design (yours or a library's) should be fixed instead.
> - Does **not** convert between unrelated types — only tweaks const/volatile qualifiers.

---

## `reinterpret_cast`

### What is

A low-level, "trust me" cast that reinterprets the raw bit pattern of one type as another. No safety checks, no conversions — just relabeling.

### Example / Usage

```cpp
int i = 65;
char* p = reinterpret_cast<char*>(&i);   // view int's bytes as chars

uintptr_t addr = reinterpret_cast<uintptr_t>(somePointer); // pointer -> integer

struct A {}; struct B {};
A* a = new A();
B* b = reinterpret_cast<B*>(a); // compiles, almost certainly wrong to use
```

### When to Use

- Low-level systems/embedded code: talking to hardware registers, serialization, byte-level manipulation
- Converting between pointer types and integer types (e.g. for hashing an address)
- Working with raw memory buffers

> [!warning] Watch Out For
> 
> - Extremely unsafe — the compiler will let you cast almost anything to anything.
> - Result is implementation-defined / platform-dependent; **not portable**.
> - Dereferencing a `reinterpret_cast`'d pointer of the wrong type is undefined behavior (strict aliasing violation).
> - If you find yourself reaching for this outside of low-level/systems code, reconsider the design first.

---

## C-style Cast — `(Type)value`

### What is

The old C-style cast inherited by C++. Silently picks whichever of `static_cast`, `const_cast`, or `reinterpret_cast` (or a combination) seems to "work" — with no indication in the code of which one it chose.

### Example / Usage

```cpp
double d = 3.14;
int i = (int)d;          // acts like static_cast

const char* s = "hi";
char* s2 = (char*)s;     // acts like const_cast

Base* b = ...;
Derived* d2 = (Derived*)b; // acts like static_cast, unchecked downcast
```

### When to Use

- Basically never in new C++ code.
- You may still see/maintain it in legacy codebases or C-interop headers.

> [!warning] Watch Out For
> 
> - Impossible to `grep` for or search safely — named casts are far easier to find and audit.
> - Hides which conversion is actually happening, including potentially removing `const` unintentionally.
> - No compiler distinction between a safe conversion and a dangerous reinterpretation.

---

## Decision Guide

> [!question] Which cast do I reach for?
> 
> - Just converting numbers, or upcasting/known-safe downcast? → **`static_cast`**
> - Downcasting and unsure of the real type? → **`dynamic_cast`**
> - Need to add/strip `const`? → **`const_cast`**
> - Reinterpreting raw memory/pointers at a low level? → **`reinterpret_cast`**
> - Seeing `(Type)value` in code you're editing? → Replace it with one of the above.
---
title: Classes
source: "[[C++]]"
tags:
  - cpp
  - classes
type: reference
created: 2026-08-16
---
# Classes

A `class` bundles data (members) and behavior (methods), with encapsulation as the default.


```cpp
class BankAccount {
public:
    BankAccount(double balance) : balance_(balance) {}

    void deposit(double amount) { balance_ += amount; }
    double getBalance() const { return balance_; }

private:
    double balance_;
};
```

## Key facts

- Members are `private` by default.
- Inheritance is `private` by default.
- Same underlying mechanics as [[Structs|struct]] (`struct` is literally `class` with different default access).

## When to use

- When an object has invariants to protect (e.g., a bank account balance shouldn't be settable to anything without validation).
- When you want to hide implementation details behind a clean interface.
- When behavior (methods) is central to the type, not just data storage.

## Struct vs Class — rule of thumb

| Use [[Structs\|struct]]     | Use `class`                     |
| --------------------------- | ------------------------------- |
| Passive data, no invariants | Data with invariants to enforce |
| Public access is fine       | Need to hide/protect internals  |
| Small, simple aggregates    | Any complex behavior/logic      |
## Links
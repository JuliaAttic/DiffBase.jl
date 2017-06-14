# `diffrule` API

```@meta
CurrentModule = DiffBase
```

Many differentiation methods rely on the notion of "primitive" definitions that
comprise "building blocks" that can be composed via various formulations of the
chain rule.

To facilitate the definition and use of such rules, DiffBase provides the `diffrule` API.
These methods  allows you to define derivative rules, query which rules exist, and symbolically
apply the rules to function call expressions.

The complete list of differentiation rules defined by DiffBase can be found in
[`DiffBase/src/rules.jl`](https://github.com/JuliaDiff/DiffBase.jl/blob/master/src/rules.jl).

```@docs
DiffBase.@define_diffrule
DiffBase.diffrule
DiffBase.hasdiffrule
```

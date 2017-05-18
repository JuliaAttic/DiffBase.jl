var documenterSearchIndex = {"docs": [

{
    "location": "diffresult.html#",
    "page": "DiffResult API Documentation",
    "title": "DiffResult API Documentation",
    "category": "page",
    "text": ""
},

{
    "location": "diffresult.html#DiffResult-API-Documentation-1",
    "page": "DiffResult API Documentation",
    "title": "DiffResult API Documentation",
    "category": "section",
    "text": "CurrentModule = DiffBaseSupported By:ForwardDiff\nReverseDiffMany differentiation techniques can calculate primal values and multiple orders of derivatives simultaneously. In other words, there are techniques for computing f(x), ∇f(x) and H(f(x)) in one fell swoop!For this purpose, DiffBase provides the DiffResult type, which can be passed to in-place differentiation methods instead of an output buffer. The method then loads all computed results into the given DiffResult, which the user can query afterwards using DiffBase's API.Here's an example of the DiffResult in action using ForwardDiff:julia> using ForwardDiff, DiffBase\n\njulia> f(x) = sum(sin, x) + prod(tan, x) * sum(sqrt, x);\n\njulia> x = rand(4);\n\n# construct a `DiffResult` with storage for a Hessian, gradient,\n# and primal value based on the type and shape of `x`.\njulia> result = DiffBase.HessianResult(x)\n\n# instead of passing an output buffer to `hessian!`, we pass `result`\njulia> ForwardDiff.hessian!(result, f, x);\n\n# ...and now we can get all the computed data from `result`\njulia> DiffBase.value(result) == f(x)\ntrue\n\njulia> DiffBase.gradient(result) == ForwardDiff.gradient(f, x)\ntrue\n\njulia> DiffBase.hessian(result) == ForwardDiff.hessian(f, x)\ntrueThe rest of this document describes the API for constructing, accessing, and mutating DiffResult instances. For details on how to use a DiffResult with a specific package's methods, please consult that package's documentation."
},

{
    "location": "diffresult.html#DiffBase.DiffResult",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.DiffResult",
    "category": "Type",
    "text": "DiffResult(value::Union{Number,AbstractArray}, derivs::Tuple{Vararg{Number}})\nDiffResult(value::Union{Number,AbstractArray}, derivs::Tuple{Vararg{AbstractArray}})\n\nReturn r::DiffResult, with output value storage provided by value and output derivative storage provided by derivs.\n\nIn reality, DiffResult is an abstract supertype of two concrete types, MutableDiffResult and ImmutableDiffResult. If all value/derivs are all Numbers or SArrays, then r will be immutable (i.e. r::ImmutableDiffResult). Otherwise, r will be mutable (i.e. r::MutableDiffResult).\n\nNote that derivs can be provide in splatted form, i.e. DiffResult(value, derivs...).\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.JacobianResult",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.JacobianResult",
    "category": "Function",
    "text": "JacobianResult(x::AbstractArray)\n\nConstruct a DiffResult that can be used for Jacobian calculations where x is the input to the target function. This method assumes that the target function's output dimension equals its input dimension.\n\nNote that JacobianResult allocates its own storage; x is only used for type and shape information. If you want to allocate storage yourself, use the DiffResult constructor instead.\n\n\n\nJacobianResult(y::AbstractArray, x::AbstractArray)\n\nConstruct a DiffResult that can be used for Jacobian calculations where x is the input to the target function, and y is the output (e.g. when taking the Jacobian of f!(y, x)).\n\nLike the single argument version, y and x are only used for type and shape information and are not stored in the returned DiffResult.\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.GradientResult",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.GradientResult",
    "category": "Function",
    "text": "GradientResult(x::AbstractArray)\n\nConstruct a DiffResult that can be used for gradient calculations where x is the input to the target function.\n\nNote that GradientResult allocates its own storage; x is only used for type and shape information. If you want to allocate storage yourself, use the DiffResult constructor instead.\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.HessianResult",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.HessianResult",
    "category": "Function",
    "text": "HessianResult(x::AbstractArray)\n\nConstruct a DiffResult that can be used for Hessian calculations where x is the input to the target function.\n\nNote that HessianResult allocates its own storage; x is only used for type and shape information. If you want to allocate storage yourself, use the DiffResult constructor instead.\n\n\n\n"
},

{
    "location": "diffresult.html#Constructing-DiffResults-1",
    "page": "DiffResult API Documentation",
    "title": "Constructing DiffResults",
    "category": "section",
    "text": "DiffBase.DiffResult\nDiffBase.JacobianResult\nDiffBase.GradientResult\nDiffBase.HessianResult"
},

{
    "location": "diffresult.html#DiffBase.value",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.value",
    "category": "Function",
    "text": "value(r::DiffResult)\n\nReturn the primal value stored in r.\n\nNote that this method returns a reference, not a copy.\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.derivative",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.derivative",
    "category": "Function",
    "text": "derivative(r::DiffResult, ::Type{Val{i}} = Val{1})\n\nReturn the ith derivative stored in r, defaulting to the first derivative.\n\nNote that this method returns a reference, not a copy.\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.gradient",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.gradient",
    "category": "Function",
    "text": "gradient(r::DiffResult)\n\nReturn the gradient stored in r.\n\nEquivalent to derivative(r, Val{1}); see derivative docs for aliasing behavior.\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.jacobian",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.jacobian",
    "category": "Function",
    "text": "jacobian(r::DiffResult)\n\nReturn the Jacobian stored in r.\n\nEquivalent to derivative(r, Val{1}); see derivative docs for aliasing behavior.\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.hessian",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.hessian",
    "category": "Function",
    "text": "hessian(r::DiffResult)\n\nReturn the Hessian stored in r.\n\nEquivalent to derivative(r, Val{2}); see derivative docs for aliasing behavior.\n\n\n\n"
},

{
    "location": "diffresult.html#Accessing-data-from-DiffResults-1",
    "page": "DiffResult API Documentation",
    "title": "Accessing data from DiffResults",
    "category": "section",
    "text": "DiffBase.value\nDiffBase.derivative\nDiffBase.gradient\nDiffBase.jacobian\nDiffBase.hessian"
},

{
    "location": "diffresult.html#DiffBase.value!",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.value!",
    "category": "Function",
    "text": "value!(r::DiffResult, x)\n\nReturn s::DiffResult with the same data as r, except for value(s) == x.\n\nThis function may or may not mutate r. If r::ImmutableDiffResult, a totally new instance will be created and returned, whereas if r::MutableDiffResult, then r will be mutated in-place and returned. Thus, this function should be called as r = value!(r, x).\n\n\n\nvalue!(f, r::DiffResult, x)\n\nEquivalent to value!(r::DiffResult, map(f, x)), but without the implied temporary allocation (when possible).\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.derivative!",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.derivative!",
    "category": "Function",
    "text": "derivative!(r::DiffResult, x, ::Type{Val{i}} = Val{1})\n\nReturn s::DiffResult with the same data as r, except derivative(s, Val{i}) == x.\n\nThis function may or may not mutate r. If r::ImmutableDiffResult, a totally new instance will be created and returned, whereas if r::MutableDiffResult, then r will be mutated in-place and returned. Thus, this function should be called as r = derivative!(r, x, Val{i}).\n\n\n\nderivative!(f, r::DiffResult, x, ::Type{Val{i}} = Val{1})\n\nEquivalent to derivative!(r::DiffResult, map(f, x), Val{i}), but without the implied temporary allocation (when possible).\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.gradient!",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.gradient!",
    "category": "Function",
    "text": "gradient!(r::DiffResult, x)\n\nReturn s::DiffResult with the same data as r, except gradient(s) == x.\n\nEquivalent to derivative!(r, x, Val{1}); see derivative! docs for aliasing behavior.\n\n\n\ngradient!(f, r::DiffResult, x)\n\nEquivalent to gradient!(r::DiffResult, map(f, x)), but without the implied temporary allocation (when possible).\n\nEquivalent to derivative!(f, r, x, Val{1}); see derivative! docs for aliasing behavior.\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.jacobian!",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.jacobian!",
    "category": "Function",
    "text": "jacobian!(r::DiffResult, x)\n\nReturn s::DiffResult with the same data as r, except jacobian(s) == x.\n\nEquivalent to derivative!(r, x, Val{1}); see derivative! docs for aliasing behavior.\n\n\n\njacobian!(f, r::DiffResult, x)\n\nEquivalent to jacobian!(r::DiffResult, map(f, x)), but without the implied temporary allocation (when possible).\n\nEquivalent to derivative!(f, r, x, Val{1}); see derivative! docs for aliasing behavior.\n\n\n\n"
},

{
    "location": "diffresult.html#DiffBase.hessian!",
    "page": "DiffResult API Documentation",
    "title": "DiffBase.hessian!",
    "category": "Function",
    "text": "hessian!(r::DiffResult, x)\n\nReturn s::DiffResult with the same data as r, except hessian(s) == x.\n\nEquivalent to derivative!(r, x, Val{2}); see derivative! docs for aliasing behavior.\n\n\n\nhessian!(f, r::DiffResult, x)\n\nEquivalent to hessian!(r::DiffResult, map(f, x)), but without the implied temporary allocation (when possible).\n\nEquivalent to derivative!(f, r, x, Val{2}); see derivative! docs for aliasing behavior.\n\n\n\n"
},

{
    "location": "diffresult.html#Mutating-DiffResults-1",
    "page": "DiffResult API Documentation",
    "title": "Mutating DiffResults",
    "category": "section",
    "text": "DiffBase.value!\nDiffBase.derivative!\nDiffBase.gradient!\nDiffBase.jacobian!\nDiffBase.hessian!"
},

{
    "location": "index.html#",
    "page": "DiffBase.jl",
    "title": "DiffBase.jl",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#DiffBase.jl-1",
    "page": "DiffBase.jl",
    "title": "DiffBase.jl",
    "category": "section",
    "text": "DiffBase is a Julia package that provides common utilities and test functions that are used by various JuliaDiff packages.If you're a user of any JuliaDiff packages, you may want to check out DiffBase's DiffResult API, which can be used in conjunction with other packages in order to compute multiple orders of derivatives simultaneously."
},

]}

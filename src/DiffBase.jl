isdefined(Base, :__precompile__) && __precompile__()

module DiffBase

using Compat

include("results.jl")
include("testfuncs.jl")

######################
# Test Function Sets #
######################
#=
These functions are organized in sets based on input/output type. They are unary and not
in-place unless otherwised specified. These functions have been written with the following
assumptions:

- Array input is of length >= 5
- Matrix input is square
- Matrix inputs for n-ary functions are of equal shape
=#

const NUMBER_TO_NUMBER_FUNCS = (num2num_1, num2num_2, num2num_3, num2num_4, num2num_5)

const NUMBER_TO_ARRAY_FUNCS = (num2arr_1,)

const VECTOR_TO_NUMBER_FUNCS = (vec2num_1, vec2num_2, vec2num_3,
                                rosenbrock_1, rosenbrock_2, rosenbrock_3, rosenbrock_4,
                                ackley, self_weighted_logit)

const MATRIX_TO_NUMBER_FUNCS = (det, mat2num_1, mat2num_2, mat2num_3)

const INPLACE_ARRAY_TO_ARRAY_FUNCS = (chebyquad!, brown_almost_linear!, trigonometric!)

const ARRAY_TO_ARRAY_FUNCS = (-, chebyquad, brown_almost_linear, trigonometric)

const MATRIX_TO_MATRIX_FUNCS = (inv,)

const BINARY_MATRIX_TO_MATRIX_FUNCS = (+, .+, -, .-, *, .*, ./, .^,
                                       A_mul_Bt, At_mul_B, At_mul_Bt,
                                       A_mul_Bc, Ac_mul_B, Ac_mul_Bc)

const TERNARY_MATRIX_TO_NUMBER_FUNCS = (neural_step,)


end # module

using Base.Test
using RealInterface
using SpecialFunctions
using DiffBase: DiffRule

srand(1)

function finitediff(f, x)
    ϵ = cbrt(eps(typeof(x))) * max(one(typeof(x)), abs(x))
    return (f(x + ϵ) - f(x - ϵ)) / (ϵ + ϵ)
end

for f in RealInterface.UNARY_ARITHMETIC
    if !(in(f, DiffBase.TODO))
        deriv = DiffRule{f}(:x)
        @eval begin
            x = rand()
            @test isapprox($deriv, finitediff($f, x), rtol=0.05)
        end
    end
end

for f in RealInterface.UNARY_MATH
    if !(in(f, DiffBase.TODO))
        deriv = DiffRule{f}(:x)
        modifier = in(f, (:asec, :acsc, :asecd, :acscd, :acosh, :acoth)) ? 1 : 0
        @eval begin
            x = rand() + $modifier
            @test isapprox($deriv, finitediff($f, x), rtol=0.05)
        end
    end
end

for f in RealInterface.UNARY_SPECIAL_MATH
    if !(in(f, DiffBase.TODO))
        deriv = DiffRule{f}(:x)
        @eval begin
            x = rand()
            @test isapprox($deriv, finitediff($f, x), rtol=0.05)
        end
    end
end

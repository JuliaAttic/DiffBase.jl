struct DiffRule{F} end

macro diffrule(f)
    return :((::Type{DiffRule{$f}}))
end

(::Type{DiffRule{F}})(args...) where {F} = error("derivative not yet defined for $F")

const TODO = Symbol[:abs, :mod, :eta, :zeta, :airyaix, :airyaiprimex, :airybix,
                    :airybiprimex, :besseljx, :besselyx, :besselix, :besselkx, :besselh,
                    :besselhx, :hankelh1x, :hankelh2, :hankelh2x]

################
# General Math #
################

# unary #
#-------#

@diffrule(:+)(x)       = :(  1                                  )
@diffrule(:-)(x)       = :( -1                                  )
@diffrule(:sqrt)(x)    = :(  inv(2 * sqrt($x))                  )
@diffrule(:cbrt)(x)    = :(  inv(3 * cbrt($x)^2)                )
@diffrule(:abs2)(x)    = :(  $x + $x                            )
@diffrule(:inv)(x)     = :( -abs2(inv($x))                      )
@diffrule(:log)(x)     = :(  inv($x)                            )
@diffrule(:log10)(x)   = :(  inv($x) / log(10)                  )
@diffrule(:log2)(x)    = :(  inv($x) / log(2)                   )
@diffrule(:log1p)(x)   = :(  inv($x + 1)                        )
@diffrule(:exp)(x)     = :(  exp($x)                            )
@diffrule(:exp2)(x)    = :(  exp2($x) * log(2)                  )
@diffrule(:expm1)(x)   = :(  exp($x)                            )
@diffrule(:sin)(x)     = :(  cos($x)                            )
@diffrule(:cos)(x)     = :( -sin($x)                            )
@diffrule(:tan)(x)     = :(  1 + tan($x)^2                      )
@diffrule(:sec)(x)     = :(  sec($x) * tan($x)                  )
@diffrule(:csc)(x)     = :( -csc($x) * cot($x)                  )
@diffrule(:cot)(x)     = :( -(1 + cot($x)^2)                    )
@diffrule(:sind)(x)    = :(  (π / 180) * cosd($x)               )
@diffrule(:cosd)(x)    = :( -(π / 180) * sind($x)               )
@diffrule(:tand)(x)    = :(  (π / 180) * (1 + tand($x)^2)       )
@diffrule(:secd)(x)    = :(  (π / 180) * secd($x) * tand($x)    )
@diffrule(:cscd)(x)    = :( -(π / 180) * cscd($x) * cotd($x)    )
@diffrule(:cotd)(x)    = :( -(π / 180) * (1 + cotd($x)^2)       )
@diffrule(:asin)(x)    = :(  inv(sqrt(1 - $x^2))                )
@diffrule(:acos)(x)    = :( -inv(sqrt(1 - $x^2))                )
@diffrule(:atan)(x)    = :(  inv(1 + $x^2)                      )
@diffrule(:asec)(x)    = :(  inv(abs($x) * sqrt($x^2 - 1))      )
@diffrule(:acsc)(x)    = :( -inv(abs($x) * sqrt($x^2 - 1))      )
@diffrule(:acot)(x)    = :( -inv(1 + $x^2)                      )
@diffrule(:asind)(x)   = :(  180 / π / sqrt(1 - $x^2)           )
@diffrule(:acosd)(x)   = :( -180 / π / sqrt(1 - $x^2)           )
@diffrule(:atand)(x)   = :(  180 / π / (1 + $x^2)               )
@diffrule(:asecd)(x)   = :(  180 / π / abs($x) / sqrt($x^2 - 1) )
@diffrule(:acscd)(x)   = :( -180 / π / abs($x) / sqrt($x^2 - 1) )
@diffrule(:acotd)(x)   = :( -180 / π / (1 + $x^2)               )
@diffrule(:sinh)(x)    = :(  cosh($x)                           )
@diffrule(:cosh)(x)    = :(  sinh($x)                           )
@diffrule(:tanh)(x)    = :(  sech($x)^2                         )
@diffrule(:sech)(x)    = :( -tanh($x) * sech($x)                )
@diffrule(:csch)(x)    = :( -coth($x) * csch($x)                )
@diffrule(:coth)(x)    = :( -(csch($x)^2)                       )
@diffrule(:asinh)(x)   = :(  inv(sqrt($x^2 + 1))                )
@diffrule(:acosh)(x)   = :(  inv(sqrt($x^2 - 1))                )
@diffrule(:atanh)(x)   = :(  inv(1 - $x^2)                      )
@diffrule(:asech)(x)   = :( -inv($x * sqrt(1 - $x^2))           )
@diffrule(:acsch)(x)   = :( -inv(abs($x) * sqrt(1 + $x^2))      )
@diffrule(:acoth)(x)   = :(  inv(1 - $x^2)                      )
@diffrule(:deg2rad)(x) = :(  π / 180                            )
@diffrule(:rad2deg)(x) = :(  180 / π                            )
@diffrule(:gamma)(x)   = :(  digamma($x) * gamma($x)            )
@diffrule(:lgamma)(x)  = :(  digamma($x)                        )

# binary #
#--------#

@diffrule(:+)(x, y) = :(1),                  :(1)
@diffrule(:-)(x, y) = :(1),                  :(-1)
@diffrule(:*)(x, y) = :($y),                 :($x)
@diffrule(:/)(x, y) = :(inv($y)),            :(-$x / ($y^2))
@diffrule(:^)(x, y) = :($y * ($x^($y - 1))), :(($x^$y) * log($x))

####################
# SpecialFunctions #
####################

# unary #
#-------#

@diffrule(:erf)(x)         = :(  (2 / sqrt(π)) * exp(-$x * $x)       )
@diffrule(:erfinv)(x)      = :(  (sqrt(π) / 2) * exp(erfinv($x)^2)   )
@diffrule(:erfc)(x)        = :( -(2 / sqrt(π)) * exp(-$x * $x)       )
@diffrule(:erfcinv)(x)     = :( -(sqrt(π) / 2) * exp(erfinv($x)^2)   )
@diffrule(:erfi)(x)        = :(  (2 / sqrt(π)) * exp($x * $x)        )
@diffrule(:erfcx)(x)       = :(  (2 * x * erfcx($x)) - (2 / sqrt(π)) )
@diffrule(:dawson)(x)      = :(  1 - (2 * x * dawson($x))            )
@diffrule(:digamma)(x)     = :(  trigamma($x)                        )
@diffrule(:invdigamma)(x)  = :(  inv(trigamma(invdigamma($x)))       )
@diffrule(:trigamma)(x)    = :(  polygamma(2, $x)                    )
@diffrule(:airyai)(x)      = :(  airyaiprime($x)                     )
@diffrule(:airyaiprime)(x) = :(  $x * airyai($x)                     )
@diffrule(:airybi)(x)      = :(  airybiprime($x)                     )
@diffrule(:airybiprime)(x) = :(  $x * airybi($x)                     )
@diffrule(:besselj0)(x)    = :( -besselj1($x)                        )
@diffrule(:besselj1)(x)    = :(  (besselj0($x) - besselj(2, $x)) / 2 )
@diffrule(:bessely0)(x)    = :( -bessely1($x)                        )
@diffrule(:bessely1)(x)    = :(  (bessely0($x) - bessely(2, $x)) / 2 )

# binary #
#--------#

@diffrule(:besselj)(ν, x)   = :NaN, :(  (besselj($ν - 1, $x) - besselj($ν + 1, $x)) / 2   )
@diffrule(:besseli)(ν, x)   = :NaN, :(  (besseli($ν - 1, $x) + besseli($ν + 1, $x)) / 2   )
@diffrule(:bessely)(ν, x)   = :NaN, :(  (bessely($ν - 1, $x) - bessely($ν + 1, $x)) / 2   )
@diffrule(:besselk)(ν, x)   = :NaN, :( -(besselk($ν - 1, $x) + besselk($ν + 1, $x)) / 2   )
@diffrule(:hankelh1)(ν, x)  = :NaN, :(  (hankelh1($ν - 1, $x) - hankelh1($ν + 1, $x)) / 2 )
@diffrule(:hankelh2)(ν, x)  = :NaN, :(  (hankelh2($ν - 1, $x) - hankelh2($ν + 1, $x)) / 2 )
@diffrule(:polygamma)(m, x) = :NaN, :(  polygamma($m + 1, $x)                             )

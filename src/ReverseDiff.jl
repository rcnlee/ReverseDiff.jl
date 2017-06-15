module ReverseDiff

using Cassette
using Cassette: @defgenre, FunctionNote, Play, Record, Replay, Rewind, Cache,
                track, disarm, func, value, value!, cache, cache!, RealNote

using ForwardDiff

#############
# DiffGenre #
#############

@defgenre DiffGenre

@inline Cassette.promote_genre(a::DiffGenre, b::Cassette.ValueGenre) = a
@inline Cassette.promote_genre(a::Cassette.ValueGenre, b::DiffGenre) = b

@inline Cassette.note_cache(::DiffGenre, value::Number) = zero(value)
@inline Cassette.note_cache(::DiffGenre, value::AbstractArray) = zeros(value)

@inline Cassette.note_cache_eltype(::DiffGenre, cache::Union{Number,AbstractArray}) = eltype(cache)

##################
# Hook Fallbacks #
##################

@inline (p::Play{DiffGenre})(input...) = disarm(func(p))(input...)
@inline (r::Record{DiffGenre})(output, input::Tuple, cache...) = track(output, FunctionNote{DiffGenre}(func(r), input, cache...))

############
# includes #
############

include("derivatives/scalars.jl")

end # module

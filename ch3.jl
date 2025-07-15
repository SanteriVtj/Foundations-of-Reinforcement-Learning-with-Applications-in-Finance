using Distributions, Plots

abstract type State end

struct SimpleState<:State
    price
    next_state
    level
    α
end

function get_price(s::State)
    s.price
end

function probability_up(s::State)
    1/(1+exp(-s.α*(s.level-s.price)))
end

function next_state_simple(s::SimpleState)
    up_move = rand(Binomial(1, probability_up(s)))
    SimpleState(s.price+up_move*2-1, next_state_simple, s.level, s.α)
end

function simulate(s::S, n) where {S<:State}
    states = Vector{S}(undef, n)
    states[1] = s
    for i in 2:n
        states[i] = s.next_state(states[i-1])
    end
    states
end

x = simulate(SimpleState(10,next_state_simple,15.,.5),100)

plot(get_price.(x))

struct AR1State<:State
    price
    next_state
    pricem1
    α
end

function ar_probability(s::AR1State)
    0.5*(1-s.α*(s.price-s.pricem1))
end

function next_state_ar(s::AR1State)
    up_move = rand(Binomial(1, ar_probability(s)))
    SimpleState(s.price+up_move*2-1, next_state_ar1, s.price, s.α)
end

x_ar = simulate(AR1State(10,next_state_ar,10,.25), 100)
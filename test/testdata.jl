import Base: randstring

vowels = collect("aeiou")
consonants = setdiff(join('a':'z'), vowels)

"Generate a random pronounceable string 3 to 12 chars long"
function pronounceable()
  n = rand(3:8)
  s = rand(consonants, n)
  i = rand(1:3)
  while i <= n
    s[i] = rand(vowels)
    i += rand(1:3)
  end
  join(s)
end

"Turn a string into a number between 0 and 100"
numberfy(s::String) = sum(map(Int, collect(s))) % 1000

function rand_pairs()
  n = rand(1:500)
  map(1:n) do _
    s = pronounceable()
    (s, numberfy(s))
  end
end

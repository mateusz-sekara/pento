alias Pento.FAQ

1..100000 |>
Enum.each(fn _ ->
  what = for _ <- 1..10, into: "", do: <<Enum.random('abcdefghijklm')>>
  FAQ.create_question(%{
    question: "Who has " <> Enum.random(~w(broken taken matched skipped)) <> what,
    answer: Enum.random(~w(sekara grot pocahontas)),
    votes: Enum.random(1..100)
  })
end)

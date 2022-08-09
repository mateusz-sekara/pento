alias Pento.FAQ

questions = [
  %{
    question: "Meaning of life?",
    answer: "44",
    votes: -67,
  },
  %{
    question: "Who is the boss?",
    answer: "Sękara",
    votes: 1_000,
  },
  %{
    question: "Who is the padawan?",
    answer: "Grot",
    votes: 10,
  },
]

Enum.each(questions, fn q ->
  FAQ.create_question(q)
end)

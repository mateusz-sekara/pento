defmodule Pento.Repo.Migrations.AddUniqueIndexOnSurvey do
  use Ecto.Migration

  def change do
    # drop index(:ratings, [:user_id, :product_id], name: :index_ratings_on_user_product)


    create unique_index(:ratings, [:user_id, :product_id],
    name: :unique_index_ratings_on_user_product)
  end
end

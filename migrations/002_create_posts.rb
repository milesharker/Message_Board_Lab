Sequel.migration do
  up do
    create_table(:posts) do
      primary_key :id

      String :imagedata

      foreign_key :user_id
    end
  end

  down do
    drop_table(:posts)
  end
end
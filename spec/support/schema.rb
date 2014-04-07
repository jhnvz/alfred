ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.string :name
    t.string :email
    t.timestamps
  end

  create_table :posts, :force => true do |t|
    t.string :title
    t.string :body
    t.timestamps
  end

end

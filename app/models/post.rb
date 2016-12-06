class Post < ApplicationRecord
  self.table_name = "post"

  def self.search(search)
    Post.find_by_sql("SELECT * FROM post WHERE title LIKE '%#{search}%' OR body LIKE '%#{search}%'")

  end

  def categories
     Category.find_by_sql("SELECT * FROM category INNER JOIN post_category ON category.id = post_category.category
     WHERE category.id = post_category.category AND post_category.post = #{self.id};")
  end

  def comments
    Comment.find_by_sql "SELECT * FROM comment WHERE post = #{self.id};"
  end

  def starred_by(user)
    !Star.find_by_sql("SELECT * FROM star WHERE post = #{self.id} AND user = #{user.id} AND starred = true;").empty?
  end

  def author_name
        author = User.find_by_sql("SELECT * FROM user WHERE id = #{self.author};").first
        author.name
  end

  def format_date
    single_post =  User.find_by_sql("SELECT * FROM post WHERE id = #{self.id};").first
    require 'date'
    d = Date.parse(single_post.date.to_s)
    d.strftime("%v")
  end
end

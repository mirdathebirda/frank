class BlogsController < ApplicationController
  def show
    @blog = Blog.find_by_sql("SELECT * FROM blog where id = #{params[:id]};").first
  end

  def index
    if params[:user_id]
      @blogs = Blog.find_by_sql "SELECT * FROM blog WHERE owner = #{params[:user_id]};"
    else
      @blogs = Blog.find_by_sql "SELECT * FROM blog;"
    end
  end

  def new
  end

  def create
    cols = blog_params.keys.join(", ")
    vals = blog_params.values.map{|val| "\'#{val}\'" }.join(", ")
    Blog.connection.execute("INSERT INTO blog (owner, #{cols}) VALUES (#{current_user.id}, #{vals});")
    redirect_to "/users/#{current_user.id}/blogs"
  end

  def edit
    @blog = Blog.find_by_sql("SELECT * FROM blog where id = #{params[:id]};").first
  end

  def update
    updates = blog_params.map{|k, v| ["#{k}=\'#{v}\'"]}.join(", ")
    Blog.connection.execute("UPDATE blog SET #{updates} WHERE id = #{params[:id]};")
    redirect_to "/blogs/#{params[:id]}"
  end

private

  def blog_params
    params.require(:blog).permit(:title, :description)
  end
end
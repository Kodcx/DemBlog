class ApplicationController < ActionController::Base
	
	def update_post
		post = Post.find(params['id'])
		post.set_attributes('title' => params['title'], 'body' => params['body'], 'author' => params['author'])
		post.save

		redirect_to '/list_posts'

	# def hello_world
	# 	name = params['name'] || 'World'
	# 	render 'application/hello_world', locals: { name: name }
	end
	def list_posts
		posts = connection.execute("SELECT * FROM posts")

		render 'application/list_posts', locals:{ posts: posts }
	end
	def show_post
	 	post = Post.find(params['id'])

	 	render 'application/show_post', locals: { post: post }
	end

	def new_post
		render 'application/new_post'
		
	end

	def create_post

		post = Post.new('title' => params['title'],
										 'body' => params['body'],
										 'author' => params['author'])
		post.save
		redirect_to '/list_posts'

		# the below is the original code, prior to creating a model to hold SQL calls
		# insert_query = <<-SQL
		# INSERT INTO posts (title, body, author, created_at)
		# VALUES (?, ?, ?, ?)
		# SQL

		# connection.execute insert_query,
		# params['title'],
		# params['body'],
		# params['author'],
		# # params['created_at'] 
		# Date.current.to_s

		# redirect_to '/list_posts'
		# # require 'pry'; binding.pry;
	end

	def edit_post
		post = Post.find(params['id'])
		
		render 'application/edit_post', locals: {post: post}
	end

	# def update_post
	# 	post = Post.find(params['id'])
	# 	post.set_attributes('title' => params['title'], 'body' => params['body'], 'author' => params['author'])
	# 	post.save

	# 	redirect_to '/list_posts'
	# 	update_query = <<-SQL
	# 	UPDATE posts
	# 	SET title		 	 = ?,
	# 			body		 	 = ?,
	# 			author 	 	 = ?
	# 	WHERE posts.id = ?	
	# SQL

	# 	connection.execute update_query, params['title'], params['body'], params['author'], params['id']

	# end

	def self.find(id)
		post = connection.execute("SELECT * FROM posts WHERE posts.id = ? LIMIT 1", params['id']).first
		Post.new(post_hash)
	end

	def delete_post
		post = Post.find(params['id'])
		post.destroy
		
		redirect_to '/list_posts'
	end

	private 

	def self.connection
		db_connection = SQLite3::Database.new 'db/development.sqlite3'
		db_connection.results_as_hash = true
		db_connection

	end
	def connection
		self.class.connection
	end
end

class AppsController < ApplicationController

  before_filter :authenticate_user!

  # GET /apps
  # GET /apps.json
  def index
    @apps = current_user.apps

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apps }
    end
  end

  # GET /apps/1
  # GET /apps/1.json
  def show
    @app = App.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.json
  def new
    @app = App.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = App.find_by_name(params[:id])
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = App.new(params[:app])

    current_user.add_app @app

    respond_to do |format|
      if @app.save
        format.html { redirect_to @app, notice: 'App was successfully created.' }
        format.json { render json: @app, status: :created, location: @app }
      else
        format.html { render action: "new" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.json
  def update
    @app = App.find_by_name(params[:id])

    respond_to do |format|
      if @app.update_attributes(params[:app])
        format.html { redirect_to @app, notice: 'App was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @app = App.find_by_name(params[:id])
    @app.destroy

    respond_to do |format|
      format.html { redirect_to apps_url }
      format.json { head :no_content }
    end
  end

  def users
    @app = App.find(params[:id])
    respond_to do |format|
      format.html 
      format.json { render json: {} }
    end
  end

  def new_user
    @app = App.find(params[:id])
    users = User.where(:email => params[:user][:email])
    if(users.count > 0)
      user = users.first
    else
      user = User.new(params[:user])
      user.password = SecureRandom.hex(4)
      user.password_confirmation = user.password
    end

    if !user.apps.map(&:id).include?(@app.id)
      user.apps << @app
    end

    respond_to do |format|
      if user.save
        format.html { render :template => "apps/users", notice: 'User was added.' }
        format.json { render json: {} }
      else
        format.html { render :template => "apps/users", notice: 'Oops..something went wrong.' }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_user
    app = App.find(params[:id])
    user = User.find(params[:user_id])

    user.apps.delete app
    redirect_to app_users_path(app)
  end

  def distribution_lists
    @app = App.find(params[:id])
  end

  def new_distribution_list
    app = App.find(params[:id])

    dist_list = DistList.new
    dist_list.name = params[:distribution_list][:name]
    dist_list.app = app
    dist_list.save

    redirect_to app_distribution_lists_path(app)
  end

  def new_dist_list_user
    app = App.find(params[:id])
    dist_list = DistList.find(params[:list_id])

    users = User.where(:email => params[:user][:email])

    if(users.count > 0)
      user = users.first
    else
      user = User.new(params[:user])
      user.password = SecureRandom.hex(4)
      user.password_confirmation = user.password
      user.save
    end

    if !user.apps.map(&:id).include?(app.id)
      user.apps << app
    end

    if !user.dist_lists.map(&:id).include?(dist_list.id)
      user.dist_lists << dist_list
    end

    redirect_to app_distribution_lists_path(app)
  end

  def delete_dist_list_user
    dist_list = DistList.find(params[:list_id])
    user = User.find(params[:user_id])
    dist_list.users.delete user

    app = App.find(params[:app_id])
    redirect_to app_distribution_lists_path(app)
  end

  def delete_dist_list
    list = DistList.find(params[:list_id])

    list.users.delete_all
    list.destroy

    app = App.find(params[:app_id])

    redirect_to app_distribution_lists_path(app)
  end
end

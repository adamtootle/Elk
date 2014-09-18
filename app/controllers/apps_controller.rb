class AppsController < ApplicationController

  before_filter :authenticate_user!

  # GET /apps
  # GET /apps.json
  def index
    @apps = current_user.roles.map(&:app).sort! {|x,y| x.menu_order <=> y.menu_order}

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
    @app.owner = current_user

    all_apps = App.all.sort {|x,y| x.menu_order <=> y.menu_order}
    @app.menu_order = all_apps.last.menu_order + 1

    @app.save

    role = UserRole.new
    role.user = current_user
    role.app = @app
    role.role = UserRole::ROLES[:admin]
    role.save

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
    user = User.where(:email => params[:user][:email]).first
    if user.nil?
      user = User.new(params[:user])
      user.password = SecureRandom.hex(4)
      user.password_confirmation = user.password
      user.save
    end

    existing_role = UserRole.where(:user_id => user.id, :app_id => @app.id).first
    if existing_role.nil?
      role = UserRole.new
      role.user = user
      role.app = @app
      role.role = UserRole::ROLES[params[:user_role].to_sym] || UserRole::ROLES[:tester]
      role.save
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

  def edit_user
    app = App.find(params[:id])
    user = User.find(params[:user_id])
    role = UserRole.where(:user_id => user.id, :app_id => params[:id]).first
    if !role.nil? && app.owner != user
      role.role = UserRole::ROLES[params[:role].to_sym] || UserRole::ROLES[:tester]
      role.save
    end

    respond_to do |format|
      format.json { render json: {} }
    end
  end

  def delete_user
    app = App.find(params[:id])
    user = User.find(params[:user_id])

    app.distribution_lists.each do |list|
      if !list.users.map(&:id).find_index(user.id).nil?
        list.users.delete user
      end
    end

    user.roles.select{|role| role.app_id == app.id}.first.destroy
    redirect_to app_users_path(app)
  end

  def distribution_lists
    @app = App.find(params[:id])
    @distribution_lists = @app.distribution_lists

    emails_in_dist_lists = @distribution_lists.map(&:users).flatten
    all_app_user_emails = @app.roles.map(&:user)

    @users_without_distribution_lists = all_app_user_emails - emails_in_dist_lists
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

    user = User.where(:email => params[:user][:email]).first

    if user.nil?
      user = User.new(params[:user])
      user.password = SecureRandom.hex(4)
      user.password_confirmation = user.password
      user.save
    end

    existing_role = UserRole.where(:user_id => user.id, :app_id => app.id).first
    if existing_role.nil?
      role = UserRole.new
      role.user = user
      role.app = app
      role.role = UserRole::ROLES[:tester]
      role.save
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

  def update_apps_order
    params[:app_ids].each do |id|
      app = App.find(id)
      app.menu_order = params[:app_ids].find_index(id)
      app.save
    end

    respond_to do |format|
      format.json { render json: {:success => true} }
    end
  end
end

class ProjectsController < ApplicationController
before_action :set_project, only: [:show, :edit, :update, :destroy]


  def index
    @projects_admin = policy_scope(Project).where(admin: current_user).order(:deadline) # Projects.all where the current user is admin
    @projects_collaborator = policy_scope(UserProject.where(user: current_user)).map{ |user_project| user_project.project }  #UserProject.all where the current user is a user
    @project = Project.new
  end

  def show
    authorize(@project)
    @selected_milestone_id = params[:selected_milestone_id].to_i
  end

  def new
    @project = Project.new
    authorize(@project)
  end

  def create
    @project = Project.new(project_params)
    @project.admin = current_user
    authorize(@project)

    # add user projects
    member_ids = params[:user_ids]

    if member_ids
      member_ids.each do |member_id|
        @user = User.find(member_id)
        @user_project = @project.user_projects.new(user: @user)
      end
    end

    if @project.save
      redirect_to project_path(@project)
    end
  end

  def edit
    authorize(@project)
  end

  def destroy
    authorize(@project)
    @project.destroy
    redirect_to projects_path
  end

  def update
     if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :deadline, :photo, :photo_cache, :document, :description)
  end




end

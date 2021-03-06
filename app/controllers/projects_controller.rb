class ProjectsController < ApplicationController
  load_and_authorize_resource :project

  def index
    @projects = @projects.unscoped if params[:q] && params[:q][:s]
    @q = @projects.search(params[:q])
    @projects = @q.result
    @projects = @projects.order('weight DESC') if params[:q].nil?
    @projects = @projects.page(params[:page])
  end

  def show
  end

  def new
    @project.photos.build
  end

  def create
    @project.weight = begin (Project.order('weight DESC').first.weight + 1) rescue 0 end if @project.weight == 0
    if @project.save
      redirect_to edit_project_path(@project)
    else
      render :edit
    end
  end

  def edit
    @project.photos.build
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to edit_project_path(@project)
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end
end

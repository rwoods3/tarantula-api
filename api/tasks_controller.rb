module Api
  class TasksController < ApplicationController
    skip_filter :set_current_user_and_project, :apply_currents, :clean_data
    http_basic_authenticate_with name: "admin", password: "secret"
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/tasks -u "admin:secret"
    # Returns JSON array of all tasks associated with this project
    def index  
      render :json => Project.find(11).tasks
    end
    
    # Method: POST
    # Ex: curl -X POST -H "Content-Type: application/json" -d '{"created_at":"2014-05-16 02:49:23", "updated_at":"2014-05-16 02:49:23", "resource_id":"1", "resource_type":"test resource type 2", "description":"test task description 12", "assigned_to":"3", "finished":"0", "project_id":"11", "created_by":"3"}' localhost:3000/api/projects/11/tasks -u "admin:secret"
    # Creates a new task for this project.
    def create
      @task = Project.find(params[:project_id]).tasks.new
      #@task.type = params[:type] if params[:type]
      @task.created_at = params[:created_at] if params[:created_at]
      @task.updated_at = params[:updated_at] if params[:updated_at]
      @task.resource_id = params[:resource_id] if params[:resource_id]
      @task.resource_type = params[:resource_type] if params[:resource_type]
      @task.description = params[:description] if params[:description]
      @task.assigned_to = params[:assigned_to] if params[:assigned_to]
      @task.finished = params[:finished] if params[:finished]
      @task.project_id = params[:project_id] if params[:project_id]
      @task.created_by = params[:created_by] if params[:created_by]
      
      if @task.save
        render :json => {:status => :created}
      else
        render :json => {:error => @task.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/tasks/8 -u "admin:secret"
    # Returns a JSON object for this task.
    def show
      render :json => Project.find(params[:project_id]).tasks.find(params[:id])
    end
    
    # Method: DELETE
    # Ex: curl -X DELETE localhost:3000/api/projects/11/tasks/7 -u "admin:secret"
    # Deletes a task from this project.
    def destroy
      @task = Project.find(params[:project_id]).tasks.find(params[:id])
      
      if @task.destroy
        render :json => {:status => :ok}
      else
        render :json => {:error => @task.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: PUT
    # Ex: curl -X PUT -H "Content-Type: application/json" -d '{"resource_id":"3", "resource_type":"test update resource type", "description":"test update description", "created_at":"2014-01-01 00:00:00", "updated_at":"2014-01-01 00:00:00", "assigned_to":"28", "finished":"1", "project_id":"11", "created_by":"3"}'  localhost:3000/api/projects/11/tasks/8 -u "admin:secret"
    # Updates a task in this project.
    def update
      @task = Project.find(params[:project_id]).tasks.find(params[:id])
      
      if @task.update_attributes(resource_id: params[:resource_id], resource_type: params[:resource_type], description: params[:description], created_at: params[:created_at], updated_at: params[:updated_at], assigned_to: params[:assigned_to], finished: params[:finished], project_id: params[:project_id], created_by: params[:created_by])
        render :json => {:status => :ok}
      else
        render :json => {:error => @task.errors.full_messages, :status => :bad_request}
      end
    end
  end
end
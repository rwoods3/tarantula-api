module Api
  class ExecutionsController < ApplicationController
    skip_filter :set_current_user_and_project, :apply_currents, :clean_data
    http_basic_authenticate_with name: "admin", password: "secret"
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/executions -u "admin:secret"
    # Returns JSON array of all executions for this project
    def index  
      render :json => Project.find(11).executions
    end
    
    # Method: POST
    # Ex: curl -X POST -H "Content-Type: application/json" -d '{"name":"Test exec name 3", "created_at":"2014-05-16 02:49:23", "created_by":"28", "updated_at":"2014-05-16 02:49:23", "updated_by":"28", "test_set_id":"1", "test_set_version":"2", "deleted":"0", "version":"2", "test_object_id":"1", "project_id":"11", "completed":"1", "date":"2014-05-16", "archived":"0"}' localhost:3000/api/projects/11/executions -u "admin:secret"
    # Creates a new execution for this project.
    def create
      @execution = Project.find(params[:project_id]).executions.new
      @execution.name = params[:name] if params[:name]
      @execution.created_at = params[:created_at] if params[:created_at]
      @execution.created_by = params[:created_by] if params[:created_by]
      @execution.updated_at = params[:updated_at] if params[:updated_at]
      @execution.updated_by = params[:updated_by] if params[:updated_by]
      @execution.test_set_id = params[:test_set_id] if params[:test_set_id]
      @execution.test_set_version = params[:test_set_version] if params[:test_set_version]
      @execution.deleted = params[:deleted] if params[:deleted]
      @execution.version = params[:version] if params[:version]
      @execution.test_object_id = params[:test_object_id] if params[:test_object_id]
      @execution.project_id = params[:project_id] if params[:project_id]
      @execution.completed = params[:completed] if params[:completed]
      @execution.date = params[:date] if params[:date]
      @execution.archived = params[:archived] if params[:archived]
      
      if @execution.save
        render :json => {:status => :created}
      else
        render :json => {:error => @execution.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/executions/3 -u "admin:secret"
    # Returns a JSON object for this execution.
    def show
      render :json => Project.find(params[:project_id]).executions.find(params[:id])
    end
    
    # Method: DELETE
    # Ex: curl -X DELETE localhost:3000/api/projects/11/executions/3 -u "admin:secret"
    # Deletes a task from this project.
    def destroy
      @execution = Project.find(params[:project_id]).executions.find(params[:id])
      
      if @execution.destroy
        render :json => {:status => :ok}
      else
        render :json => {:error => @execution.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: PUT
    # Ex: curl -X PUT -H "Content-Type: application/json" -d '{"resource_id":"3", "resource_type":"test update resource type", "description":"test update description", "created_at":"2014-01-01 00:00:00", "updated_at":"2014-01-01 00:00:00", "assigned_to":"28", "finished":"1", "project_id":"11", "created_by":"3"}'  localhost:3000/api/projects/11/tasks/8 -u "admin:secret"
    # Updates a task in this project.
    def update
      @execution = Project.find(params[:project_id]).executions.find(params[:id])
      
      if @execution.update_attributes(name: params[:name], test_set_id: params[:test_set_id], created_at: params[:created_at], updated_at: params[:updated_at], updated_by: params[:updated_by], test_set_version: params[:test_set_version], deleted: params[:deleted], version: params[:version], test_object_id: params[:test_object_id], completed: params[:completed], date: params[:date], archived: params[:archived], project_id: params[:project_id], created_by: params[:created_by])
        render :json => {:status => :ok}
      else
        render :json => {:error => @execution.errors.full_messages, :status => :bad_request}
      end
    end
  end
end
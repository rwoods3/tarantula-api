module Api
  class TestSetsController < ApplicationController
    skip_filter :set_current_user_and_project, :apply_currents, :clean_data
    http_basic_authenticate_with name: "admin", password: "secret"
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/test_sets -u "admin:secret"
    # Returns JSON array of all test sets.
    def index  
      render :json => Project.find(params[:project_id]).test_sets.all
    end
    
    # Method: POST
    # Ex: curl -X POST -H "Content-Type: application/json" -d '{"name":"Test adding a test case to set", "created_by":"3", "project_id":"11", "date":"2014-09-05"}' localhost:3000/api/projects/11/test_sets -u "admin:secret"
    # Creates a new test set for this project.
    def create
      @testset = Project.find(params[:project_id]).test_sets.new
      @testset.name = params[:name] if params[:name]
      @testset.created_by = params[:created_by] if params[:created_by]
      @testset.created_at = params[:created_at] if params[:created_at]
      @testset.updated_by = params[:updated_by] if params[:updated_by]
      @testset.updated_at = params[:updated_at] if params[:updated_at]
      @testset.project_id = params[:project_id] if params[:project_id]
      @testset.version = params[:version] if params[:version]
      @testset.deleted = params[:deleted] if params[:deleted]
      @testset.external_id = params[:external_id] if params[:external_id]
      @testset.date = params[:date] if params[:date]
      @testset.archived = params[:archived] if params[:archived]
      
      if @testset.save
        render :json => {:status => :created}
      else
        render :json => {:error => @testset.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/test_sets/2 -u "admin:secret"
    # Returns the test set for this project.
    def show
      render :json => Project.find(params[:project_id]).test_sets.find(params[:id])
    end
    
    # Method: DELETE
    # Ex: curl -X DELETE localhost:3000/api/projects/11/test_sets/2 -u "admin:secret"
    # Deletes test set.
    def destroy
      @testset = Project.find(params[:project_id]).test_sets.find(params[:id])
      
      if @testset.destroy
        render :json => {:status => :ok}
      else
        render :json => {:error => @testset.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: PUT
    # Ex: curl -X PUT -H "Content-Type: application/json" -d '{"name":"update test set name", "created_at":"2014-05-16 02:49:23", "created_by":"3", "updated_at":"2014-05-16 02:49:23", "updated_by":"3", "project_id":"11", "version":"2", "deleted":"0", "priority":"low", "external_id":"0", "date":"2014-4-2", "archived":"0"}'  localhost:3000/api/projects/11/test_sets/3 -u "admin:secret"
    # Updates test case attributes.
    def update
      @testset = Project.find(params[:project_id]).test_sets.find(params[:id])
      
      if @testset.update_attributes(name: params[:name], created_at: params[:created_at], created_by: params[:created_by], updated_at: params[:updated_at], updated_by: params[:updated_by], project_id: params[:project_id], version: params[:version], deleted: params[:deleted], priority: params[:priority], external_id: params[:external_id], date: params[:date], archived: params[:archived])
        render :json => {:status => :ok}
      else
        render :json => {:error => @testset.errors.full_messages, :status => :bad_request}
      end
    end
  end
end
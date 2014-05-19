module Api
  class CasesController < ApplicationController
    skip_filter :set_current_user_and_project, :apply_currents, :clean_data
    http_basic_authenticate_with name: "admin", password: "secret"
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/test_sets/1/cases -u "admin:secret"
    # Returns JSON array of all test cases for this project in the test set
    def index  
      render :json => Project.find(params[:project_id]).test_sets.find(params[:test_set_id]).cases.all
    end
    
    # Method: POST
    # Ex: curl -X POST -H "Content-Type: application/json" -d '{"title":"Test adding a test case to set", "created_by":"3", "objective":"Test objective to add to test case in test set", "test_data":"test case to test set test data", "preconditions_and_assumptions":"precondition 1, preconditon 2", "time_estimate":"2", "project_id":"18", "date":"2014-09-05"}'  localhost:3000/api/projects/11/test_sets/1/cases -u "admin:secret"
    # Creates a new test case in this test set.
    def create
      @case = Project.find(params[:project_id]).test_sets.find(params[:test_set_id]).cases.new
      @case.title = params[:title] if params[:title]
      @case.created_by = params[:created_by] if params[:created_by]
      @case.created_at = params[:created_at] if params[:created_at]
      @case.updated_by = params[:updated_by] if params[:updated_by]
      @case.updated_at = params[:updated_at] if params[:updated_at]
      @case.objective = params[:objective] if params[:objective]
      @case.test_data = params[:test_data] if params[:test_data]
      @case.preconditions_and_assumptions = params[:preconditions_and_assumptions] if params[:preconditions_and_assumptions]
      @case.time_estimate = params[:time_estimate] if params[:time_estimate]
      @case.project_id = params[:project_id] if params[:project_id]
      @case.version = params[:version] if params[:version]
      @case.deleted = params[:deleted] if params[:deleted]
      @case.original_id = params[:original_id] if params[:original_id]
      @case.change_comment = params[:change_comment] if params[:change_comment]
      @case.external_id = params[:external_id] if params[:external_id]
      @case.change_comment = params[:change_comment] if params[:change_comment]
      @case.external_id = params[:external_id] if params[:external_id]
      @case.date = params[:date] if params[:date]
      @case.priority = params[:priority] if params[:priority]
      @case.archived = params[:archived] if params[:archived]
      
      if @case.save
        render :json => {:status => :created}
      else
        render :json => {:error => @case.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/test_sets/1/cases/1 -u "admin:secret"
    # Returns the test case belonging to this test set in the project.
    def show
      render :json => Project.find(params[:project_id]).test_sets.find(params[:test_set_id]).cases.find(params[:id])
    end
    
    # Method: DELETE
    # Ex: curl -X DELETE localhost:3000/api/projects/11/test_sets/1/cases/1 -u "admin:secret"
    # Deletes test case.
    def destroy
      @case = Project.find(params[:project_id]).test_sets.find(params[:test_set_id]).cases.find(params[:id])
      
      if @case.destroy
        render :json => {:status => :ok}
      else
        render :json => {:error => @case.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: PUT
    # Ex: curl -X PUT -H "Content-Type: application/json" -d '{"title":"Changing title for tc1", "preconditions_and_assumptions":"precondition 1, preconditon 2, precondition 3", "time_estimate":"4", "date":"2014-4-2", "priority":"high"}'  localhost:3000/api/projects/11/test_sets/2/cases/4 -u "admin:secret"
    # Updates test case attributes.
    def update
      @case = Project.find(params[:project_id]).test_sets.find(params[:test_set_id]).cases.find(params[:id])
      
      if @case.update_attributes(title: params[:title], objective: params[:objective], test_data: params[:test_data], preconditions_and_assumptions: params[:preconditions_and_assumptions], time_estimate: params[:time_estimate], project_id: params[:project_id], version: params[:version], deleted: params[:deleted], original_id: params[:original_id], change_comment: params[:change_comment], external_id: params[:external_id], date: params[:date], priority: params[:priority], archived: params[:archived])
        render :json => {:status => :ok}
      else
        render :json => {:error => @case.errors.full_messages, :status => :bad_request}
      end
      #begin
        #@case = Project.find(params[:project_id]).test_sets.find(params[:test_set_id]).cases.find(params[:id])
        #@case.update_attribute!(:title => params[:title]) if params[:title]
        #@case.update_attribute!(:created_by => params[:created_by]) if params[:created_by]
        #@case.update_attribute!(:created_at => params[:created_at]) if params[:created_at]
        #@case.update_attribute!(:updated_by => params[:updated_by]) if params[:updated_by]
        #@case.update_attribute!(:updated_at => params[:updated_at]) if params[:updated_at]
        #@case.update_attribute!(:objective => params[:objective]) if params[:objective]
        #@case.update_attribute!(:test_data => params[:test_data]) if params[:test_data]
        #@case.update_attribute!(:preconditions_and_assumptions => params[:preconditions_and_assumptions]) if params[:preconditions_and_assumptions]
        #@case.update_attribute!(:time_estimate => params[:time_estimate]) if params[:time_estimate]
        #@case.update_attribute!(:project_id => params[:project_id]) if params[:project_id]
        #@case.update_attribute!(:version => params[:version]) if params[:version]
        #@case.update_attribute!(:deleted => params[:deleted]) if params[:deleted]
        #@case.update_attribute!(:original_id => params[:original_id]) if params[:original_id]
        #@case.update_attribute!(:change_comment => params[:change_comment]) if params[:change_comment]
        #@case.update_attribute!(:external_id => params[:external_id]) if params[:external_id]
        #@case.update_attribute!(:change_comment => params[:change_comment]) if params[:change_comment]
        #@case.update_attribute!(:external_id => params[:external_id]) if params[:external_id]
        #@case.update_attribute!(:date => params[:date]) if params[:date]
        #@case.update_attribute!(:priority => params[:priority]) if params[:priority]
        #@case.update_attribute!(:archived => params[:archived]) if params[:archived]
      #rescue
        #render :json => {:error => @case.errors.full_messages, :status => :bad_request}
      #else
        #render :json => {:status => :ok}
      #end
    end
    
    # Method: GET
    # Ex: /api/projects/:project_id/test_sets/:test_set_id/cases/not_in_set
    # Returns cases that are not in the set
    def not_in_set
      # TODO: Return cases not in set
    end
  end
end
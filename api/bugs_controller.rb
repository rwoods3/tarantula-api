module Api
  class BugsController < ApplicationController
    skip_filter :set_current_user_and_project, :apply_currents, :clean_data
    http_basic_authenticate_with name: "admin", password: "secret"
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/bugs -u "admin:secret"
    # Returns JSON array of all bugs for this project
    def index  
      render :json => Project.find(11).bug_tracker.bugs
    end
    
    # Method: POST
    # Ex: curl -X POST -H "Content-Type: application/json" -d '{"bug_tracker_id":"2", "bug_severity_id":"5", "summary":"Test update summary", "created_at":"2014-01-01 00:00:00", "updated_at":"2014-01-01 00:00:00", "bug_product_id":"1", "bug_component_id":"1", "external_id":"0", "status":"updated status", "created_by":"4", "priority":"high", "reported_via_tarantula":"1", "url":"http://www.updatedtesturl.com"}'  localhost:3000/api/projects/11/bugs -u "admin:secret"
    # Creates a new bug in this project's bug tracker.
    def create
      @bug = Project.find(params[:project_id]).bug_tracker.bugs.new
      @bug.bug_tracker_id = params[:bug_tracker_id] if params[:bug_tracker_id]
      @bug.created_at = params[:created_at] if params[:created_at]
      @bug.updated_at = params[:updated_at] if params[:updated_at]
      @bug.bug_severity_id = params[:bug_severity_id] if params[:bug_severity_id]
      @bug.external_id = params[:external_id] if params[:external_id]
      @bug.summary = params[:summary] if params[:summary]
      @bug.bug_product_id = params[:bug_product_id] if params[:bug_product_id]
      @bug.bug_component_id = params[:bug_component_id] if params[:bug_component_id]
      @bug.status = params[:status] if params[:status]
      @bug.created_by = params[:created_by] if params[:created_by]
      @bug.priority = params[:priority] if params[:priority]
      @bug.reported_via_tarantula = params[:reported_via_tarantula] if params[:reported_via_tarantula]
      @bug.url = params[:url] if params[:url]
      @bug.lastdiffed = params[:lastdiffed] if params[:lastdiffed]
      
      if @bug.save
        render :json => {:status => :created}
      else
        render :json => {:error => @bug.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/bugs/1 -u "admin:secret"
    # Returns a JSON object for this bug.
    def show
      render :json => Project.find(params[:project_id]).bug_tracker.bugs.find(params[:id])
    end
    
    # Method: DELETE
    # Ex: curl -X DELETE localhost:3000/api/projects/11/bugs/1 -u "admin:secret"
    # Deletes a bug from this projects bug tracker.
    def destroy
      @bug = Project.find(params[:project_id]).bug_tracker.bugs.find(params[:id])
      
      if @bug.destroy
        render :json => {:status => :ok}
      else
        render :json => {:error => @bug.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: PUT
    # Ex: curl -X PUT -H "Content-Type: application/json" -d '{"bug_tracker_id":"3", "bug_severity_id":"1", "external_id":"1", "summary":"test update summary", "created_at":"2014-01-01 00:00:00", "updated_at":"2014-01-01 00:00:00", "bug_product_id":"1", "bug_component_id":"1", "status":"closed", "created_by":"3", "priority":"high", "reported_via_tarantula":"1", "url":"www.testupdated.com"}'  localhost:3000/api/projects/11/bugs/1 -u "admin:secret""
    # Updates a bug in this project.
    def update
      @bug = Project.find(params[:project_id]).bug_tracker.bugs.find(params[:id])
      
      if @bug.update_attributes(bug_tracker_id: params[:bug_tracker_id], bug_severity_id: params[:bug_severity_id], external_id: params[:external_id], summary: params[:summary], created_at: params[:created_at], updated_at: params[:updated_at], bug_product_id: params[:bug_product_id], bug_component_id: params[:bug_component_id], status: params[:status], created_by: params[:created_by], priority: params[:priority], reported_via_tarantula: params[:reported_via_tarantula], url: params[:url])
        render :json => {:status => :ok}
      else
        render :json => {:error => @bug.errors.full_messages, :status => :bad_request}
      end
    end
  end
end